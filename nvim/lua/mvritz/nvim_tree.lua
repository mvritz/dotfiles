local M = {}

M.setup = function()
  require('nvim-tree').setup({
    disable_netrw = true,
    auto_reload_on_write = true,
    create_in_closed_folder = false,
    open_on_tab = false,
    sort_by = 'name',
    hijack_unnamed_buffer_when_opening = false,
    hijack_cursor = true,
    root_dirs = {},
    prefer_startup_root = false,
    update_cwd = true,
    reload_on_bufenter = true,
    respect_buf_cwd = true,
    hijack_directories = {
      enable = true,
      auto_open = true,
    },
    update_focused_file = {
      enable = true,
      update_root = true,
      ignore_list = {},
    },
    system_open = {
      cmd = '',
      args = {},
    },
    git = {
      enable = true,
      ignore = true,
      timeout = 500,
    },
    view = {
      adaptive_size = false,
      centralize_selection = true,
      width = 50,
      side = 'left',
      preserve_window_proportions = true,
      number = false,
      relativenumber = false,
      signcolumn = 'yes',
      mappings = {
        custom_only = false,
        list = {},
      },
    },
    renderer = {
      root_folder_label = false,
      add_trailing = false,
      group_empty = false,
      full_name = true,
      highlight_git = false,
      highlight_opened_files = 'name',
      root_folder_modifier = ':~',
      indent_markers = {
        enable = true,
        icons = {
          corner = '└ ',
          edge = '│ ',
          item = '│ ',
          none = '  ',
        },
      },
      icons = {
        webdev_colors = true,
        git_placement = 'before',
        padding = ' ',
        symlink_arrow = ' ➛ ',
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
        glyphs = {
          default = '',
          symlink = '',
          git = {
            unstaged = '',
            staged = 'S',
            unmerged = '',
            renamed = '➜',
            deleted = '',
            untracked = 'U',
            ignored = '◌',
          },
          folder = {
            default = '',
            open = '',
            empty = '',
            empty_open = '',
            symlink = '',
          },
        },
      },
      special_files = {},
    },
    filters = {
      dotfiles = false,
      custom = {
        'node_modules',
      },
      exclude = {},
    },
    trash = {
      cmd = 'gio trash',
      require_confirm = true,
    },
    actions = {
      change_dir = {
        enable = true,
        global = false,
        restrict_above_cwd = false,
      },
      expand_all = {
        max_folder_discovery = 300,
      },
      open_file = {
        quit_on_open = false,
        resize_window = true,
        window_picker = {
          enable = true,
          chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
          exclude = {
            filetype = {
              'notify',
              'packer',
              'qf',
              'diff',
            },
            buftype = {
              'nofile',
              'terminal',
              'help',
            },
          },
        },
      },
      remove_file = {
        close_window = true,
      },

      use_system_clipboard = true,
    },
    live_filter = {
      -- maybe later
    },
    log = {
      enable = false,
    },
  })
end

return M
