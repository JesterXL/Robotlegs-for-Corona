CafeTownsendApplicationMediator = {}

function CafeTownsendApplicationMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		Runtime:addEventListener("onLoginSuccess", self)
		view:showView("loginView")
	end

	function mediator:onRemove()
		local view = self.viewInstance
		Runtime:removeEventListener("onLoginSuccess", self)
	end

	function mediator:onLoginSuccess()
		self.viewInstance:showView("employeeView")
	end

	return mediator
end

return CafeTownsendApplicationMediator