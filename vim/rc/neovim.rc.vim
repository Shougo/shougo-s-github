"---------------------------------------------------------------------------
" For Neovim:
"

if has('vim_starting')
  " Disable auto syntax loading: vimrc#on_filetype() enables it, also for
  " the files of the arguments (VimEnter). Otherwise the default
  " ":syntax on" after the vimrc detects their filetypes before they are
  " read, and FileType comes twice.
  syntax off
endif

" Disable remote providers
let g:loaded_node_provider = v:false
let g:loaded_perl_provider = v:false
let g:loaded_python_provider = v:false
let g:loaded_python3_provider = v:false
let g:loaded_ruby_provider = v:false

" Disable remote plugin loading
let g:loaded_remote_plugins = v:true

if has('nvim')
  set inccommand=nosplit

  set pumblend=20
  set winblend=20
endif

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable

let g:terminal_scrollback_buffer_size = 3000

autocmd MyAutoCmd TextYankPost *
      \ lua vim.hl.hl_op { higroup='IncSearch', timeout=200 }

" Opt-out for specific filetypes and huge files
" https://github.com/neovim/neovim/pull/26347#issuecomment-1837508178
function! s:config_treesitter() abort
  lua << END
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      local disables_ft = {
        'help',
      }
      local disables_lang = {
        'diff',
        'latex',
      }

      local ft = vim.fn.getbufvar(bufnr or vim.fn.bufnr(''), '&filetype')
      if (vim.tbl_contains(disables_ft, ft)
          or vim.tbl_contains(disables_lang, lang)) then
        return
      end

      if bufnr then
        local max_filesize = 50 * 1024 -- 50 KB
        local ok, stats = pcall(vim.uv.fs_stat,
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

" NOTE: vim.lsp takes long to load: it is loaded after the first screen,
" not in the FileType of the files of the arguments.
" The server configs are in lsp/*.lua.
function! s:config_lsp() abort
  lua << END
  -- NOTE: Disable lsp watcher. Too slow on linux
  -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
  require('vim.lsp._watchfiles')._watchfunc = function()
    return function() end
  end

  -- Disable semanticTokensProvider.  It is buggy.
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end,
  })

  vim.diagnostic.config({
      update_in_insert = false,
      virtual_text = {
        severity = {
          min = 'WARN',
        },
        severity_sort = true,
        format = function(diagnostic)
          if diagnostic.code then
            return string.format(
              '%s (%s: %s)',
              diagnostic.message,
              diagnostic.source,
              diagnostic.code
            )
          else
            return string.format(
              '%s (%s)',
              diagnostic.message,
              diagnostic.source
            )
          end
        end,
      },
  })

  vim.lsp.config('vimdoc_ls', {
    root_markers = { 'doc', '.git' },
    init_options = {
      tagPaths = {
        vim.env.VIMRUNTIME .. '/doc',
        vim.fn.expand('~/.cache/goda-pm/nvim/.goda_pm/doc/tags'),
      },
    },
  })

  -- https://github.com/neoclide/vimls-go
  -- $ go install github.com/neoclide/vimls-go/cmd/vimls@latest
  vim.lsp.config('vimls', {
    cmd = { 'vimls' },
    filetypes = { 'vim' },
    root_markers = { '.git' },
    settings = {
      vim = {
        diagnostic = {
          disabled = {
            'vimls/autocmd-group-not-cleared',
            'vimls/autoload-function-not-found',
            'vimls/catch-error-message',
            'vimls/duplicate-mapping',
            'vimls/explicit-local-scope',
          },
        },
      },
    },
    init_options = {
      runtimepath = vim.api.nvim_list_runtime_paths(),
      vimVersion = '9.2.1405',
    },
  })

  local servers = {
    'denols',
    'emmylua_ls',
    'gopls',
    'pyright',
    'rust_analyzer',
    'vimdoc_ls',
    'vimls',
    'vtsls',
  }

  vim.lsp.enable(servers)

  vim.api.nvim_exec_autocmds('FileType', {
    group = 'nvim.lsp.enable',
    buffer = vim.api.nvim_get_current_buf(),
  })
END
endfunction
autocmd MyAutoCmd FileType * ++once
      \ call timer_start(0, { -> s:config_lsp() })

if has('win32')
  set guifont=Firge:h13
else
  " NOTE: ng supports non OpenType fonts
  if 'g:ng'->exists()
    set guifont=Courier\ 10\ Pitch\ 15,VL\ Gothic\ 15
  else
    set guifont=Courier\ 10\ Pitch\ OT\ 16,VL\ Gothic\ 15
  endif

  set guifontwide=VL\ Gothic,Noto\ Sans\ Mono\ CJK\ JP
endif

"" Enable ext_cmdline/messages for the TUI
"" NOTE: It must be enabled at startup.
if !nvim_list_uis()->empty()
  lua require('vim._core.ui2').enable({
        \   enable = true,
        \   msg = { targets = 'msg' },
        \ })
endif
