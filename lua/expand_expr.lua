local M = {}

local function regex_escape(str)
  return string.gsub(str, "[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local replace = function(str, this, that)
  return string.gsub(str, regex_escape(this), that)
end

-- Syntax is range|expr, %d inside expr will be replaced with range index
-- range: 10|... or 1,10|...
-- expr: {%d} or {%d+1}
-- anything inside {} is a lua expression
function M.expand()
  local expr = vim.api.nvim_get_current_line()
  local pos = string.find(expr, "|")
  local range = string.sub(expr, 1, pos - 1)
  local content = string.sub(expr, pos + 1)

  if #range == 0 and #content == 0 then
    print("invalid expandable expr")
    return
  end

  -- if range contains ,
  local from = 1
  local to = 1

  local has_comma = string.find(range, ",")
  if has_comma == nil then
    to = tonumber(range)
  else
    local range_parts = vim.split(range, ",")
    if #range_parts > 2 then
      print("range part could only contains one comma")
      return
    end

    from = tonumber(range_parts[1])
    to = tonumber(range_parts[2])
  end

  if from == nil or to == nil then
    print("range part should be number")
    return
  end

  -- parse expression in side {}
  local expr_parts = {}
  for e in string.gmatch(content, "{(.-)}") do
    table.insert(expr_parts, {
      original = "{" .. e .. "}",
      expression = e,
    })
  end

  local lines = { "" }
  for i = from, to do
    local temp_line = content
    -- eval expression parts
    for _, ep in ipairs(expr_parts) do
      local e = replace(ep.expression, "%d", i)

      -- eval using lua
      local fn = loadstring("return " .. e)

      local value = e
      if type(fn) == "function" then
        value = fn()
      end

      temp_line = replace(temp_line, ep.original, value)
    end

    table.insert(lines, temp_line)
  end

  vim.api.nvim_del_current_line()
  vim.api.nvim_put(lines, "", true, true)
end

return M
