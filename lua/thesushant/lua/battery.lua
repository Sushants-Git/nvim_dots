local M = {}

function M.print_first_line()
    local file = "/sys/class/power_supply/BAT0/capacity"
    for line in io.lines(file) do
        print(line)
        return
    end
end

M.print_first_line()

return M
