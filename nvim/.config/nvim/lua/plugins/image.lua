return {
  "3rd/image.nvim",
  enabled = false,
  event = "VeryLazy",
  config = function()
    package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
    package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

    require("image").setup({
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
          resolve_image_path = function(document_path, image_path, fallback)
            local working_dir = vim.fn.getcwd()
            local notes_dir = vim.fn.expand(vim.env.NOTES_DIR)
            -- Format image path for Obsidian notes
            if (working_dir:find(notes_dir, 1, true)) then
              return notes_dir .. "/attachments/" .. image_path
            end
            -- Fallback to the default behavior
            return fallback(document_path, image_path)
          end,
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    })
  end,
}
