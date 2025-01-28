"---------------------------------------------------------------------------
" For Neovim:
"

if has('vim_starting') && argv()->empty()
  " Disable auto syntax loading
  syntax off
endif

" Disable remote providers
let g:loaded_node_provider = v:false
let g:loaded_perl_provider = v:false
let g:loaded_python_provider = v:false
let g:loaded_ruby_provider = v:false

" Disable remote plugin loading
let g:loaded_remote_plugins = 1

let g:python3_host_prog = has('win32') ? 'python.exe' : 'python3'

set inccommand=nosplit

set pumblend=20
set winblend=20

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable

let g:terminal_scrollback_buffer_size = 3000

autocmd MyAutoCmd TextYankPost *
      \ lua require'vim.highlight'.on_yank
      \ { higroup='IncSearch', timeout=100 }

" Opt-out for specific filetypes and huge files
" https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
function s:config_treesitter()
  lua << END
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      local disables_ft = {
        --'help',
      }
      local disables_lang = {
        'vimdoc',
        'diff',
        'gitcommit',
        'swift',
        'latex',
      }

      local ft = vim.fn.getbufvar(bufnr or vim.fn.bufnr(''), '&filetype')
      if (vim.tbl_contains(disables_ft, ft)
          or vim.tbl_contains(disables_lang, lang)) then
        return
      end

      if bufnr then
        local max_filesize = 50 * 1024 -- 50 KB
        local ok, stats = pcall(vim.loop.fs_stat,
            vim.api.nvim_buf_get_name(bufnr))
        if ok and stats and stats.size > max_filesize then
          return
        end
      end

      wrapped(bufnr, lang)
    end
  end)(vim.treesitter.start)
END
endfunction
autocmd MyAutoCmd Syntax * ++once call s:config_treesitter()

" Enable virtual_lines feature
"lua vim.diagnostic.config({ virtual_lines = { current_line = true }})

" For neovide
if 'g:neovide'->exists()
  let g:neovide_no_idle = v:true
  let g:neovide_cursor_animation_length = 0
  let g:neovide_cursor_trail_length = 0
  let g:neovide_hide_mouse_when_typing = v:true
endif

if has('win32')
  set guifont=Firge:h13
else
  set guifont=Monospace:h10
endif
