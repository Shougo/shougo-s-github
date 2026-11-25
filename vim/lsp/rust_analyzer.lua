---@type vim.lsp.Config
-- Cargo.lock first: it exists only at the workspace root.
return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.lock', 'Cargo.toml', 'rust-project.json', '.git' },
}
