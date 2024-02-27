return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
          "rafamadriz/friendly-snippets",
        },
      },
    },
    config = function()
      local luasnip = require "luasnip"
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      local check_backspace = function()
        local col = vim.fn.col "." - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
      end

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load { paths = "/home/sysadm/.config/nvim/lua/plugins/snippets" }

      cmp.setup {
        experimental = { ghost_text = true },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        view = {
          entries = {
            name = "custom",
            selection_order = "top_down",
          },
          docs = {
            auto_open = true,
          },
        },
        window = {
          -- completion = {
          --   winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
          --   col_offset = -3,
          --   side_padding = 1,
          --   scrollbar = false,
          --   scrolloff = 8,
          -- },
          -- documentation = {
          --   winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
          -- },
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["C-h"] = function()
            if cmp.visible_docs() then
              cmp.close_docs()
            else
              cmp.open_docs()
            end
          end,
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              -- fallback()
              require("neotab").tabout()
            else
              require("neotab").tabout()
              -- fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        -- ordered by priority
        sources = cmp.config.sources {
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]

              if ctx.prev_context.filetype == "markdown" then
                return true
              end

              if kind == "Text" then
                return false
              end

              return true
            end,
          },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "buffer" },
          { name = "path" },
          { name = "treesitter" },
          { name = "crates" },
        },

        -- formatting = {
        --   fields = { "kind", "abbr", "menu" },
        -- },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 50,

            before = function(entry, vim_item)
              return vim_item
            end,
          },
        },
      }

      -- cmp.setup.cmdline({ "/", "?" }, {
      --   mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
      --   sources = { { name = "buffer" } },
      -- })

      -- cmp.setup.cmdline({ ":" }, {
      --   mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
      --   sources = { { name = "cmdline" }, { name = "path" } },
      -- })
    end,
  },
}
