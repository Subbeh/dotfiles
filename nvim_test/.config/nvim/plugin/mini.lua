-- mini.nvim is loaded by colortheme.lua (vim.pack.add happens there)

-- Completion
require("mini.completion").setup({
  delay = { completion = 100, info = 100, signature = 50 },
  window = {
    info = { border = "single" },
    signature = { border = "single" },
  },
})

-- File explorer
require("mini.files").setup({
  mappings = {
    go_in = "l",
    go_in_plus = "<CR>",
    go_out = "h",
    go_out_plus = "H",
  },
  windows = {
    preview = true,
    width_preview = 40,
  },
})

vim.keymap.set("n", "<leader>e", function()
  local mf = require("mini.files")
  if not mf.close() then
    mf.open(vim.api.nvim_buf_get_name(0))
  end
end, { desc = "File explorer" })

vim.keymap.set("n", "<leader>E", function()
  require("mini.files").open(vim.uv.cwd())
end, { desc = "File explorer (cwd)" })

-- Motion
require("mini.jump").setup()
require("mini.jump2d").setup({
  mappings = { start_jumping = "<CR>" },
})

-- Textobjects
require("mini.ai").setup({
  n_lines = 500,
  custom_textobjects = {
    f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
    a = require("mini.ai").gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
  },
})

-- Surround
require("mini.surround").setup()

-- Autopairs
require("mini.pairs").setup()

-- Statusline
require("mini.statusline").setup({ use_icons = true })

-- Keymap hints
require("mini.clue").setup({
  triggers = {
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "'" },
    { mode = "n", keys = "`" },
    { mode = "x", keys = "'" },
    { mode = "x", keys = "`" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
  },
  clues = {
    require("mini.clue").gen_clues.builtin_completion(),
    require("mini.clue").gen_clues.g(),
    require("mini.clue").gen_clues.marks(),
    require("mini.clue").gen_clues.registers(),
    require("mini.clue").gen_clues.windows(),
    require("mini.clue").gen_clues.z(),
    { mode = "n", keys = "<Leader>c", desc = "+Code" },
    { mode = "n", keys = "<Leader>f", desc = "+Find" },
    { mode = "n", keys = "<Leader>g", desc = "+Git" },
    { mode = "n", keys = "<Leader>s", desc = "+System" },
    { mode = "n", keys = "<Leader>u", desc = "+UI" },
    { mode = "n", keys = "<Leader>x", desc = "+Copy" },
  },
  window = {
    delay = 300,
    config = { width = "auto" },
  },
})

-- Indent scope
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})

-- Icons
require("mini.icons").setup()
