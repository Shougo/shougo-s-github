;; extends
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^hook_\w*")
 (#offset! @none 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^hook_\w*")
 (#vim-match? @none "^('[^']|\"[^\"])")
 (#offset! @none 0 1 0 -1))
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^lua_\w*")
 (#offset! @none 0 3 0 -3))
((pair
  (bare_key) @_key
  (string) @none)
 (#vim-match? @_key "^lua_\w*")
 (#vim-match? @none "^('[^']|\"[^\"])")
 (#offset! @none 0 1 0 -1))
((table
  (bare_key) @_key
  (pair
   (string) @none))
 (#eq? @_key "ftplugin")
 (#offset! @none 0 3 0 -3))
((table
  (dotted_key) @_key
  (pair
   (string) @none))
 (#eq? @_key "plugins.ftplugin")
 (#offset! @none 0 3 0 -3))
