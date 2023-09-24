-- DAP components
require("user.dap.telescope")
require("user.dap.keymaps")
require("user.dap.virtual_text")
require("user.dap.line_signs")
require("user.dap.cmp")
require("user.dap.dap_ui")

-- DAP language debuggers
require("user.dap.languages.javascript")
require("user.dap.languages.php")

-- DAP take into account `./.vscode/launch.json` files
require("user.dap.launch_vscode")
