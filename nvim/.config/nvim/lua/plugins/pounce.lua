return {
  "rlane/pounce.nvim",

  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("pounce").pounce {} end,                   desc = "Pounce" },
    { "S", mode = { "n" },           function() require("pounce").pounce { do_repeat = true } end, desc = "Pounce Repeat" },
  },

  config = function()
    require("pounce").setup({
      accept_keys = "NTESIROAGJKDFVBYMCXWPQZ",
      accept_best_key = "<enter>",
      multi_window = true,
      debug = false,
    })
  end
}
