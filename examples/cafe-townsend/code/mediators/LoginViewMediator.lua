local LoginViewMediator = {}

function LoginViewMediator:new()
	local mediator = {}

	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("onLogin", self)
		Runtime:addEventListener("onLoginError", self)
		view:showTextFields(true)
	end

	function mediator:onRemove()
		local view = self.viewInstance
		view:removeEventListener("onLogin", self)
		Runtime:removeEventListener("onLoginError", self)
	end

	function mediator:onLogin(event)
		local view = self.viewInstance
		if event.username == nil or event.username == "" then
			view:error("Please provide a username.")
			return false
		end

		if event.password == nil or event.password == "" then
			view:error("Please provide a password.")
			return false
		end

		-- view:error(nil)

		Runtime:dispatchEvent({name="login", username=event.username, password=event.password})
	end

	function mediator:onLoginError(event)
		print("LoginViewMediator::onLoginError, errorMessage:", event.errorMessage)
		self.viewInstance:error(event.errorMessage)
	end

	return mediator
end

return LoginViewMediator