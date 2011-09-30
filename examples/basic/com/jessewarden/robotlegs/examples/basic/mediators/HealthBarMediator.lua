--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


require "org.robotlegs.Mediator"

require "com.jessewarden.robotlegs.examples.basic.models.PlayerModel"

HealthBarMediator = {}

function HealthBarMediator:new(viewInstance)
	
	local mediator = Mediator:new(viewInstance)
	print("viewInstance: ", viewInstance, ", vs. mediator.viewInstance: ", mediator.viewInstance)
	mediator.superOnRegister = mediator.onRegister
	mediator.name = "HealthBarMediator"
	
	function mediator:onRegister()
		print("HealthBarMediator::onRegister, viewInstance: ", viewInstance)
		self:superOnRegister()
		
		PlayerModel.instance:addListener("hitPointsChanged", mediator.hitPointsChanged)
		self:hitPointsChanged()
	end
	
	function mediator:onRemove()
		PlayerModel.instance:removeListener("hitPointsChanged", mediator.hitPointsChanged)
	end
	
	function mediator:hitPointsChanged(event)
		print("HealthBarMediator::hitPointsChanged")
		mediator.viewInstance:setHealth(PlayerModel.instance:getHitpointsPercentage())
	end
	
	return mediator
	
end

return HealthBarMediator