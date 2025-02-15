return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },

  config = function()
    local colors = require("config.colors")
    local icons = require("config.icons")

    -- Define your custom theme here
    local custom_theme = {
      normal = {
        a = { fg = colors.bg1, bg = colors.blue.base, gui = "bold" },
        b = { fg = colors.fg1, bg = colors.bg0 },
        c = { fg = colors.fg1, bg = colors.bg1 },
      },
      insert = {
        a = { fg = colors.bg1, bg = colors.green.base, gui = "bold" },
      },
      visual = {
        a = { fg = colors.bg1, bg = colors.magenta.bright, gui = "bold" },
      },
      replace = {
        a = { fg = colors.bg1, bg = colors.red.base, gui = "bold" },
      },
      command = {
        a = { fg = colors.bg1, bg = colors.yellow.base, gui = "bold" },
      },
      inactive = {
        a = { fg = colors.fg0, bg = colors.bg1, gui = "bold" },
        b = { fg = colors.fg0, bg = colors.bg1 },
        c = { fg = colors.fg0, bg = colors.bg1 },
      },
    }

    local function buffs()
      local total = #vim.fn.getbufinfo({ buflisted = 1 })
      return string.format(" %s %s", icons.ui.Files, total)
    end

    local function fmts()
      -- Check if 'conform' is available
      local status, conform = pcall(require, "conform")
      if not status then
        return "Conform not installed"
      end

      local lsp_format = require("conform.lsp_format")

      -- Get formatters for the current buffer
      local formatters = conform.list_formatters_for_buffer()
      if formatters and #formatters > 0 then
        local formatterNames = {}

        for _, formatter in ipairs(formatters) do
          table.insert(formatterNames, formatter)
        end

        return table.concat(formatterNames, ",")
      end

      -- Check if there's an LSP formatter
      local bufnr = vim.api.nvim_get_current_buf()
      local lsp_clients = lsp_format.get_format_clients({ bufnr = bufnr })

      if not vim.tbl_isempty(lsp_clients) then
        return "lsp"
      end

      return ""
    end

    require("lualine").setup({
      options = {
        theme = custom_theme,
        component_separators = {},
        section_separators = {},
        always_divide_middle = true,
        globalstatus = true,

        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = { "NvimTree" },
      },

      sections = {
        lualine_a = {
          { "fancy_mode", width = 3 },
          { "fancy_macro" },
        },
        lualine_b = {
          {
            buffs,
            cond = function()
              return #vim.fn.getbufinfo({ buflisted = 1 }) > 1 and true or false
            end,
          },
          {
            "fancy_branch",
            icon = {
              icons.git.Branch,
              color = { fg = colors.red.bright },
            },
          },
          {
            "fancy_diagnostics",
            padding = { left = 0, right = 1 },
          },
        },
        lualine_c = {
          {
            "fancy_filetype",
            ts_icon = {
              icons.ui.Script,
              color = { fg = colors.green.base },
              align = "left",
            },
            color = { fg = colors.fg2 },
            padding = { left = 1, right = 1 },
          },
          {
            "fancy_lsp_servers",
            icon = {
              icons.ui.Config,
              color = { fg = colors.magenta.base },
            },
            color = { fg = colors.fg2 },
            padding = { left = 0, right = 0 },
          },
          {
            fmts,
            icon = {
              icons.ui.Pencil,
              color = { fg = colors.magenta.base },
            },
            color = { fg = colors.fg2 },
            padding = { left = 1, right = 1 },
          },
        },
        lualine_x = {
          {
            "fancy_cwd",
            substitute_home = true,
            color = { fg = colors.fg2 },
          },
          {
            function()
              return icons.ui.File
            end,
            padding = { left = 1, right = 0 },
            color = { fg = colors.blue.base },
          },
          {
            "filename",
            path = 1,
            padding = { left = 0, right = 1 },
            symbols = {
              modified = icons.ui.Circle, -- Text to show when the file is modified.
              readonly = "[RO]",          -- Text to show when the file is non-modifiable or readonly.
              unnamed = "[New]",          -- Text to show for unnamed buffers.
              newfile = icons.ui.NewFile, -- Text to show for newly created file before first write
            },
          },
        },
        lualine_y = {
          "fancy_searchcount",
        },
        lualine_z = {
          "progress",
        },
      },
      extensions = { "mason", "quickfix", "man", "fzf", "nvim-tree", "oil", "nvim-dap-ui", "lazy", "fugitive" },
    })
  end,
}
