return {
  {
    "nosduco/remote-sshfs.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function(_, _)
      local opts = {
        connections = {
          ssh_configs = { -- which ssh configs to parse for hosts list
            vim.fn.expand "$HOME" .. "/.ssh/config.d/hosts",
          },
          sshfs_args = { -- arguments to pass to the sshfs command
            "-o reconnect",
            "-o ConnectTimeout=5",
          },
        },
        mounts = {
          base_dir = vim.fn.expand "$HOME" .. "/.sshfs/", -- base directory for mount points
          unmount_on_exit = true, -- run sshfs as foreground, will unmount on vim exit
        },
        handlers = {
          on_connect = {
            change_dir = true, -- when connected change vim working directory to mount point
          },
          on_disconnect = {
            clean_mount_folders = false, -- remove mount point folder on disconnect/unmount
          },
          on_edit = {}, -- not yet implemented
        },
        ui = {
          select_prompts = false, -- not yet implemented
          confirm = {
            connect = false, -- prompt y/n when host is selected to connect to
          },
        },
      }
      require("remote-sshfs").setup(opts)
    end,
  },
}
