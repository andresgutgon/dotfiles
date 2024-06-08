return {
  { "theHamsta/nvim-dap-virtual-text" },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  { "rcarriga/cmp-dap" },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      require("plugins.dap.config")
    end,
  },
}
