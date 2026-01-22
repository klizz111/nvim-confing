local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },

    -- 禁用 Nerd Font 图标来源：nvim-web-devicons
    { "nvim-tree/nvim-web-devicons", enabled = false },

    -- 覆盖启动页（dashboard）里的“写死图标字符”，改成纯文本
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        opts = opts or {}

        -- 禁用依赖外部工具的模块，避免 health 大量报错
        opts.image = { enabled = false }
        opts.lazygit = { enabled = false }

        -- 如果你暂时没有 rg/fd，只保留 files，关闭 grep/explorer 相关入口（可选）
        opts.picker = opts.picker or {}
        opts.picker.grep = { enabled = false }
        opts.picker.explorer = { enabled = false }

        -- 尽可能全局关闭 Snacks 的图标（不同模块/版本字段不完全一致，这里做兼容兜底）
        local function disable_icons(t)
          if type(t) ~= "table" then
            return
          end
          -- 常见字段名
          if t.icons ~= nil then
            t.icons = false
          end
          if t.icon ~= nil and type(t.icon) ~= "string" then
            t.icon = false
          end
          if t.devicons ~= nil then
            t.devicons = false
          end
        end

        -- 对常见模块尝试关闭
        disable_icons(opts)
        disable_icons(opts.dashboard)
        disable_icons(opts.picker)
        disable_icons(opts.explorer)
        disable_icons(opts.terminal)
        disable_icons(opts.notifier)
        disable_icons(opts.quickfile)

        -- dashboard 的 key icons 已经是空字符串；这里再兜底一次
        opts.dashboard = opts.dashboard or {}
        opts.dashboard.preset = opts.dashboard.preset or {}
        if type(opts.dashboard.preset.keys) == "table" then
          for _, k in ipairs(opts.dashboard.preset.keys) do
            if type(k) == "table" then
              k.icon = ""
            end
          end
        end

        -- 只改 keys，避免大改动；把 icon 字符去掉
        opts.dashboard = opts.dashboard or {}
        opts.dashboard.preset = opts.dashboard.preset or {}
        opts.dashboard.preset.keys = {
          { icon = "", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = "", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
          { icon = "", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "", key = "s", desc = "Restore Session", section = "session" },
          { icon = "", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "", key = "q", desc = "Quit", action = ":qa" },
        }
      end,
    },

    -- GitHub Copilot
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      opts = {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<Tab>",
            accept_word = "<C-l>",
            accept_line = "<C-j>",
            next = "<C-n>",
            prev = "<C-p>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = true },
      },
    },

    -- Copilot Chat（聊天功能）
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim" },
      },
      cmd = { "CopilotChat", "CopilotChatToggle" },
      opts = {
        -- 默认即可；如需中文可在这里继续扩展
      },
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
