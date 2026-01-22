-- 在lua/plugins/目录下创建disable-icons.lua
return {
  { "nvim-tree/nvim-web-devicons", enabled = false },
  { "lualine.nvim", opts = { options = { icons_enabled = false } } },
}
