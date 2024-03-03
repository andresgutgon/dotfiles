return {
  { "theHamsta/nvim-dap-virtual-text" },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "microsoft/vscode-js-debug",
    opt = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
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
