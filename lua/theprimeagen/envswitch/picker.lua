local M = {}

local function find_env_presets()
  -- matches: .dev.env, .prod.env, .local.env
  local cmd = [[
    find env -type f -name ".*.env" \
      ! -path "./node_modules/*" \
      ! -path "./.git/*"
  ]]

  local results = vim.fn.systemlist(cmd)

  for i, file in ipairs(results) do
    results[i] = file:gsub("^%./", "")
  end

  return results
end

local function replace_env(source)
  local ok, err = pcall(function()
    local contents = vim.fn.readfile(source)
    vim.fn.writefile(contents, ".env")
  end)

  if not ok then
    vim.notify("EnvSwitch failed: " .. err, vim.log.levels.ERROR)
    return
  end

  vim.notify("Switched .env → " .. source, vim.log.levels.INFO)
end

function M.open()
  local presets = find_env_presets()

  if #presets == 0 then
    vim.notify("No .*.env files found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(presets, {
    prompt = "Select env preset",
  }, function(choice)
    if choice then
      replace_env(choice)
    end
  end)
end

return M

