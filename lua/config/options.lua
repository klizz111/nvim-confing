-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
return {
	options = {
		termguicolors = false,
		background = dark,
	},

	autocmd = {
		{
			"VimEnter",
			pattern = "*",
			command = "set t_Co=256",
		},
	},
}
