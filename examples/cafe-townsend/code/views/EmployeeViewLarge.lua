require "components.SearchInput"
require "components.PushButton"
require "components.AutoSizeText"
require "components.EmployeeList"
require "components.EditEmployeeLarge"
local widget = require "widget"

EmployeeViewLarge = {}

function EmployeeViewLarge:new(parentGroup)
	local view = display.newGroup()
	view.classType = "EmployeeViewLarge"
	view.FONT_NAME = "HelveticaNeue-Bold"
	view.employees = nil

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		print("EmployeeViewLarge::init")
		local header = display.newImage(self, "assets/images/phone/header.png", 0, 0, true)
		header:setReferencePoint(display.TopLeftReferencePoint)
		self.header = header

		header.width = display.actualContentWidth
		header:setReferencePoint(display.TopLeftReferencePoint)
		header.x = 0

		local headerLabel = AutoSizeText:new(self)
		self.headerLabel = headerLabel
		headerLabel:setText("Employees")
		headerLabel:setAutoSize(true)
		headerLabel:setFontSize(38)
		headerLabel:setTextColor(255, 255, 255)
		headerLabel:setFont(self.FONT_NAME)
		-- ghetto measurement in full effect
		headerLabel.x = stage.width / 2 - headerLabel.width / 4
		headerLabel.y = header.y + header.height / 2 - headerLabel.height / 3

		local logoffButton = PushButton:new(self)
		self.logoffButton = logoffButton
		logoffButton:setLabel("Log Off")
		logoffButton:setSize(140, logoffButton.height)
		logoffButton.x = 4
		logoffButton.y = 6
		logoffButton:addEventListener("onPushButtonTouched", self)

		local newButton = PushButton:new(self)
		self.newButton = newButton
		newButton:setLabel("New")
		newButton:setSize(100, newButton.height)
		newButton.x = stage.width * 0.3
		newButton.y = stage.height - (newButton.height * 2)
		newButton:addEventListener("onPushButtonTouched", self)

		local search = SearchInput:new(self)
		self.search = search
		search:move(header.x + 6, header.y + header.height + 6)
		search:addEventListener("onSearch", self)

		local employeListY = search.y + search.height + 6
		local employeeList = EmployeeList:new(self, display.actualContentWidth * 0.3, display.actualContentHeight - employeListY - (newButton.height + 12))
		self.employeeList = employeeList
		employeeList:addEventListener("onViewEmployee", self)
		employeeList.y = employeListY

		local editEmployee = EditEmployeeLarge:new(self)
		self.editEmployee = editEmployee
		editEmployee:move(display.actualContentWidth - (editEmployee.width + 8), header.y + header.height + 8)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:onViewEmployee(event)
		self.editEmployee:setEmployee(event.employee)
	end

	function view:onPushButtonTouched(event)
		local t = event.target
		if t == self.logoffButton then
			self:dispatchEvent({name="onLogoff"})
		elseif t == self.newButton then
			self:dispatchEvent({name="onNewEmployee"})
		end
	end

	function view:onSearch(event)
		if self.employees then
			self.employeeList:setSearch(self.search:getText())
		end
	end

	function view:setEmployees(employees)
		-- print("EmployeeView::setEmployees, employees:", table.maxn(employees))
		self.employees = employees
		self.employeeList:setEmployees(employees)
	end

	function view:destroy()
		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})
		self.employeeList:destroy()
		self.employeeList = nil
		self.search:destroy()
		self.search = nil
		self.editEmployee:destroy()
		self.editEmployee = nil
		self:removeSelf()
	end

	view:init()

	return view
end

return EmployeeViewLarge