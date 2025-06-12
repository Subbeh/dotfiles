return {
  "folke/snacks.nvim",

  dependencies = {
    "nvim-telescope/telescope.nvim",
    "folke/persistence.nvim",
  },
  priority = 1000,
  lazy = false,

  keys = {
    { "<leader>sN", function() require("snacks").notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() require("snacks").bufdelete() end,             desc = "Delete Buffer" },
    { "<leader>gB", function() require("snacks").gitbrowse() end,             desc = "Git Browse",          mode = { "n", "v" } },
  },

  config = function()
    local snacks = require("snacks")
    local icons = require("config.icons")

    snacks.setup({
      animate = { enabled = true },
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = icons.ui.FindFile, key = "f", desc = "Find File",       action = "<cmd>lua require('telescope').extensions.smart_open.smart_open({ cwd_only = true })<cr>" },
            { icon = icons.ui.NewFile,  key = "n", desc = "New File",        action = ":ene | startinsert" },
            { icon = icons.ui.FindText, key = "g", desc = "Find Text",       action = ":Telescope live_grep" },
            { icon = icons.ui.Files,    key = "r", desc = "Recent Files",    action = ":Telescope oldfiles" },
            { icon = icons.ui.Config,   key = "c", desc = "Config",          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = icons.ui.Refresh,  key = "s", desc = "Restore Session", section = "session" },
            { icon = icons.misc.Lazy,   key = "L", desc = "Lazy",            action = ":Lazy",                                                                                  enabled = package.loaded.lazy ~= nil },
            { icon = icons.ui.Exit,     key = "q", desc = "Quit",            action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { icon = icons.ui.Keyboard,   title = "Keymaps",      section = "keys",         indent = 2, padding = 1 },
          { icon = icons.ui.Files,      title = "Recent Files", section = "recent_files", indent = 2, padding = 1, cwd = true },
          { icon = icons.ui.FolderOpen, title = "Projects",     section = "projects",     indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              snacks.gitbrowse()
            end,
          },
          function()
            local in_git = snacks.git.get_root() ~= nil
            local cmds = {
              {
                icon = icons.git.Branch,
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
              {
                icon = icons.git.PR,
                title = "Open PRs",
                cmd = "gh pr list -L 3",
                key = "p",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 7,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 2,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
          { section = "startup" },
        },
      },
      dim = { enabled = true },
      chunk = { enabled = true },
      debug = { enabled = true },
      gitbrowse = { enabled = true },
      indent = {
        enabled = true,
        priority = 1,
        char = icons.ui.LineLeft,
        only_scope = false,
        only_current = false,
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      toggle = { enabled = true },
    })
  end,

  init = function()
    local snacks = require("snacks")
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          require("snacks").debug.inspect(...)
        end
        _G.bt = function()
          require("snacks").debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        snacks.toggle.diagnostics():map("<leader>cD")
        snacks.toggle.line_number():map("<leader>ul")
        snacks.toggle.treesitter():map("<leader>ut")
        snacks.toggle.inlay_hints():map("<leader>uh")
        -- snacks.toggle.indent():map("<leader>ui")
        snacks.toggle.dim():map("<leader>ud")
      end,
    })
    local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
    vim.api.nvim_create_autocmd("User", {
      pattern = "NvimTreeSetup",
      callback = function()
        local events = require("nvim-tree.api").events
        events.subscribe(events.Event.NodeRenamed, function(data)
          if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
            data = data
            require("snacks").rename.on_rename_file(data.old_name, data.new_name)
          end
        end)
      end,
    })
  end,
}
