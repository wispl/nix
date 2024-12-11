local map = vim.keymap.set

map("i", "jk", "<Esc>")

-- better movement for wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")
-- pair expansions on enter
map("i", "[<Cr>", "[<CR>]<Esc>O")
map("i", "(<Cr>", "(<CR>)<Esc>O")
map("i", "{<Cr>", "{<CR>}<Esc>O")
-- spelling
map("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u")

-- toggle options
map("n", "<leader>os", function() vim.opt_local.spell = not(vim.opt_local.spell:get()) end)
map("n", "<leader>ow", function() vim.opt_local.wrap = not(vim.opt_local.wrap:get()) end)

-- diagnostic and quickfix
map("n", "]q", "<cmd>cnext<cr>")
map("n", "[q", "<cmd>cprev<cr>")
map("n", "<leader>cd", function() vim.diagnostic.setloclist() end)

-- system clipboard
map({ "n", "x" }, "gy", '"+y')
map("n","gp", '"+p')

-- tabs
map("n", "<leader>tn", "<cmd>tabnew<cr>")
map("n", "<leader>tc", "<cmd>tcd %:h<cr>")
map("n", "]t", "<cmd>tabnext<cr>")
map("n", "[t", "<cmd>tabprev<cr>")
-- notes tab
map("n", "<leader>i", "<cmd>$tabnew ~/notes/index.md | tcd ~/notes<cr>")

-- windows
map("n", "<C-j>", "<C-W>j")
map("n", "<C-k>", "<C-W>k")
map("n", "<C-h>", "<C-W>h")
map("n", "<C-l>", "<C-W>l")
-- resize windows
map("n", "<C-Up>", "<C-W>+")
map("n", "<C-Down>", "<C-W>-")
map("n", "<C-Left>", "<C-W><")
map("n", "<C-Right>", "<C-W>>")

-- terminal mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

map("n", "yc", "yygccp", { remap = true })
