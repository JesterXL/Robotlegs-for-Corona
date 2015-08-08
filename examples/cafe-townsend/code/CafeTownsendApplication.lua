local CafeTownsendContext = require "CafeTownsendContext"
local LoginView = require "views.LoginView"
local LoadingView = require "views.LoadingView"
local EmployeeView = require "views.EmployeeView"
local EditEmployeeView = require "views.EditEmployeeView"
local EmployeeViewLarge = require "views.EmployeeViewLarge"

local CafeTownsendApplication = {}

function CafeTownsendApplication:new()
	local application = display.newGroup()
	application.classType = "CafeTownsendApplication"
	application.currentView = nil
	application.currentViewName = nil

	function application:init()
		print("EmployeeViewLarge::init")
		print("*********")
		print("contentCenterX: " .. tostring(display.contentCenterX))
		print("screenOriginX: " .. tostring(display.screenOriginX))
		local background = display.newRect(self, 0, 0, display.actualContentWidth, display.actualContentHeight)
		background.anchorX = 0
		background.anchorY = 0
		self.background = background
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
		local background = self.background
		background.width = display.actualContentWidth
		background.height = display.actualContentHeight
		background:setReferencePoint(display.TopLeftReferencePoint)
		background.x = 0
		background.y = 0

		local t = event.type
		self.lastKnownOrientation = t
		if self.currentViewName == "employeeView" or self.currentViewName == "employeeViewLarge" then
			local employeeViewToShow = self:whichEmployeeViewToShowBasedOnOrientation()
			self:showView(employeeViewToShow)
		end

		if self.currentViewName == "loginView" then
			self.currentView:move(display.actualContentWidth / 2 - self.currentView.width / 2, display.actualContentHeight * 0.2)
		end
	end

	function application:whichEmployeeViewToShowBasedOnOrientation()
		local t = self.lastKnownOrientation
		if t == "landscapeLeft" or t == "landscapeRight" then
			return "employeeViewLarge"
		else
			return "employeeView"
		end
	end

	function application:showView(name)
		print("CafeTownsendApplication::name:", name, ", currentViewName:", self.currentViewName)
		if name == self.currentViewName then
			return true
		end

		if self.currentView then
			self.currentView:destroy()
			self.currentView = nil
		end

		local view

		self.currentViewName = name
		-- local viewName = self:getEmployeeViewBasedOnOrientation(self.lastKnownOrientation)
		-- print("viewName returned based on last known orientation:", viewName)
		if name == "loginView" then
			view = LoginView:new(self)
			view:move(display.actualContentWidth / 2 - view.width / 2, display.actualContentHeight * 0.2)
		elseif name == "employeeViewLarge" or name == "employeeView" then
			local t = self.lastKnownOrientation
			self.lastKnownOrientation = t
			if self.currentViewName == "employeeView" or self.currentViewName == "employeeViewLarge" then
				local employeeViewToShow = self:whichEmployeeViewToShowBasedOnOrientation()
				if employeeViewToShow == "employeeView" then
					view = EmployeeView:new(self)
				else
					view = EmployeeViewLarge:new(self)
				end
			end
		elseif name == "editEmployeeView" then
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