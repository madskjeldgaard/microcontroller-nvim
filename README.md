
A small collection of utility functions for programming microcontrollers in neovim, mostly just thin wrappers for Platformio commands.

# Requirements

- Nvim >= 0.5
- [platformio](https://docs.platformio.org/en/latest/what-is-platformio.html)

## Commands

`PioBuild`
Build code for microcontroller

`PioUpload`
Compile and upload code to microcontroller

`PioMonitor`
Open tab with serial monitor

`PioEnv`
Print controllers (that is boards) defined in the `platformio.ini` project file

`PioCompiledb`
Create a compile_commands.json file and put in the root of the project (for clangd language server protocols)

Open references for specific boards:

- `TeensyPinout`
- `TeensySpecs`
- `ArduinoRef`

## Options

```lua
-- Browser command used for reference pages
vim.g.microcontroller_browser = "chrome"

-- Use default keymaps
vim.g.microcontroller_default_keymaps = true
```
