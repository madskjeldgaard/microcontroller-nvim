
A small collection of utility functions for programming microcontrollers in neovim, mostly just thin wrappers for Platformio commands.

# Requirements

- Nvim >= 0.5
- [platformio](https://docs.platformio.org/en/latest/what-is-platformio.html)

# Example setup

```vim
autocmd FileType cpp,c,arduino,dosini lua require'microcontroller'.setup()
```

## Commands

`PioBuild`
Build code for microcontroller. This will run vim's built in `:make`. If you are in a platformio directory it will run `pio run -t upload`. If any errors occur, they are populated in the quick fix list and may be navigated using `:cnext` and `:cprev` for example.


`PioUpload`
Compile and upload code to microcontroller

`PioMonitor`
Open tab with serial monitor

`PioEnv`
Print controllers (that is boards) defined in the `platformio.ini` project file

`PioCompiledb`
Create a compile_commands.json file and put in the root of the project (for clangd language server protocols)

`PioCheck`
Run static code analysis

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
