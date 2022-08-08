local status, overseer = pcall(require, 'overseer')

--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Check if a directory exists in this path
local function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end

if status then
	-- Build
	overseer.register_template({
		name = "piobuild",
		builder = function(params)
			return {
				cmd = {'pio'},
				args = {"run", "--verbose"},
				name = "piobuild",
				cwd = "",
				env = {},
				components = {
					"default",
					{"on_output_parse", parser = {
						-- Put the parser results into the 'diagnostics' field on the task result
						diagnostics = {
							-- Extract fields using lua patterns
							{
								"extract",
								"^([^%s].+):(%d+):(%d+): (.+)$",
								"filename",
								"lnum",
								"col",
								"text"
							},
						}
					}},
					{"on_result_diagnostics",
						remove_on_restart = true,
					},
					{"on_result_diagnostics_quickfix",
						open = true
					}
				},
				metadata = {},
			}
		end,
		desc = "Build a platformio project",
		tags = {overseer.TAG.BUILD},
		params = { },
		priority = 50,
		condition = {
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end
		},
	})

	-- Upload
	overseer.register_template({
		name = "pioupload",
		builder = function(params)
			return {
				cmd = {'pio'},
				args = {"run", "-t", "upload", "--verbose"},
				name = "pioupload",
				cwd = "",
				env = { },
				components = {
					"default",
					{"on_output_parse", parser = {
						-- Put the parser results into the 'diagnostics' field on the task result
						diagnostics = {
							-- Extract fields using lua patterns
							{
								"extract",
								"^([^%s].+):(%d+):(%d+): (.+)$",
								"filename",
								"lnum",
								"col",
								"text"
							},
						}
					}},
					{"on_result_diagnostics",
						remove_on_restart = true,
					},
					{"on_result_diagnostics_quickfix",
						open = true
					},
				},

				metadata = { },
			}
		end,
		desc = "Build and upload a platformio project to a microcontroller",
		tags = {overseer.TAG.BUILD},
		params = { },
		priority = 50,
		condition = {
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end
		}
	})

	-- Check
	overseer.register_template({
		name = "piocheck",
		builder = function(params)
			return {
				cmd = {'pio'},
				args = {"check", "--verbose", "--skip-packages"},
				name = "piocheck",
				cwd = "",
				env = {},
				components = {
					"default",
					{"on_output_parse", parser = {
						-- Put the parser results into the 'diagnostics' field on the task result
						diagnostics = {
							-- Extract fields using lua patterns
							{
								"extract",
								"^([^%s].+):(%d+): (.+)$",
								"filename",
								"lnum",
								"text"
							},
						}
					}},
					{"on_result_diagnostics",
						remove_on_restart = true,
					},
					{"on_result_diagnostics_quickfix",
						open = true
					},

				},
				metadata = {},
			}
		end,
		desc = "Run static checker on a platformio project",
		tags = {overseer.TAG.BUILD},
		params = {
		},
		priority = 50,
		condition = {
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end
		},
	})
end
