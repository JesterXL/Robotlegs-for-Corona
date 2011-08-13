--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

require "PlayerModel"

function new(viewInstance)
	
	local mediator = require("robotlegs_Mediator").new(viewInstance)
	--print("viewInstance: ", viewInstance, ", vs. mediator.viewInstance: ", mediator.viewInstance)
	mediator.superOnRegister = mediator.onRegister
	mediator.name = "HealthTextMediator"
	
	function mediator:onRegister()
		print("HealthTextMediator::onRegister, viewInstance: ", viewInstance)
		self:superOnRegister()
		
		PlayerModel.instance:addListener("hitPointsChanged", mediator.hitPointsChanged)
		self:hitPointsChanged()
	end
	
	function mediator:onRemove()
		PlayerModel.instance:removeListener("hitPointsChanged", mediator.hitPointsChanged)
	end
	
	function mediator:hitPointsChanged(event)
		print("HealthTextMediator::hitPointsChanged")
		mediator.viewInstance:showHitPoints(PlayerModel.instance.hitPoints, PlayerModel.instance.maxHitPoints)
	end
	
	return mediator
	
end