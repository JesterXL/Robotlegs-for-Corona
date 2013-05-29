ReadFileContentsService = {}

function ReadFileContentsService:new()
	local file = {}

	function file:readFileContents(fileName, filePath)
		local path = system.pathForFile(fileName, filePath)
		local file = io.open(path, "r")
		if file then
			contents = file:read("*a")
			--print("contents: ", contents)
			io.close(file)
			return contents
		else
			return nil
		end
	end

	return file
end

return ReadFileContentsService