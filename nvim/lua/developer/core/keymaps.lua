vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.tmux_navigator_no_mappings = 1
vim.g.rspec_command = "VtrSendCommandToRunner! rspec {spec}"

local keymap = vim.keymap

keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Switch between the last two files" })
keymap.set("n", "//", ":nohlsearch<CR>", { silent = true, desc = "Clear current search highlight by double tapping" })

keymap.set("n", "vv", "<C-w>v", { silent = true, desc = "Window splits vertical easier" })
keymap.set("n", "ss", "<C-w>s", { silent = true, desc = "Window splits horizontal" })

keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Create new tab" })
keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to the next opened tab" })
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Back to previous opened tab" })

keymap.set("i", "<C-K>", "<%=  %><Esc>2hi", { silent = true, desc = "Snippet for ERB. Executes the ruby code with output" })
keymap.set("i", "<C-J>", "<%  %><Esc>2hi", { silent = true, desc = "Snippet for ERB. Executes the ruby code without output" })

keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true })
keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true })
keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true })
keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true })
