return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "Lint" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- go = { "golangcilint" },
      --python = { "pylint" },
      --python = { "pylint", "mypy" },
      -- terraform = { "tflint", "trivy" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, {})
  end,
}
