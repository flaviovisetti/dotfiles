return {
  "Olical/conjure",
  init = function()
    vim.g["conjure#mapping#doc_word"] = "K"
    vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = false
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
  end,
  config = function()
    local keymap = vim.keymap

    keymap.set("n", "<localleader>crn", "<cmd>ConjureCljRunCurrentTest<CR>")
    keymap.set("n", "<localleader>cra", "<cmd>ConjureCljRunAllTests<CR>")
  end,
}
