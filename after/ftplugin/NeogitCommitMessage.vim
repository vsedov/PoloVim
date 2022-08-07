execute 'source '. expand('<sfile>:p:h') . '/gitcommit.vim'

lua << EOF
local cmp = require('cmp')
cmp.setup.filetype('NeogitCommitMessage', {
  sources = cmp.config.sources({
    { name = 'git' },
    { name = 'luasnip' },
    { name = 'spell' },
    { name = 'dictionary' },
  }, {
    { name = 'buffer' },
  }),
})
EOF
