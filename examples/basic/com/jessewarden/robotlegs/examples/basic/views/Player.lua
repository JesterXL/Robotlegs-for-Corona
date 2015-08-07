--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

local Player = {}

function Player:new()
	
	local spriteSheetOptions = {
				width = 22,
			    height = 17,
			    numFrames = 2
			}
	local spriteSheet = graphics.newImageSheet("player.png", spriteSheetOptions)
	local sequenceData =
	{
	    name="flying",
	    start=1,
	    count=2,
	    time=90,
	    loopCount = 0
	}
	
	local img = display.newSprite(spriteSheet, sequenceData )
	img:play()
	img.classType = "Player" -- required for Robotlegs Mediators; convention for now for all your View classes
	img.name = "Player"
	img.speed = 0.07 -- pixels per second
	img.maxHitPoints = 30
	img.hitPoints = 30
	img.planeXTarget = 0
	img.planeYTarget = 0
	

	physics.addBody( img, { density = 1.0, friction = 0.3, bounce = 0.2, 
								bodyType = "kinematic", 
								isBullet = true, isSensor = true, isFixedRotation = true,
								filter = { categoryBits = 1, maskBits = 28 }
							} )
	
	function img:onBulletHit(event)
		self:dispatchEvent({name="bulletHit", target=self}) -- Mediator hears this and handles consequences
		if(self.hitPoints <= 0) then
			--audio.play(self.playerDeathSound, {loops=0})
			self:dispatchEvent({target=self, name="playerDead"})
		else
			--audio.play(self.playerHitSound, {loops=0})
		end
	end
	
	function img:tick(millisecondsPassed)
		if(self.x == self.planeXTarget and self.y == self.planeYTarget) then
			return
		else
			local deltaX = self.x - self.planeXTarget
			local deltaY = self.y - self.planeYTarget
			local dist = math.sqrt((deltaX * deltaX) + (deltaY * deltaY))

			local moveX = self.speed * (deltaX / dist) * millisecondsPassed
			local moveY = self.speed * (deltaY / dist) * millisecondsPassed

			if (self.speed >= dist) then
				self.x = self.planeXTarget
				self.y = self.planeYTarget
			else
				self.x = self.x - moveX
				self.y = self.y - moveY
			end
		end	
	end

	Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=img})
	
	return img
end

return Player