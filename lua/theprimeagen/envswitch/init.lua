local M = {}

function M.setup()
  vim.api.nvim_create_user_command("EnvSwitch", function()
    require("theprimeagen.envswitch.picker").open()
  end, {})
end

return M

