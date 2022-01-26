local fzf = require"fzf"
local utils = require"microcontroller-nvim.utils"
local M = {}

M.links = {
	-- Daisy
	["DaisySP documentation"] = "https://electro-smith.github.io/DaisySP/index.html",
	["Daisy pinout"] = "https://github.com/electro-smith/DaisyWiki/wiki/2.-Daisy-Seed-Pinout",
	["Daisy wiki"] = "https://github.com/electro-smith/DaisyWiki/wiki",

	-- Pico
	["Pico getting started"] = "https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf",
	["Pico RP2040 datasheet"] = "https://datasheets.raspberrypi.com/rp2040/rp2040-datasheet.pdf",
	["Pico SDK examples"] = "https://github.com/raspberrypi/pico-examples/",
	["Pico pinout"] = "https://datasheets.raspberrypi.com/pico/Pico-R3-A4-Pinout.pdf",

	-- Teensy
	["Teensy specs"] = "https://www.pjrc.com/teensy/techspecs.html",
	["Teensy pinout"] = "https://www.pjrc.com/teensy/pinout.html",
	["Teensy Audio Lib"] = "https://www.pjrc.com/teensy/gui/index.html",
}

function M.open()
	coroutine.wrap(function()
		local links = M.links
		local result = fzf.fzf(utils.table_keys(links))

		if result then
			local key = result[1]
			local link = links[key]

			utils.open_link(link)
		end

	end)()
end

return M
