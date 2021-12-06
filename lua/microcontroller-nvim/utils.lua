local M = {}

-- Check if a file or directory exists in this path
function M.exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

function M.append_to_file(text, file)
-- Open the file in r mode (don't modify file, just read)
	local out = io.open(file, 'r')

-- Fetch all lines and add them to a table
	local lines = {}
	for line in out:lines() do
		table.insert(lines, line .. "\n")
	end

-- Close the file so that we can open it in a different mode
	out:close()

-- Insert what we want to write to the first line into the table
	table.insert(lines, #lines+1, text .. "\n")

-- Open temporary file in w mode (write data)
-- Iterate through the lines table and write each line to the file
	local tmp_file = file .. "_tmp"
	out = io.open(tmp_file, 'w')
	for _, line in ipairs(lines) do
		out:write(line)
	end
	out:close()

-- At this point, we should have successfully written the data to the temporary file

-- Delete the old file
	os.remove(file)

-- Rename the new file
	os.rename(tmp_file, file)
end

function M.get_command_output(command)

	local handle = io.popen(command)
	local cmd_result = handle:read("*a")
	handle:close()

	return cmd_result
end

function M.table_keys(tableIn)
	local result = {}
	for key, _ in pairs(tableIn) do
		table.insert(result, key)
	end

	return result
end

return M
