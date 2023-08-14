;; extends
((pair
  (bare_key) @_key
  (string) @injection.content)
 (#vim-match? @_key "^hook_\w*")
 (#set! injection.language "vim")
 (#offset! @injection.content 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @injection.content)
 (#vim-match? @_key "^hook_\w*")
 (#vim-match? @injection.content "^('[^']|\"[^\"])")
 (#set! injection.language "vim")
 (#offset! @injection.content 0 1 0 -1))
((pair
  (bare_key) @_key
  (string) @injection.content)
 (#vim-match? @_key "^lua_\w*")
 (#set! injection.language "lua")
 (#offset! @injection.content 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @injection.content)
 (#vim-match? @_key "^lua_\w*")
 (#vim-match? @injection.content "^('[^']|\"[^\"])")
 (#set! injection.language "lua")
 (#offset! @injection.content 0 1 0 -1))
((table
  (bare_key) @_key
  (pair
   (string) @injection.content))
 (#eq? @_key "ftplugin")
 (#set! injection.language "vim")
 (#offset! @injection.content 0 3 0 -3))
((table
  (dotted_key) @_key
  (pair
   (string) @injection.content))
 (#eq? @_key "plugins.ftplugin")
 (#set! injection.language "vim")
 (#offset! @injection.content 0 3 0 -3))
