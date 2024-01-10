return {
  -- devicons
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { "DaikyXendo/nvim-material-icon" },
    config = function()
      require("nvim-web-devicons").setup {
        override = require("nvim-material-icon").get_icons(),
      }
    end,
  },

  -- nonicons
  { "yamatsum/nvim-nonicons", config = true, enabled = false },
}
