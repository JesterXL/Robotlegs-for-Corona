local Context = require "robotlegs.Context"

local CafeTownsendContext = {}

function CafeTownsendContext:new()
	local context = Context:new()

	function context:init()
		self:mapMediator("views.LoginView",
							"mediators.LoginViewMediator")

		self:mapMediator("views.LoadingView",
							"mediators.LoadingViewMediator")

		self:mapMediator("views.EmployeeView",
							"mediators.EmployeeViewMediator")

		self:mapMediator("views.EmployeeViewLarge",
							"mediators.EmployeeViewMediator")

		self:mapMediator("views.EditEmployeeView",
							"mediators.EditEmployeeViewMediator")

		self:mapMediator("CafeTownsendApplication",
							"mediators.CafeTownsendApplicationMediator")

		self:mapCommand("login", "commands.LoginCommand")

		self:mapCommand("startup", "commands.StartupCommand")

		self:mapCommand("deleteEmployee", "commands.DeleteEmployeeCommand")

		self:mapCommand("saveEmployee", "commands.SaveEmployeeCommand")

		self:mapCommand("updateEmployee", "commands.UpdateEmployeeCommand")

		Runtime:dispatchEvent({name="startup"})
	end	

	return context
end

return CafeTownsendContext