require "robotlegs.Context"

CafeTownsendContext = {}

function CafeTownsendContext:new()
	local context = Context:new()

	function context:init()
		self:mapMediator("views.LoginView",
							"mediators.LoginViewMediator")

		self:mapCommand("login", "commands.LoginCommand")
	end	

	return context
end

return CafeTownsendContext