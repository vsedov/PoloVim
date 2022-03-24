(
 function_item
 (
  identifier
  )@function_definition
 )

; https://github.com/shift-d/nvim/tree/main/queries
(("->" @operator) (#set! conceal ""))
(("=>" @operator) (#set! conceal ""))
(("fn" @keyword.function) (#set! conceal "ﬦ"))

(("struct" @keyword) (#set! conceal "ﴯ"))
(("enum"   @keyword) (#set! conceal ""))
(("let"    @keyword) (#set! conceal "~"))
(("impl"   @keyword) (#set! conceal "ﰠ"))
(("type"   @keyword) (#set! conceal ""))
(("use"    @keyword) (#set! conceal ""))
(("mod"    @keyword) (#set! conceal "ﮅ"))
(((visibility_modifier) @keyword) (#set! conceal ""))