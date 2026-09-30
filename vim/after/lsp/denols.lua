---@type vim.lsp.Config
return {
  -- Disable nest.land imports
  -- https://github.com/neovim/nvim-lspconfig/pull/2793
  settings = {
    deno = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          autoDiscover = false,
          hosts = {
            ['https://x.nest.land'] = false,
          },
        },
      },
    },
  },
  root_markers = {
    'deno.json',
    'deno.jsonc',
    'deps.ts',
  },
  workspace_required = false,
}
