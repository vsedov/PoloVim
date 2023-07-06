;; extends

; Import highlight groups
(import_statement
  name: (dotted_name
    (identifier) @EpicImportModule
  )
)

(import_statement
  name: (aliased_import
    name: (dotted_name
      (identifier) @EpicImportModule
    )
    alias: (identifier) @EpicImportModule
  )
)

(import_from_statement
  module_name: (dotted_name
    (identifier) @EpicImportModule
  )
  name: (dotted_name
    (identifier) @EpicImportModule
  )
)

(import_from_statement
  module_name: (dotted_name
    (identifier) @EpicImportModule
  )
  name: (aliased_import
    name: (dotted_name
      (identifier) @EpicImportModule
    )
    alias: (identifier) @EpicImportModule
  )
)

