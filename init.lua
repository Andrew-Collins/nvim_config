# vim:fileencoding=utf-8:foldmethod=marker

-- Setup {{{
-- Locals
local cmd = vim.cmd
local call = vim.call
local fn = vim.fn
local g = vim.g
local keymap = vim.api.nvim_set_keymap
local opt = vim.opt
local Plug = vim.fn['plug#']

-- Check OS
if (fn.has("win32") or fn.has("win16")) then
    -- If windows then vim-plug is in AppData/Local
    call('plug#begin', '~/Appdata/Local/nvim/plugged')
else
    -- If linux then vim-plug is already on path 
    -- Set the clipboard to be unamedplus
    fn.set("clipboard=unnamedplus")
    if (fn.has("termguicolors")) then
        fn.set("termguicolors")
    end
    call('plug#begin', vim.fn.stdpath('data')..'/plugged')
    -- Helper functions for unix  
    Plug 'tpope/vim-eunuch'
end
-- }}}

-- Options/Vars {{{
--Options
opt.ts = 4
opt.sw = 4
opt.sts = 4
opt.et = true
opt.smd = false
opt.hidden = true
opt.showtabline = 2
opt.wmnu = true
opt.mouse = 'a'
opt.wig:append('*.o,*.d,*.obj,*.a,*.bin,*.elf,*.map,*.dir')
opt.path:append('**')
--Variables
g.mapleader = ';'
g.maplocalleader = ','
g.vimtex_view_method = 'mupdf'
--}}}

-- Misc {{{ 
-- Remove buffers from buffer list
cmd [[
augroup qf 
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END
]]
-- }}}

