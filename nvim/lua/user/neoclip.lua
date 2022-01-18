local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then return end

local status_ok, neoclip = pcall(require, "lualine")
if not status_ok then return end

telescope.load_extension('neoclip')
neoclip.setup()


