local Mediator = {}

function Mediator:new()

	local mediator = {}
	mediator.viewInstance = nil
	
	function mediator:onRegister()
	end
	
	function mediator:onRemove()
	end
	
	function mediator:destroy()
		self.viewInstance = nil
	end
	
	return mediator
end

return Mediator