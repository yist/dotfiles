require('searchbox').setup({
  popup = {
    relative = 'win',
    position = {
      row = '5%',
      col = '95%',
    },
    size = 30,
    border = {
      style = 'rounded',
      highlight = 'FloatBorder',
      text = {
        top = ' Search ',
        top_align = 'right',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal',
    },
  },
  hooks = {
    before_mount = function(input)
      -- code
    end,
    after_mount = function(input)
      -- code
    end
  }
})

vim.api.nvim_set_keymap(
  'n',
  '<leader>f',
  ':SearchBoxIncSearch<CR>',
  {noremap = true}
)

vim.api.nvim_set_keymap(
  'x',
  '<leader>f',
  ':SearchBoxIncSearch visual_mode=true<CR>',
  {noremap = true}
)
