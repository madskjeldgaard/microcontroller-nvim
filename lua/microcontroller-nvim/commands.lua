local commands = {
	"PioCompiledb lua require('microcontroller').compiletags()",
	"PioBuild lua require('microcontroller').build()",
	"PioUpload lua require('microcontroller').upload()",
	"PioMonitor lua require('microcontroller').monitor()",
	"PioEnv lua require('microcontroller').print_env()",
	"TeensyPinout lua require('microcontroller').teensypins()",
	"TeensySpecs lua require('microcontroller').teensyspecs()",
	"ArduinoRef lua require('microcontroller').arduinoref()",
}

for index = 1, #commands do
	vim.cmd("command! " .. commands[index])
end
