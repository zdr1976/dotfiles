local map = vim.keymap.set
local telescope = require("config.telescope")

map("n", "<F3>", "<Cmd>set number! number?<CR>", { silent = true, desc = "Toggle line numbers" })
map("i", "<F3>", "<C-o>:set number! number?<CR>", { silent = true, desc = "Toggle line numbers" })
map("n", "<F4>", "<Cmd>set list! list?<CR>", { silent = true, desc = "Toggle invisible characters" })
map("n", "<F5>", "<Cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" })
map("n", "<F12>", "<Cmd>set spell!<CR>", { silent = true, desc = "Toggle spell checking" })

map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<C-n>", "<Cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlighting" })
map("v", "<C-n>", "<Cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlighting" })
map("i", "<C-n>", "<C-o>:nohlsearch<CR>", { silent = true, desc = "Clear search highlighting" })

map({ "n", "x" }, "<Leader>y", '"*y', { desc = "Yank to * clipboard" })
map("n", "<Leader>p", '"*p', { desc = "Paste from * clipboard" })
map({ "n", "x" }, "<Leader>Y", '"+y', { desc = "Yank to + clipboard" })
map("n", "<Leader>P", '"+p', { desc = "Paste from + clipboard" })

map("n", "<C-Up>", "<C-W><C-K>", { desc = "Focus upper window" })
map("n", "<C-Down>", "<C-W><C-J>", { desc = "Focus lower window" })
map("n", "<C-Left>", "<C-W><C-H>", { desc = "Focus left window" })
map("n", "<C-Right>", "<C-W><C-L>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-W><C-J>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-W><C-K>", { desc = "Focus upper window" })
map("n", "<C-l>", "<C-W><C-L>", { desc = "Focus right window" })
map("n", "<C-h>", "<C-W><C-H>", { desc = "Focus left window" })

map("n", "+", "<Cmd>resize +10<CR>", { silent = true, desc = "Increase window height" })
map("n", "-", "<Cmd>resize -10<CR>", { silent = true, desc = "Decrease window height" })
map("n", "<Leader>+", "<Cmd>vertical resize +10<CR>", { silent = true, desc = "Increase vertical split width" })
map("n", "<Leader>-", "<Cmd>vertical resize -10<CR>", { silent = true, desc = "Decrease vertical split width" })

map("n", "<Leader>n", "<Cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<Leader>m", "<Cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<Leader>1", "1gt", { desc = "Go to tab 1" })
map("n", "<Leader>2", "2gt", { desc = "Go to tab 2" })
map("n", "<Leader>3", "3gt", { desc = "Go to tab 3" })
map("n", "<Leader>4", "4gt", { desc = "Go to tab 4" })
map("n", "<Leader>5", "5gt", { desc = "Go to tab 5" })
map("n", "<Leader>6", "6gt", { desc = "Go to tab 6" })
map("n", "<Leader>7", "7gt", { desc = "Go to tab 7" })
map("n", "<Leader>8", "8gt", { desc = "Go to tab 8" })
map("n", "<Leader>9", "9gt", { desc = "Go to tab 9" })
map("n", "<Leader>0", "<Cmd>tablast<CR>", { desc = "Go to last tab" })

map("n", "<C-p>", telescope.find_project_files, { desc = "Find project files" })
map("n", "<C-g>", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

map("n", "<Leader>w", [[:%s/\s\+$//<CR>]], { desc = "Trim trailing whitespace" })
