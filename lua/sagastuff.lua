local saga = require 'lspsaga'
require('lspsaga.codeaction').code_action()
require('lspsaga.codeaction').range_code_action()


saga.init_lsp_saga {
	
	use_saga_diagnostic_sign = true, 
	code_action_prompt = {
	  enable = true,
	  sign = false,
	  sign_priority = 20,
	  virtual_text = false,
	},
	finder_definition_icon = '  ',
	finder_reference_icon = '  ',
	max_preview_lines = 30, -- preview lines of lsp_finder and definition preview

}




