--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]

require "org.robotlegs.Mediator"

require "com.jessewarden.robotlegs.examples.basic.models.PlayerModel"

HealButtonMediator = {}

function HealButtonMediator:new()
	
	local mediator = Mediator:new()

	function mediator:onRegister()
		self.viewInstance:addEventListener("clicked", self)
	end
	
	function mediator:onRemove()
		self.viewInstance:removeEventListener("clicked", self)
	end
	
	function mediator:clicked(event)
		Runtime:dispatchEvent({name="healPlayer", target=mediator})
		-- NOTE: if you want to skip putting Controller logic in Commands and git-r-done,
		-- then just call the model directly. This is bad practice (less DRY), but more pragmmatic.
		-- Once multiple people call the same method WITH parameters, then a Command is a good choice.
		-- Here, since heal has no parameters, it's fine. Sometimes, you'll do many other things
		-- to other models before you call heal, which again is a great Command use case.
		-- the downside is it's hard to track down who's setting your model, when, and where if you do it
		-- this way... but certainly requires a lot less classes and wiring in your Context.
		-- 
		-- PlayerModel.instance:heal()
	end
	
	return mediator
	
end

return HealButtonMediator