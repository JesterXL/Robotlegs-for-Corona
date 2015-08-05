--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

HealthBar = {}

function HealthBar:new()
	local healthBarGroup = display.newGroup()
	healthBarGroup.classType = "HealthBar"
	
	local healthBarBackground = display.newImage("health_bar_background.png", 0, 0)
	healthBarGroup.healthBarBackground = healthBarBackground
	healthBarGroup:insert(healthBarBackground)
	
	healthBarForeground = display.newImage("health_bar_foreground.png", 0, 0)
	healthBarGroup.healthBarForeground = healthBarForeground
	healthBarGroup:insert(healthBarForeground)
	healthBarForeground.x = healthBarBackground.x
	healthBarForeground.y = healthBarBackground.y
	healthBarForeground.anchorX = 0
	healthBarForeground.anchorY = 0
	
	-- from 0 to 1
	function healthBarGroup:setHealth(value)
		if(value <= 0) then
			value = 0.1
		end

		self.healthBarForeground.xScale = value
		-- NOTE: Makah-no-sense, ese. Basically, setting width is bugged, and Case #677 is documented.
		-- Meaning, no matter what reference point you set, it ALWAYS resizes from center when setting width/height.
		-- So, we just increment based on the negative xReference of "how far my left is from my left origin".
		-- Wow, that was a fun hour.
		self.healthBarForeground.x = self.healthBarBackground.x + self.healthBarForeground.anchorX
	end

	Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=healthBarGroup})
	
	return healthBarGroup
end

return HealthBar