require "robotlegs.Context"

CafeTownsendContext = {}

function CafeTownsendContext:new()
	local context = Context:new()

	function context:init()
		self:mapMediator("views.LoginView",
							"mediators.LoginViewMediator")

		self:mapMediator("views.LoadingView",
							"mediators.LoadingViewMediator")

		self:mapMediator("views.EmployeeView",
							"mediators.EmployeeViewMediator")

		self:mapCommand("login", "commands.LoginCommand")

		self:mapCommand("startup", "commands.StartupCommand")

		Runtime:dispatchEvent({name="startup"})
	end	

	return context
end

return CafeTownsendContext