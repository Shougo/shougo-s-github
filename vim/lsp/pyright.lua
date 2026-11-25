---@type vim.lsp.Config
return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json', 'pyproject.toml', 'setup.py', 'setup.cfg',
    'requirements.txt', 'Pipfile', '.git',
  },
}