--Key Mapping{{{
-- General 
keymap('n', '<Tab>', "<cmd>bn<CR>",{silent = true})
keymap('n', '<S-Tab>', "<cmd>bp<CR>",{silent = true})
--DAP
keymap('n', '<leader>d', "<cmd>lua require'dap'.terminate()<CR> <cmd>lua require'dap'.continue()<CR>", {silent = true})
keymap('n', '<leader>c', "<cmd>lua require'dap'.continue()<CR>", {silent = true})
keymap('n', '<leader>n', "<cmd>lua require'dap'.step_over()<CR>", {silent = true})
keymap('n', '<leader>si', "<cmd>lua require'dap'.step_into()<CR>", {silent = true})
keymap('n', '<leader>so', "<cmd>lua require'dap'.step_out()<CR>", {silent = true})
keymap('n', '<leader>b', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", {silent = true})
keymap('n', '<leader>B', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", {silent = true})
keymap('n', '<leader>lp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {silent = true})
keymap('n', '<leader>dr', "<cmd>lua require'dap'.repl.open()<CR>", {silent = true})
keymap('n', '<leader>dl', "<cmd>lua require'dap'.terminate()<CR> <cmd>lua require'dap'.run_last()<CR>", {silent = true})

if (not fn.empty((fn.globpath('.','openocd.cfg')))) then
    keymap('n', '<leader>d', "<cmd>lua require'dap'.terminate()<CR> <cmd>AbortDispatch openocd<CR> <cmd>Dispatch! openocd<CR> <cmd>lua require'dap'.continue()<CR>", {silent = true})
    keymap('n', '<leader>dl', "<cmd>lua require'dap'.terminate()<CR> <cmd>AbortDispatch openocd<CR> <cmd>Dispatch! openocd<CR> <cmd>lua require'dap'.run_last()<CR>", {silent = true})
end
--}}}

-- Plugins{{{
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
-- LSP configurations using nvim builtin lsp
Plug 'neovim/nvim-lspconfig'
-- Nerdtree is a better netrw
Plug 'scrooloose/nerdtree'
-- Lualine 
Plug 'nvim-lualine/lualine.nvim'
-- Treesitter for nvim
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
-- Quality of life (small plugins)
-- Git wrapper :Git or :G"
Plug 'tpope/vim-fugitive'
-- Surrounds selections (visual, iw, etc) with characters, or changes them"
Plug 'tpope/vim-surround'
-- Sessions
Plug 'tpope/vim-obsession'
-- Allows for plugins such as vim-surround to use ."
Plug 'tpope/vim-repeat'
-- Sets default behaviour to be more sensible"
Plug 'tpope/vim-sensible'
-- Comment with gcc, gc in visual"
Plug 'tpope/vim-commentary'
-- Asynchronous building (use Make instead of make)
Plug 'tpope/vim-dispatch'
-- Local vimrc .lvimrc
Plug 'embear/vim-localvimrc'
-- Nvim Distant
Plug 'chipsenkbeil/distant.nvim'
--
-- Latex plugin
Plug 'lervag/vimtex'
-- Cmake 
Plug 'cdelledonne/vim-cmake'
-- DAP
-- DAP plugin
Plug 'mfussenegger/nvim-dap'
-- DAP UI
Plug 'rcarriga/nvim-dap-ui'
-- DAP Virtual Text
Plug 'theHamsta/nvim-dap-virtual-text'
--
Plug 'sainnhe/edge'

-- Initialize plugin system
call("plug#end")
--
--}}}

-- Plugin Config{{{

-- Colour Theme{{{
g.edge_style = 'aura'
g.edge_better_performance = 1
g.edge_transparent_background = 1
g.edge_dim_foreground = 1
cmd("colorscheme edge")

--}}}

-- Lualine {{{
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'edge',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {''},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {
            {
                'buffers',
                mode = 2,
                symbols = { 
                    modified = ' ●',      -- Text to show when the buffer is modified
                    alternate_file = '', -- Text to show to identify the alternate file
                    directory =  '',     -- Text to show when the buffer is a directory
                }
            }
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}
    },
    extensions = {}
}
-- }}}

-- Distant {{{
require'distant'.setup { ['*'] = require('distant.settings').chip_default() }
-- }}}

-- Treesitter{{{
require'nvim-treesitter.configs'.setup { ensure_installed = {"c", "rust", "python", "lua", "vim"}, sync_install = false, ignore_install = {}, highlight = { enable = true, disable = {}, additional_vim_regex_highlighting = false, },
}
--}}}
 
-- DAP{{{
local dap = require('dap')
local dapui = require('dapui')
dap.set_log_level "debug"
-- Virtual Text{{{
require("nvim-dap-virtual-text").setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = false,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false, 
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
}
--}}}
-- UI{{{
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- }}}
-- Adapters{{{
dap.adapters.python = {
  type = 'executable';
  command = os.getenv( "HOME" )..'/.local/share/nvim/mason/packages/debugpy/venv/bin/python3';
  args = { '-m', 'debugpy.adapter' };
}
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/ac/.vscode/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}
--}}}
-- Configurations{{{
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath ='/usr/bin/python'
    }
}
dap.configurations.cpp = {
  {
    name = "Default",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}
dap.configurations.rust = {
    {
        name = "Default",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
    },
}
--}}}
require('dap.ext.vscode').load_launchjs()
--}}}

-- LSPConfig{{{
local nvim_lsp = require('lspconfig')    
-- Use an on_attach function to only map the following keys    
-- after the language server attaches to the current buffer    
local on_attach = function(client, bufnr)    
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end    
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end    

  -- Enable completion triggered by <c-x><c-o>    
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')    

  -- Mappings.    
  local opts = { noremap=true, silent=true }    

  -- See `:help vim.lsp.*` for documentation on any of the below functions    
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)    
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)    
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)    
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)    
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)    
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)    
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)    
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)    
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)    
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)    
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)    
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)    
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)    

end    

-- Use a loop to conveniently call 'setup' on multiple servers and    
-- map buffer local keybindings when the language server attaches    
local servers = {'cmake', 'pyright', 'clangd', 'rust_analyzer'}    
for _, lsp in ipairs(servers) do    
  nvim_lsp[lsp].setup {    
	on_attach = on_attach,    
	flags = {    
	  debounce_text_changes = 150,    
	}    
  }    
end    
--}}}

-- Mason {{{
require("mason").setup{
    log_level = vim.log.levels.DEBUG
}
require("mason-lspconfig").setup({
    ensure_installed = {"cmake", "pyright", "clangd", "rust_analyzer"},
    -- automatic_installation = true,
})

-- }}}
--}}}
