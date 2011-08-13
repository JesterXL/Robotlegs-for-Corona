--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

function new(viewInstance)
	
	local mediator = require("robotlegs_Mediator").new(viewInstance)
	mediator.superOnRegister = mediator.onRegister
	
	function mediator:onRegister()
		print("PlayerMediator::onRegister, viewInstance: ", viewInstance)
		self:superOnRegister()
		
		viewInstance.hitPoints = PlayerModel.instance.hitPoints
		viewInstance.maxHitPoints = PlayerModel.instance.maxHitPoints
		viewInstance:addEventListener("bulletHit", self)
		viewInstance:addEventListener("missileHit", self)
	end
	
	function mediator:onRemove()
		viewInstance:removeEventListener("bulletHit", self)
		viewInstance:removeEventListener("missileHit", self)
	end
	
	function mediator:bulletHit(event)
		PlayerModel.instance:onBulletHit()
	end

	function mediator:missileHit(event)
		PlayerModel.instance:onMissileHit()
	end
	
	return mediator
	
end