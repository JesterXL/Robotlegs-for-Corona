--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

module (..., package.seeall)

require "PlayerModel"

function new(viewInstance)
	
	local mediator = require("robotlegs_Mediator").new(viewInstance)
	mediator.superOnRegister = mediator.onRegister
	mediator.name = "HealButtonMediator"
	
	function mediator:onRegister()
		print("HealButtonMediator::onRegister")
		self:superOnRegister()
		self.viewInstance:addEventListener("clicked", self.onHeal)
	end
	
	function mediator:onRemove()
		self.viewInstance:removeEventListener("clicked", self.onHeal)
		self.viewInstance.onEvent = nil
	end
	
	function mediator:onHeal(event)
		print("HealButtonmediator::onHeal")
		mediator:dispatch({name="healPlayer", target=mediator})
		-- NOTE: if you want to skip putting Controller logic in Commands and git-r-done,
		-- then just call the model directly. This is bad practice (less DRY), but more pragmmatic.
		-- the downside is it's hard to track down who's setting your model, when, and where if you do it
		-- this way... but certainly requires a lot less classes and wiring in your Context.
		-- 
		-- require "PlayerModel"
		-- PlayerModel.instance:heal()
	end
	
	return mediator
	
end