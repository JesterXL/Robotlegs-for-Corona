--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


require "org.robotlegs.Mediator"

require "com.jessewarden.robotlegs.examples.basic.models.PlayerModel"

HealthBarMediator = {}

function HealthBarMediator:new()
	
	local mediator = Mediator:new()
	
	function mediator:onRegister()
		Runtime:addEventListener("PlayerModel_hitPointsChanged", self)
		self:PlayerModel_hitPointsChanged()
	end
	
	function mediator:onRemove()
		Runtime:removeEventListener("PlayerModel_hitPointsChanged", self)
	end
	
	function mediator:PlayerModel_hitPointsChanged(event)
		mediator.viewInstance:setHealth(PlayerModel.instance:getHitpointsPercentage())
	end
	
	return mediator
	
end

return HealthBarMediator