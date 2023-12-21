-- DAP components
require("plugins.dap.config.telescope")
require("plugins.dap.config.keymaps")
require("plugins.dap.config.virtual_text")
require("plugins.dap.config.line_signs")
require("plugins.dap.config.cmp")
require("plugins.dap.config.dap_ui")

-- DAP language debuggers
require("plugins.dap.config.languages.javascript")
require("plugins.dap.config.languages.php")

-- DAP take into account `./.vscode/launch.json` files
require("plugins.dap.config.launch_vscode")
