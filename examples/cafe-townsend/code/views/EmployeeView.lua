require "components.SearchInput"
require "components.PushButton"
require "components.AutoSizeText"
require "components.EmployeeList"
local widget = require "widget"

EmployeeView = {}

function EmployeeView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "EmployeeView"
	view.FONT_NAME = "HelveticaNeue-Bold"
	view.employees = nil

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local header = display.newImage(self, "assets/images/phone/header.png", 0, 0, true)
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
		headerLabel.x = display.actualContentWidth / 2 - headerLabel.width / 4
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
		newButton.x = header.width - newButton.width - 4
		newButton.y = 6
		newButton:addEventListener("onPushButtonTouched", self)

		local headerSearch = display.newImage(self, "assets/images/phone/header-search.png", 0, 0, true)
		self.headerSearch = headerSearch
		headerSearch.width = display.actualContentWidth
		headerSearch:setReferencePoint(display.TopLeftReferencePoint)
		headerSearch.x = 0
		headerSearch.y = header.y + header.height

		local search = SearchInput:new(self)
		self.search = search
		search:move(headerSearch.x + 6, headerSearch.y + 6)
		search:addEventListener("onSearch", self)

		local employeeList = EmployeeList:new(self, display.actualContentWidth, display.actualContentHeight - (headerSearch.y + headerSearch.height))
		self.employeeList = employeeList
		employeeList:addEventListener("onViewEmployee", function(e) view:dispatchEvent(e) end)
		employeeList.y = headerSearch.y + headerSearch.height
		employeeList:addEventListener("onRowTouch", self)

		-- Runtime:addEventListener("onStageTap", self)
		-- Runtime:addEventListener("onStageTouch", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:onRowTouch(event)
		-- stage:setFocus(nil)
	end

	-- function view:onStageTap(event)
	-- 	print("EmployeeView::onStageTap:", event.phase)
	-- 	stage:setFocus(self)
	-- end

	-- function view:onStageTouch(event)
	-- 	print("EmployeeView::onStageTouch:", event.phase)
	-- 	stage:setFocus(self)
	-- end

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
		Runtime:removeEventListener("onStageTap", self)
		Runtime:removeEventListener("onStageTouch", self)
		self.employeeList:destroy()
		self.employeeList = nil
		self.search:destroy()
		self.search = nil
		
		self:removeSelf()
	end

	view:init()

	return view
end

return EmployeeView