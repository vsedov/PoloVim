(
 (function_call
   (identifier) @require_call
   (#match? @require_call "require")
   )
 (set! "priority" 105)
 )

(
 (function_call
   (identifier) @pairs
   (#match? @pairs "pairs")
   )
 (set! "priority" 105)
 )

(function_declaration
  (identifier)@function_definition
  )
(
 (function_declaration
   (dot_index_expression
     (identifier)
     (identifier)@function_definition
     )
   )
 (set! "priority" 105)
 )

(
 (assignment_statement
   (variable_list
     (identifier)@function_definition
     )
   (
    expression_list
    (function_definition)
    )
   )
 (set! "priority" 105)
 )
(
 (assignment_statement
   (variable_list
     (dot_index_expression
       (identifier)
       (identifier)@function_definition
       )
     )
   (
    expression_list
    (function_definition)
    )
   )
 (set! "priority" 105)
 )

; https://github.com/shift-d/nvim/tree/main/queries

(("return"   @keyword) (#set! conceal ""))
(("function" @keyword) (#set! conceal "ﬦ"))

;; Function names
((function_call name: (identifier) @function (#eq? @function "require")) (#set! conceal ""))

;; vim.*;; table.
((dot_index_expression table: (identifier) @keyword  (#eq? @keyword  "math" )) (#set! conceal ""))

(((dot_index_expression) @keyword (#eq? @keyword "vim.cmd"     )) (#set! conceal ""))
