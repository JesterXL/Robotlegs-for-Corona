--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

PlayerModel = {}
PlayerModel.instance = {}
PlayerModel.instance.hitPoints = 30
PlayerModel.instance.maxHitPoints = 30

local inst = PlayerModel.instance

function inst:setHitPoints(value)
	print("PlayerModel::setHitPoints, value: ", value)
	-- coerce to good values
	if(value == nil) then
		return
	end
	-- make sure we don't go below 0, or above our max
	value = math.max(value, 0)
	value = math.min(value, PlayerModel.instance.maxHitPoints)
	self.hitPoints = value
	Runtime:dispatchEvent({target=self, name="PlayerModel_hitPointsChanged"})
end

function inst:getHitpointsPercentage()
	return self.hitPoints / self.maxHitPoints
end

function inst:onBulletHit()
	self:setHitPoints(self.hitPoints - 2)
end

function inst:onMissileHit()
	self:setHitPoints(self.hitPoints - 6)
end

function inst:heal()
	self:setHitPoints(self.hitPoints + 1)
end

return PlayerModel