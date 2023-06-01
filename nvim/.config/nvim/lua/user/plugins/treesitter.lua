local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

local ask_install = {}
function _G.ensure_treesitter_language_installed()
  local parsers = require "nvim-treesitter.parsers"
  local lang = parsers.get_buf_lang()
  if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) and ask_install[lang] ~= false then
    vim.schedule_wrap(function()
      vim.ui.select({"yes", "no"}, { prompt = "Install tree-sitter parsers for " .. lang .. "?" }, function(item)
        if item == "yes" then
          vim.cmd("TSInstall " .. lang)
        elseif item == "no" then
          ask_install[lang] = false
        end
      end)
    end)()
  end
end

vim.cmd [[autocmd FileType * :lua ensure_treesitter_language_installed()]]

treesitter.setup({
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "yaml", "json", "bash", "go", "html", "css", "ini", "markdown", "markdown_inline", "python", "regex", "terraform" },
  auto_install = true,
  highlight = {
    enable = true, -- false will disable the whole extension
  },

  autopairs = {
    enable = true,
  },

  indent = { enable = true, disable = { "python", "css" } },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>rx"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>rX"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },

    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
})
