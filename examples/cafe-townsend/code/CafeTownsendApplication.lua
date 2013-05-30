require "CafeTownsendContext"
require "views.LoginView"
require "views.LoadingView"
require "views.EmployeeView"
require "views.EditEmployeeView"

CafeTownsendApplication = {}

function CafeTownsendApplication:new()
	local application = display.newGroup()
	application.classType = "CafeTownsendApplication"
	application.currentView = nil

	function application:init()
		local background = display.newRect(self, 0, 0, stage.width, stage.height)

		local context = CafeTownsendContext:new()
		context:init()
		
		

		
		-- local employeeView = EmployeeView:new(self)

		-- local editEmployeView = EditEmployeeView:new(self)
		-- editEmployeView:setEmployee(gEmployeesModel.employees[1])

		local loadingView = LoadingView:new(self)
		self.loadingView = loadingView

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function application:showView(name)
		
		if self.currentView then
			self.currentView:destroy()
			self.currentView = nil
		end

		local view
		if name == "loginView" then
			view = LoginView:new(self)
			view:move(stage.width / 2 - view.width / 2, stage.height * 0.2)
		elseif name == "employeeView" then
			view = EmployeeView:new(self)
		else
			error("Unknown view: " .. name)
		end
		
		self.currentView = view
		self.loadingView:toFront()
	end

	application:init()

	return application
end

return CafeTownsendApplication