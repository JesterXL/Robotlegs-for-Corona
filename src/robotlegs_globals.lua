--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

globals = {}
globals.ID = 1
globals.counter = 2

function globals:getID()
	globals.counter = globals.counter + 1
	return globals.counter
end

return globals