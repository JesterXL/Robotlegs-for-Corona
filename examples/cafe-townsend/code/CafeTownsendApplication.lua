require "CafeTownsendContext"
require "views.LoginView"
require "views.LoadingView"
require "views.EmployeeView"
require "views.EditEmployeeView"
require "views.EmployeeViewLarge"

CafeTownsendApplication = {}

function CafeTownsendApplication:new()
	local application = display.newGroup()
	application.classType = "CafeTownsendApplication"
	application.currentView = nil
	application.currentViewName = nil

	function application:init()
		local background = display.newRect(self, 0, 0, stage.width, stage.height)
		function background:tap(event)
			Runtime:dispatchEvent({name="onStageTap", phase=event.phase})
		end

		function background:touch(event)
			Runtime:dispatchEvent({name="onStageTouch", phase=event.phase})
		end

		background:addEventListener("tap", background)
		background:addEventListener("touch", background)

		local context = CafeTownsendContext:new()
		context:init()
		
		

		
		-- local employeeView = EmployeeView:new(self)

		-- local editEmployeView = EditEmployeeView:new(self)
		-- editEmployeView:setEmployee(gEmployeesModel.employees[1])

		local loadingView = LoadingView:new(self)
		self.loadingView = loadingView

		Runtime:addEventListener("orientation", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function application:orientation(event)
		local t = event.type
		local viewName = self:getEmployeeViewBasedOnOrientation(t)
		self:showView(viewName)
	end

	function application:getEmployeeViewBasedOnOrientation(orientation)
		local currentView = self.currentViewName 
		if currentView == "loginView" then
			return "loginView"
		end

		if (orientation == "landscapeLeft" or orientation == "landscapeRight") then
			return "employeeViewLarge"
		elseif currentView == "employeeView" then
			return "employeeView"
		elseif currentView == "editEmployeeView" then
			return "editEmployeeView"
		end
	end

	function application:showView(name)
		
		if self.currentView then
			self.currentView:destroy()
			self.currentView = nil
		end

		local view
		self.currentViewName = name
		local viewName = self:getEmployeeViewBasedOnOrientation(t)
		if viewName == "loginView" then
			view = LoginView:new(self)
			view:move(stage.width / 2 - view.width / 2, stage.height * 0.2)
		elseif viewName == "employeeViewLarge" then
			view = EmployeeViewLarge:new(self)
		elseif viewName == "employeeView" then
			view = EmployeeView:new(self)
		elseif viewName == "editEmployeeView" then
			view = EditEmployeeView:new(self)
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