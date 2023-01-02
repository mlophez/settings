

local notes = {}

vim.api.nvim_create_user_command(
  'NotesFollowLink',
  function()
    local match = 0
    local column = 0
    local r,c = unpack(vim.api.nvim_win_get_cursor(0))
    --print(r, c)
    --local se = vim.fn.search([[.*?]])
    --print(se)
    --print(vim.fn.getline(r))
    for c in string.gmatch(vim.fn.getline(r),'.') do 
      if (c == '[') then
        match = match + 1
        if (match > 1) then
          vim.api.nvim_win_set_cursor(0, {r, column+1})
          return
        end
      else
        match = 0
      end
      column = column + 1
    end
  end,
  {nargs = 0, desc = 'Apply prose settings'}
)

vim.api.nvim_set_keymap("n", "f", ":NotesFollowLink<cr>", { noremap = true, silent = true })
