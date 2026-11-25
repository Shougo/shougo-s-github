---@type vim.lsp.Config
return {
  cmd = { 'deno', 'lsp' },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  -- Attach only to Deno projects. vtsls.lua uses package.json.
  root_markers = {
    'deno.json',
    'deno.jsonc',
    'deno.lock',
    'deps.ts',
  },
  workspace_required = true,
  settings = {
    deno = {
      enable = true,
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          autoDiscover = false,
          -- Disable nest.land imports
          -- https://github.com/neovim/nvim-lspconfig/pull/2793
          hosts = {
            ['https://deno.land'] = true,
            ['https://x.nest.land'] = false,
          },
        },
      },
    },
  },
}
