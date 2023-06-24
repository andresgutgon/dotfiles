local ok_telescope, telescope = pcall(require, "telescope")

if not (ok_telescope) then
  return
end

telescope.load_extension('dap')
