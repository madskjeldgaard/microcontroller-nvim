local status, overseer = pcall(require, 'overseer')

--- Check if a file or directory exists in this path
function exists(file)
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
function isdir(path)
   -- "/" works on both Unix and Windows
   return exists(path.."/")
end

if status then
	-- Build
	overseer.register_template({
		-- Required fields
		name = "piobuild",
		builder = function(params)
			-- This must return an overseer.TaskDefinition
			return {
				-- cmd is the only required field
				cmd = {'pio'},
				-- additional arguments for the cmd
				args = {"run"},
				-- the name of the task (defaults to the cmd of the task)
				name = "piobuild",
				-- set the working directory for the task
				cwd = "",
				-- additional environment variables
				env = {
					-- VAR = "FOO",
				},
				-- the list of components or component aliases to add to the task
				components = {"default"},
				-- arbitrary table of data for your own personal use
				metadata = {
					-- foo = "bar",
				},
			}
		end,
		-- Optional fields
		desc = "Build a platformio project",
		-- Tags can be used in overseer.run_template()
		tags = {overseer.TAG.BUILD},
		params = {
			-- See :help overseer.params
		},
		-- Determines sort order when choosing tasks. Lower comes first.
		priority = 50,
		-- Add requirements for this template. If they are not met, the template will not be visible.
		-- All fields are optional.
		condition = {
			-- A string or list of strings
			-- Only matches when current buffer is one of the listed filetypes
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
				-- Only activate if it is in a platformio directory
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end,
		},
	})

	-- Upload
	overseer.register_template({
		-- Required fields
		name = "pioupload",
		builder = function(params)
			-- This must return an overseer.TaskDefinition
			return {
				-- cmd is the only required field
				cmd = {'pio'},
				-- additional arguments for the cmd
				args = {"run", "-t", "upload"},
				-- the name of the task (defaults to the cmd of the task)
				name = "pioupload",
				-- set the working directory for the task
				cwd = "",
				-- additional environment variables
				env = {
					-- VAR = "FOO",
				},
				-- the list of components or component aliases to add to the task
				components = {"default"},
				-- arbitrary table of data for your own personal use
				metadata = {
					-- foo = "bar",
				},
			}
		end,
		-- Optional fields
		desc = "Build and upload a platformio project to a microcontroller",
		-- Tags can be used in overseer.run_template()
		tags = {overseer.TAG.BUILD},
		params = {
			-- See :help overseer.params
		},
		-- Determines sort order when choosing tasks. Lower comes first.
		priority = 50,
		-- Add requirements for this template. If they are not met, the template will not be visible.
		-- All fields are optional.
		condition = {
			-- A string or list of strings
			-- Only matches when current buffer is one of the listed filetypes
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end,
		},
	})

	-- Check
	overseer.register_template({
		-- Required fields
		name = "piocheck",
		builder = function(params)
			-- This must return an overseer.TaskDefinition
			return {
				-- cmd is the only required field
				cmd = {'pio'},
				-- additional arguments for the cmd
				args = {"check", "--verbose"},
				-- the name of the task (defaults to the cmd of the task)
				name = "piocheck",
				-- set the working directory for the task
				cwd = "",
				-- additional environment variables
				env = {
					-- VAR = "FOO",
				},
				-- the list of components or component aliases to add to the task
				components = {"default"},
				-- arbitrary table of data for your own personal use
				metadata = {
					-- foo = "bar",
				},
			}
		end,
		-- Optional fields
		desc = "Run static checker on a platformio project",
		-- Tags can be used in overseer.run_template()
		tags = {overseer.TAG.BUILD},
		params = {
			-- See :help overseer.params
		},
		-- Determines sort order when choosing tasks. Lower comes first.
		priority = 50,
		-- Add requirements for this template. If they are not met, the template will not be visible.
		-- All fields are optional.
		condition = {
			-- A string or list of strings
			-- Only matches when current buffer is one of the listed filetypes
			filetype = {"c", "cpp", "ino", "h", "hpp", "ini"},
			callback = function(search)
				return isdir(search.dir .. "/.pio")
			end
		},
	})
end
