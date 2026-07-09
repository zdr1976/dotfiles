local map = vim.keymap.set
local harpoon = require("config.harpoon")
local telescope = require("config.telescope")
local builtin = require("telescope.builtin")

map("n", "<F3>", "<Cmd>set number! number?<CR>", { silent = true, desc = "Toggle line numbers" })
map("i", "<F3>", "<C-o>:set number! number?<CR>", { silent = true, desc = "Toggle line numbers" })
map("n", "<F4>", "<Cmd>set list! list?<CR>", { silent = true, desc = "Toggle invisible characters" })
map("n", "<Leader>e", "<Cmd>Lexplore<CR>", { silent = true, desc = "Toggle file explorer" })
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

local window_maps = {
  ["<C-Up>"] = { "<C-W><C-K>", "Focus upper window" },
  ["<C-Down>"] = { "<C-W><C-J>", "Focus lower window" },
  ["<C-Left>"] = { "<C-W><C-H>", "Focus left window" },
  ["<C-Right>"] = { "<C-W><C-L>", "Focus right window" },
  ["<C-j>"] = { "<C-W><C-J>", "Focus lower window" },
  ["<C-k>"] = { "<C-W><C-K>", "Focus upper window" },
  ["<C-l>"] = { "<C-W><C-L>", "Focus right window" },
  ["<C-h>"] = { "<C-W><C-H>", "Focus left window" },
}

for lhs, rhs in pairs(window_maps) do
  map("n", lhs, rhs[1], { desc = rhs[2] })
end

map("n", "+", "<Cmd>resize +10<CR>", { silent = true, desc = "Increase window height" })
map("n", "-", "<Cmd>resize -10<CR>", { silent = true, desc = "Decrease window height" })
map("n", "<Leader>+", "<Cmd>vertical resize +10<CR>", { silent = true, desc = "Increase vertical split width" })
map("n", "<Leader>-", "<Cmd>vertical resize -10<CR>", { silent = true, desc = "Decrease vertical split width" })

map("n", "<Leader>n", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<Leader>m", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<Leader>b", builtin.buffers, { desc = "Find buffers" })

for tab = 1, 9 do
  map("n", "<Leader>" .. tab, tab .. "gt", { desc = "Go to tab " .. tab })
end

map("n", "<Leader>0", "<Cmd>tablast<CR>", { desc = "Go to last tab" })

map("n", "<C-p>", telescope.find_project_files, { desc = "Find project files" })
map("n", "<C-g>", builtin.live_grep, { desc = "Live grep" })
map("n", "<C-y>", harpoon.add_file, { desc = "Add file to Harpoon" })
map("n", "<C-e>", harpoon.toggle_menu, { desc = "Open Harpoon menu" })
map("n", "<Leader>hj", harpoon.prev, { desc = "Previous Harpoon file" })
map("n", "<Leader>hk", harpoon.next, { desc = "Next Harpoon file" })

map("n", "<Leader>w", [[:%s/\s\+$//<CR>]], { desc = "Trim trailing whitespace" })
