return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- =========================================================================
    -- DASHBOARD INITIALIZATION
    -- =========================================================================
    dashboard = {
      enabled = true,
      sections = {
        -- 1. FULL-WINDOW BACKDROP: HIGH-SPEED ANGLED PARTICLE STREAMS
        {
          section = "terminal",
        },

        -- 2. PRIMARY CONTROL HEADER
        {
          title = "📌 Pinned Active Workspaces",
          padding = 2,
          align = "center"
        },

        -- 3. MANUALLY PINNED PROJECTS (Update paths to match your machine)
        {
          section = "keys",
          gap = 1,
          padding = 1,
          align = "center",
          items = {
            {
              icon = "📁 ",
              key = "p",
              desc = "Core Backend Service",
              action = function()
                vim.cmd("cd ~/projects/backend-api")
                Snacks.picker.files()
              end
            },
            {
              icon = "⚛️  ",
              key = "f",
              desc = "Frontend Application",
              action = function()
                vim.cmd("cd ~/projects/frontend-client")
                Snacks.picker.files()
              end
            },
            {
              icon = "⚙️  ",
              key = "c",
              desc = "Neovim Configuration",
              action = function()
                vim.cmd("edit $MYVIMRC")
              end
            },
          },
        },

        -- 4. AUTOMATED HISTORY SECTIONS
        {
          icon = "🗂️  ",
          title = "Recent Git Workspaces",
          section = "projects",
          indent = 12, -- Offsets items nicely relative to the centered layout
          padding = 1,
          limit = 5
        },
        {
          icon = "🕒 ",
          title = "Recently Touched Files",
          section = "recent_files",
          indent = 12,
          padding = 1,
          limit = 5
        },

        -- 5. PERFORMANCE METRICS FOOTER
        {
          section = "startup",
          padding = 1
        },
      },
    },

    picker = {
      enabled = true
    },
  },
}
