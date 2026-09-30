---@type vim.lsp.Config
return {
  root_dir = function(bufnr, callback)
    local root = vim.fs.root(bufnr, { 'package.json' })
    if root then
      callback(root)
    end
  end,
  workspace_required = true,
}
