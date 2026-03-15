-- lazyvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- visual plugins
require("lazy").setup({
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 }, -- Tema
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } }, -- Barra de status
})

-- UI
vim.opt.termguicolors = true
vim.cmd[[colorscheme tokyonight-storm]]
require('lualine').setup { options = { theme = 'tokyonight' } }

-- rm bg
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
