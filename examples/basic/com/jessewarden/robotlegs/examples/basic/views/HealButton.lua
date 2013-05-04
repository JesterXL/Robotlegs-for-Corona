--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

HealButton = {}
function HealButton:new(x, y)
	local group = display.newGroup()
	group.x = x
	group.y = y
	function group:onPress(event)
		group:dispatchEvent({name="clicked", target=group})
	end
	
	local healButton = widget.newButton
	{
        id = "healButton",
        x = 0,
        y = 0,
        label = "Heal Player",
		onPress = group.onPress
    }
	group:insert(healButton)
	group.classType = "HealButton"

	Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=group})
	return group
end

return HealButton