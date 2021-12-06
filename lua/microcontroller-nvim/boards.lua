local fzf = require"fzf"
local utils = require"microcontroller-nvim.utils"
local M = {}

--
-- Parse boards into board_info

local function pio_boards()
	local command = "pio boards --json-output"
	local cmd_result = utils.get_command_output(command)
	boards = vim.fn.json_decode(cmd_result)
	board_info = {}

	-- Reorganize so that board name becomes the key
	for i=1,#boards do
		local board = boards[i]

		local key = board.name
		board_info[key] = boards[i]--{platform = board.platform, frameworks = board.frameworks, id = board.id}
	end

	return board_info
end

-- Fuzzy search platformio boards and add the selected to platformio.ini if it exists
function M.boards()
coroutine.wrap(function()
	local board_info = pio_boards()
  local result = fzf.fzf(utils.table_keys(board_info))

  if result then
	  local key = result[1]
	  local info = board_info[key]
	  local out_string = string.format([[

[env:%s]
platform = %s
framework = %s
board = %s
]],
	info.id,
	info.platform,
	info.frameworks[1], -- For now, just choose the first framework
	info.id
)

		-- TODO This file checking doesn't seem to work?
		local out_file = "platformio.ini"
		local file_exists, _ = utils.exists(out_file)
		if file_exists then
			utils.append_to_file(out_string, out_file)
		else
			error(string.format("Could not find %s", out_file))
		end
  end
end)()
end

return M
