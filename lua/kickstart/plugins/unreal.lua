-- Shared so the build hook and opts.engine_path can't drift apart (they
-- previously used two different spellings of the same path, and the
-- unexpanded '~' one caused a stray directory to be created in the repo).
local engine_path = '/home/Venthryn/Programs/UnrealEngine/'

-- UBT's -Mode=GenerateClangDatabase (what generate_lsp()/build() call under
-- the hood) writes one compile-command entry per .cpp translation unit;
-- header files get none. clangd then has to *guess* which flags apply to a
-- header via its InterpolatingCompilationDatabase heuristic, and that guess
-- is a well-documented source of spurious errors on GENERATED_BODY() lines
-- (macro expansion needs UE-specific defines the guessed flags may lack) —
-- confirmed independently of the guess: a real UBT build with zero errors
-- can still show this in clangd. Fix: give each header its own real entry,
-- by copying its sibling .cpp's exact command (matching by basename, since
-- UE's Public/Private split puts them in different directories).
local function fix_compile_commands_headers()
  local path = vim.fn.getcwd() .. '/compile_commands.json'
  if vim.fn.filereadable(path) == 0 then
    vim.notify('No compile_commands.json in ' .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end

  local ok, entries = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), '\n'))
  if not ok or type(entries) ~= 'table' then
    vim.notify('Failed to parse compile_commands.json', vim.log.levels.ERROR)
    return
  end

  local existing_files, by_basename = {}, {}
  for _, entry in ipairs(entries) do
    existing_files[entry.file] = true
    if entry.file:match('%.cpp$') then
      by_basename[vim.fn.fnamemodify(entry.file, ':t:r')] = entry
    end
  end

  local new_entries, added = {}, 0
  for basename, cpp_entry in pairs(by_basename) do
    local cpp_dir = vim.fn.fnamemodify(cpp_entry.file, ':h')
    local candidate_dirs = {
      cpp_dir,
      (cpp_dir:gsub('/Private$', '/Public')),
      (cpp_dir:gsub('/Private/', '/Public/')),
    }
    for _, dir in ipairs(candidate_dirs) do
      for _, ext in ipairs { '.h', '.hpp' } do
        local header_path = dir .. '/' .. basename .. ext
        if not existing_files[header_path] and vim.fn.filereadable(header_path) == 1 then
          local header_entry = vim.deepcopy(cpp_entry)
          header_entry.file = header_path
          if header_entry.arguments then
            table.insert(header_entry.arguments, header_path)
          elseif header_entry.command then
            header_entry.command = header_entry.command .. ' ' .. header_path
          end
          table.insert(new_entries, header_entry)
          existing_files[header_path] = true
          added = added + 1
        end
      end
    end
  end

  if added == 0 then
    vim.notify('compile_commands.json: no missing header entries found', vim.log.levels.INFO)
    return
  end
  vim.list_extend(entries, new_entries)
  vim.fn.writefile({ vim.json.encode(entries) }, path)
  vim.notify(('compile_commands.json: added %d header entries'):format(added), vim.log.levels.INFO)
end

-- clangd only lazily reloads compile_commands.json (revalidated on the next
-- request, at most every 5s) and already-open buffers often don't visibly
-- refresh their diagnostics without an explicit restart, even once the
-- compile database is current after a rebuild. Deliberately NOT using the
-- :LspRestart Ex command: that only exists on Neovim 0.11.x and silently
-- breaks on 0.12+, since Neovim now ships its own native :lsp command that
-- supersedes it. This uses the native Lua API instead, which works on both.
local function restart_clangd()
  local clients = vim.lsp.get_clients { name = 'clangd' }
  if #clients == 0 then
    vim.notify('No active clangd client', vim.log.levels.WARN)
    return
  end
  for _, client in ipairs(clients) do
    client:stop(true)
  end
  local timer = assert(vim.uv.new_timer())
  timer:start(
    500,
    0,
    vim.schedule_wrap(function()
      vim.lsp.enable('clangd') -- re-fires FileType autocmd, reattaches open buffers
      timer:close()
    end)
  )
end

return {
  'mbwilding/UnrealEngine.nvim',
  lazy = false,
  dependencies = {
    -- optional, this registers the Unreal Engine icon to .uproject files
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {
      '<leader>ug',
      function()
        require('unrealengine.commands').generate_lsp()
      end,
      desc = 'UnrealEngine: Generate LSP',
    },
    {
      '<leader>ub',
      function()
        require('unrealengine.commands').build()
      end,
      desc = 'UnrealEngine: Build',
    },
    {
      '<leader>ur',
      function()
        require('unrealengine.commands').rebuild()
      end,
      desc = 'UnrealEngine: Rebuild',
    },
    {
      '<leader>uo',
      function()
        require('unrealengine.commands').open()
      end,
      desc = 'UnrealEngine: Open Editor',
    },
    {
      '<leader>uc',
      function()
        require('unrealengine.commands').clean()
      end,
      desc = 'UnrealEngine: Clean',
    },
    {
      '<leader>ue',
      function()
        require('unrealengine.commands').build_engine()
      end,
      desc = 'UnrealEngine: Link Plugin - Build Engine',
    },
    {
      '<leader>up',
      function()
        require('unrealengine.commands').build_plugin()
      end,
      desc = 'UnrealEngine: Build Plugin',
    },
    {
      '<leader>ui',
      function()
        fix_compile_commands_headers()
        restart_clangd()
      end,
      desc = 'UnrealEngine: Fix headers + restart clangd',
    },
  },
  -- Optional, this will update and build the Unreal Engine plugin on update
  build = function()
    require('unrealengine.commands').build_engine { engine_path = engine_path }
  end,
  opts = {
    auto_generate = true, -- Auto generates LSP info when detected in CWD | default: false
    auto_build = false, -- Auto builds on save | default: false
    engine_path = engine_path, -- Path to your UnrealEngine source directory
    build_type = 'Development', -- Build type: "DebugGame", "Development", or "Shipping"
    with_editor = true, -- Build with editor | default: true
    register_icon = true, -- Register Unreal Engine icon for .uproject files | default: true
    register_filetypes = true, -- Register .uproject and .uplugin as JSON | default: true
    close_on_success = true, -- Close terminal split on successful builds | default: true
    environment_variables = nil, -- Environment variables to pass when launching editor (Linux/Mac only)
  },
}
-- vim: ts=2 sts=2 sw=2 et
