return {
  {
    "prettier/vim-prettier",
    bin = "prettierd",
    config = function()
      vim.cmd [[
        let g:prettier#autoformat_config_present = 1
        let g:prettier#autoformat_require_pragma = 0
      ]]
      vim.cmd(
      "autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx,*.css,*.scss,*.json,*.graphql,*.md,*.mdx,*.vue,*.yaml,*.yml PrettierAsync")
    end,
  }
}
