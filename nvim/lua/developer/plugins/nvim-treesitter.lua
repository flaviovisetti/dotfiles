return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag" },
  config = function()
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      highlight = { enable = true },
      indent = { enable = true },
      autotag = { enable = true },
      ensure_installed = {
        "bash",
        "clojure",
        "commonlisp",
        "css",
        "dockerfile",
        "graphql",
        "gitignore",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "ruby",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false
      },
      auto_install = true
    })
  end,
}
