LoadingViewMediator = {}

function LoadingViewMediator:new()
	local mediator = {}

	function mediator:onRegister()
		Runtime:addEventListener("login", self)
		Runtime:addEventListener("onLoginError", self)
		Runtime:addEventListener("onLoginSuccess", self)
		self.viewInstance.isVisible = false
	end

	function mediator:onRemove()
		Runtime:removeEventListener("login", self)
		Runtime:removeEventListener("onLoginError", self)
		Runtime:removeEventListener("onLoginSuccess", self)
	end

	function mediator:login(event)
		self.viewInstance.isVisible = true
		self.viewInstance:show(true)
		self.viewInstance:setLabel("Logging In...")
	end

	function mediator:onLoginError(event)
		-- self.viewInstance.isVisible = false
		self.viewInstance:show(false)
	end

	function mediator:onLoginSuccess(event)
		-- self.viewInstance.isVisible = false
		self.viewInstance:show(false)
	end

	return mediator
end

return LoadingViewMediator