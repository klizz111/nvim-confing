-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- 用 fzf-lua 替换默认“找文件/全文搜索”
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find Files (fzf-lua)" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Grep (fzf-lua)" })

-- 浮动终端：快速打开/切换
map("n", "<leader>tt", function()
  require("snacks").terminal.toggle()
end, { desc = "Terminal: Toggle (Snacks)" })

-- 运行命令：提示输入并执行
map("n", "<leader>tr", function()
  vim.ui.input({ prompt = "Run command: " }, function(cmd)
    if not cmd or cmd == "" then
      return
    end
    require("snacks").terminal.open(cmd)
  end)
end, { desc = "Terminal: Run command (Snacks)" })

