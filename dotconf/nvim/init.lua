vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.config('nixd', {
    settings = {
        formatting = {
            command = { 'nixfmt' },
        },
    },
})
vim.lsp.enable('nixd')
