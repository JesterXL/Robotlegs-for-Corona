--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


local Bullet = {}

function Bullet:new(startX, startY, targetPoint)
	local bullet = display.newImage("bullet.png")
	bullet.name = "Bullet"
	bullet.speed = 6
	bullet.x = startX
	bullet.y = startY
	bullet.targetX = targetPoint.x
	bullet.targetY = targetPoint.y
	-- TODO: use math.deg vs. manual conversion
	bullet.rot = math.atan2(bullet.y -  bullet.targetY,  bullet.x - bullet.targetX) / math.pi * 180 -90;
	bullet.angle = (bullet.rot -90) * math.pi / 180;
	
	physics.addBody( bullet, { density = 1.0, friction = 0.3, bounce = 0.2, 
								bodyType = "kinematic", 
								isBullet = true, isSensor = true, isFixedRotation = true,
								filter = { categoryBits = 8, maskBits = 1 }
							} )
								
	
	function bullet:collision(event)
		if(event.other.name == "Player") then
			-- TODO: watch this; not sure which instance it's talking too
			event.other:onBulletHit()
			self:destroy()
		end
	end

	bullet:addEventListener("collision", bullet)
	
	function bullet:destroy()
		self:removeEventListener("collision", self)
		self:dispatchEvent({name="removeFromGameLoop", target=self})
		self:removeSelf()
	end
	
	function bullet:tick(millisecondsPassed)
		-- TODO: make sure using milliseconds vs. hardcoding step speed
		self.x = self.x + math.cos(self.angle) * self.speed
	   	self.y = self.y + math.sin(self.angle) * self.speed
		if(self.x > stage.width or self.x < 0 or self.y < 0 or self.y > stage.height) then
			self:destroy()
		end
	end
	
	return bullet
end

return Bullet