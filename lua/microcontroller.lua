-- Functions and mappings for working with microcontrollers like the Arduino and Teensy
-- Most of this is based around the Platformio Core software
local M = {}

local browser = vim.g.microcontroller_browser or "firefox"
local mapkeys = vim.g.microcontroller_default_keymaps or true

local api = vim.api
local vimcmd = api.nvim_command

function M.setup()
	-- Register commands
	require'microcontroller-nvim/commands'

	vim.cmd("autocmd FileType cpp lua require'microcontroller'.set_make_prgm()")

	-- Default keymaps
	if mapkeys == true then
		M.keymaps()
	end
end

local default_mappings = {
	normal = {
		teensyspecs = "<leader>ts",
		teensypins = "<leader>tp",
		upload = "<C-e>",
		build = "<C-r>",
		-- monitor = "<C-m>",
		compiletags = "<leader>rt"
	},
	insert = {
		upload = "<C-e>",
		build = "<C-r>",
	}
}

function M.keymaps()
	local mappings = default_mappings -- todo: check for global config

	-- Normal mode
	for func, map in pairs(mappings.normal) do
		local cmd = string.format(':lua require"mcu".%s()<cr>', func)
		vim.api.nvim_buf_set_keymap(0, 'n', map, cmd, { nowait = true, noremap = true, silent = false })
	end

	-- Insert mode
	for func, map in pairs(mappings.insert) do
		local cmd = string.format('<esc>:lua require"mcu".%s()<cr>', func)
		vim.api.nvim_buf_set_keymap(0, 'i', map, cmd, { nowait = true, noremap = true, silent = false })
	end

end

function M.terminal(cmd)
	vimcmd("vsplit")
	vimcmd("terminal " .. cmd) -- TODO: Exit when exit code is 0
end

function M.silent_shell(cmd)
	vimcmd("silent exe '! " .. cmd .. " &'")
end

function M.upload()
	vim.cmd("set makeprg=pio\\ run\\ -t\\ upload")
	vim.cmd("make")
end

function M.build()
	vim.cmd("set makeprg=pio\\ run")

	vim.cmd("make")
end

function M.pio_clean()
	vim.cmd("set makeprg=pio\\ run\\ -t\\ clean")
	vim.cmd("make")
end

function M.pio_check()
	vim.cmd("set makeprg=pio\\ check\\ --skip-packages")
	vim.cmd("make")
end

function M.set_make_prgm()
	if M.has_pio_file() then
		vim.cmd("set makeprg=pio\\ run\\ -t\\ upload")
	end
end

-- This is hacky
function M.compiletags()
	local create_tags_cmd = "pio run -t compiledb"
	local controllers = M.pio_env()
	M.silent_shell(create_tags_cmd)
	-- Just choose the first controller in environment list
	M.linktags(controllers[1])
end

-- TODO
-- This is a dirty hack for LanguageClient. There must be a nicer way of doing this. Right?
function M.linktags(microcontroller)
	local board = microcontroller or "teensy31"
	local link_cmd = "ln -sf .pio/build/" .. board .. "/compile_commands.json ."
	M.silent_shell(link_cmd)
end

-- Check if there is a platformio init file in root
function M.has_pio_file()
		local name = "platformio.ini"
		local f=io.open(name,"r")
		if f~=nil then io.close(f) return true else return false end
end

function M.has_makefile()
		local name = "Makefile"
		local f=io.open(name,"r")
		if f~=nil then io.close(f) return true else return false end
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function M.lines_from(file)
  if not M.has_pio_file() then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

-- Found out which controllers are defined in the pio file
function M.pio_env()
		-- lua match pattern for the pattern [env:name_of_controller] pattern
		local search_pattern = "%[env:%w*%]"
		local result = {}

		-- Check for platformio.ini file in root
		if M.has_pio_file() then
				local lines = M.lines_from("platformio.ini")
				for i=1, #lines do
						local search = lines[i]:match(search_pattern)
						if search ~= nil then
								-- Remove beginning of tag
								search = string.gsub(search, "%[env:", "")

								-- Remove end of tag
								search = string.gsub(search, "%]", "")

								-- Leaving only a word:
								result[#result + 1] = search
						end
				end

				return result
		end
end

function M.print_env()
		local env = M.pio_env()
		print("Controllers defined in this platformio project:")
		for name = 1, #env do
				print(env[name])
		end
end

function M.monitor()
	local cmd = "pio device monitor"
	M.terminal(cmd)
end


---------------------------------------------------
-- Help / reference functions
function M.open_in_browser(url)
	M.silent_shell(browser .. " " .. url )
end

function M.daisydoc()
	local url = "https://electro-smith.github.io/DaisySP/index.html"
	M.open_in_browser(url)
end

function M.teensypins()
	local url = "https://www.pjrc.com/teensy/pinout.html"
	M.open_in_browser(url)
end

function M.teensyspecs()
	local url = "https://www.pjrc.com/teensy/techspecs.html"
	M.open_in_browser(url)
end

function M.arduinoref()
	local url = "https://www.arduino.cc/reference/en/"
	M.open_in_browser(url)
end

-- Daisy stuff
--
function M.make()
	vim.cmd("!make clean; make")
end

function M.make_upload_daisy()
	vim.cmd("!make clean; make; make program-dfu")
end

-- For Daisy uploading
function M.upload_dfu()
	vim.cmd("! make program-dfu")
end

function M.compiledb()
	local target_dir = "build"
	vim.cmd(string.format("! compiledb make; mv compile_commands.json %s/", target_dir))
end


return M
