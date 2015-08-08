local LoginService = require "services.LoginService"
local LoginCommand = {}

function LoginCommand:new()
	local command = {}
	command.loginService = nil

	function command:execute(event)
		print("LoginCommand::execute")
		loginService = LoginService:new()
		loginService:addEventListener("onLoginSuccess", self)
		loginService:addEventListener("onLoginError", self)
		loginService:login(event.username, event.password)
	end

	function command:onLoginError(event)
		print("LoginCommand::onLoginError")
		Runtime:dispatchEvent({name="onLoginError", errorMessage=event.errorMessage})
	end

	function command:onLoginSuccess(event)
		print("LoginCommand::onLoginSuccess")
		Runtime:dispatchEvent({name="onLoginSuccess", errorMessage=errorMessage})
	end

	return command
end

return LoginCommand