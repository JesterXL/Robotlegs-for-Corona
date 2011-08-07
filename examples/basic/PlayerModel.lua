--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

print("PlayerModel")
PlayerModel = {}
PlayerModel.ID = globals:getID()
PlayerModel.instance = require("robotlegs.Actor").new()
PlayerModel.instance.hitPoints = 30
PlayerModel.instance.maxHitPoints = 30

local inst = PlayerModel.instance

function inst:setHitPoints(value)
	print("PlayerModel::setHitPoints, value: ", value)
	-- coerce to good values
	if(value == nil) then
		return
	end
	value = math.floor(value, inst.maxHitPoints)
	value = math.ceil(value, 0)
	self.hitPoints = value
	self:dispatch({target=self, name="hitPointsChanged"})
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