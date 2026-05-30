local map = vim.keymap.set

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end
local lmap = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

map("i", "jk", "<Esc>")

map("n", "<leader>cc", function() require("config.compile").make() end)
map("n", "<leader>t", function() require("config.compile").toggle_terminal() end)

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

-- LSP mappings, these are the defaults
-- grn: vim.lsp.buf.rename()
-- grr: vim.lsp.buf.references()
-- gri: vim.lsp.buf.implementation()
-- gO:  vim.lsp.buf.document_symbol()
-- gra: vim.lsp.buf.code_action()
-- K:   lsp.buf.hover

-- system clipboard
map({ "n", "x" }, "gy", '"+y')
map("n","gp", '"+p')

-- tabs
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

-- help
nmap('hh', '<Cmd>Pick help<CR>',                         'Help tags')
nmap('ht', '<Cmd>Pick hl_groups<CR>',                    'Help Highlight groups')

-- mini.pick
lmap('f', '<Cmd>Pick files<CR>',                        'Files')
lmap('g', '<Cmd>Pick grep_live<CR>',                    'Grep live')
lmap('b', '<Cmd>Pick buffers<CR>',                      'Buffers')
lmap(':', '<Cmd>Pick history scope=":"<CR>',            '":" history')
lmap('/', '<Cmd>Pick buf_lines scope="current"<CR>',    'Lines (buf)')
lmap('d', '<Cmd>Pick diagnostic scope="all"<CR>',       'Diagnostic workspace')

lmap("cl", function() require("lint").try_lint() end, "[C]ode [L]int")

lmap("os", "<cmd>NvimTreeToggle<cr>", "Open Sidetree" )
lmap("od", "<cmd>lopen<cr>", "Open diagnostics")

-- TODO: make this one only trigger in .tex files
lmap("lf", '<cmd>silent execute "!inkfig " . b:vimtex.root . "/figures/<cword>.svg"<cr>', "Inkscape Figures")

-- { "<tab>",
--   function()
-- 	  return require("luasnip").expand_or_jumpable()
-- 	      and "<Plug>luasnip-expand-or-jump"
-- 	      or "<tab>"
--   end,
--   expr = true, silent = true, mode = "i",
-- },
-- { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
-- { "<S-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
-- { "<C-f>",
--   function()
-- 	  if require("luasnip").choice_active() then
-- 	      return require("luasnip").change_choice(1)
-- 	  else
-- 	      return require("config.luasnip").dynamic_node_external_update(1)
-- 	  end
--   end,
--   silent = true, mode = { "i", "s" },
-- },
-- { "<C-b>",
--   function()
-- 	  if require("luasnip").choice_active() then
-- 	      return require("luasnip").change_choice(-1)
-- 	  else
-- 	      return require("config.luasnip").dynamic_node_external_update(2)
-- 	  end
--   end,
--   silent = true, mode = { "i", "s" },
-- },

