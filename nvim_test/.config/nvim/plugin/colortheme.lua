vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local p = require("palette")

-- Map the named palette (from theme.yaml) onto the base16 slots.
-- base00-07 are the dark->light ramp; base08-0F are the accents.
require("mini.base16").setup({
  palette = {
    base00 = p.bg0, -- default background
    base01 = p.bg1, -- lighter background (statusline, cursorline)
    base02 = p.sel_bg, -- selection background
    base03 = p.bg2, -- comments, invisibles
    base04 = p.white, -- dark foreground (statusline)
    base05 = p.fg0, -- default foreground
    base06 = p.fg0, -- light foreground
    base07 = p.white_bright, -- light background
    base08 = p.red, -- variables, diff deleted
    base09 = p.orange, -- numbers, booleans, constants
    base0A = p.yellow, -- classes, search highlight
    base0B = p.green, -- strings, diff added
    base0C = p.cyan, -- support, regex, escapes
    base0D = p.blue, -- functions, methods
    base0E = p.magenta, -- keywords, storage
    base0F = p.red_bright, -- deprecated, embedded tags
  },
  use_cterm = true,
  plugins = {
    default = true,
  },
})
