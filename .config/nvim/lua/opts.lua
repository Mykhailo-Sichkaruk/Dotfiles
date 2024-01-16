require "utils"

vim.opt.hidden = true
vim.opt.swapfile = false 
vim.opt.foldenable = false
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.scrolloff = 3

vim.cmd "au BufRead,BufNewFile *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4"
vim.cmd "au BufRead,BufNewFile *.rs setlocal tabstop=4 softtabstop=4 shiftwidth=4"
vim.cmd [[
augroup makefile_settings
  autocmd!
  autocmd FileType make set noexpandtab
  autocmd FileType make set tabstop=4
  autocmd FileType make set shiftwidth=4
augroup END
]]
vim.cmd [[
  augroup DisableSyntaxOnLargeFiles 
  autocmd!
  augroup END
]]

vim.g.c_syntax_for_h = 1
vim.opt.fileencoding = 'utf-16'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamed'

vim.opt.spell = false
vim.opt.spelllang = 'en_us'
vim.opt.spellsuggest = "best,9"
vim.opt.iminsert = 0
vim.opt.imsearch = -1
-- vim.opt.keymap = 'russian-jcukenwin'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.showmode = false
vim.opt.signcolumn = 'no'
vim.opt.cursorline = true
vim.opt.cmdheight = 0
-- vim.opt.colorcolumn = "81,101"

-- vim.opt.loaded_perl_provider = 0

-- let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
-- vim.opt.vimspector_enable_mappings = 'VISUAL_STUDIO'
vim.g.vimspector_enable_mappings = 'VISUAL_STUDIO'
vim.opt.list = false

vim.opt.termguicolors = true

vim.g.vimsyn_embed = 'l'

vim.mapleader = ' '
vim.g.mapleader = ' '

vim.opt.guifont = "fira-code font 11"

vim.g.skip_ts_context_commentstring_module = true 
vim.g.netrw_fastbrowse = 0
-- vim.g.netrw_browsex_viewer = os.getenv("BROWSER") or "qutebrowser"

vim.filetype.add({
  extension = {
    typ = "typst",
    zsh = "sh",
    fish = "fish",
    conf = "config",
    asm = "nasm",
    md = "markdown"
  },
  filename = {
    ['.zshrc'] = "sh",
    ['.env'] = "config",
    ['.env.example'] = "config",
    ['.prettierrc'] = "json"
    -- ['rkt'] = "scheme",
    -- ['rktl'] = "scheme",
    -- ['rktd'] = "scheme",
  }

})

vim.cmd "command! W :w!"
