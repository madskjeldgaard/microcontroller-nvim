local commands = {
	"CompileDB lua require('microcontroller').compiledb()",
	"PioCompiledb lua require('microcontroller').compiletags()",
	"PioBoards lua require'microcontroller-nvim.boards'.boards()",
	"PioBuild lua require('microcontroller').build()",
	"PioUpload lua require('microcontroller').upload()",
	"PioMonitor lua require('microcontroller').monitor()",
	"PioCheck lua require('microcontroller').pio_check()",
	"PioClean lua require('microcontroller').pio_clean()",
	"PioEnv lua require('microcontroller').print_env()",
	"TeensyPinout lua require('microcontroller').teensypins()",
	"TeensySpecs lua require('microcontroller').teensyspecs()",
	"TeensyAudioLib lua require('microcontroller').teensyaudiolib()",
	"ArduinoRef lua require('microcontroller').arduinoref()",
	"DaisyMake lua require('microcontroller').makeclean()",
	"DaisyMakeUpload lua require('microcontroller').make_upload_daisy()",
	"DaisyMakeUploadDFU lua require('microcontroller').make_upload_daisy_dfu()",
	"DaisyDocs lua require('microcontroller').daisydoc()",
}

for index = 1, #commands do
	vim.cmd("command! " .. commands[index])
end
