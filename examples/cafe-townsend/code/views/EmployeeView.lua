require "components.SearchInput"
require "components.PushButton"
require "components.AutoSizeText"
local widget = require "widget"

EmployeeView = {}

function EmployeeView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "EmployeeView"
	view.FONT_NAME = "HelveticaNeue-Bold"
	view.employees = nil
	view.lettersHash = nil
	view.employeesSorted = nil
	view.employeesHash = {}
	view.COLOR_TEXT = {0, 0, 0}
	view.HEADER_TEXT_COLOR = {14, 106, 166}
	view.HEADER_COLOR = {89, 179, 245}

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local header = display.newImage(self, "assets/images/phone/header.png", 0, 0, true)
		header:setReferencePoint(display.TopLeftReferencePoint)
		self.header = header

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

		local newButton = PushButton:new(self)
		self.newButton = newButton
		newButton:setLabel("New")
		newButton:setSize(100, newButton.height)
		newButton.x = header.width - newButton.width - 4
		newButton.y = 6

		local headerSearch = display.newImage(self, "assets/images/phone/header-search.png", 0, 0, true)
		self.headerSearch = headerSearch
		headerSearch:setReferencePoint(display.TopLeftReferencePoint)
		headerSearch.y = header.y + header.height

		local search = SearchInput:new(self)
		self.search = search
		search:move(headerSearch.x + 6, headerSearch.y + 6)
		search:addEventListener("onSearch", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:onSearch(event)
		if self.employees then
			self:redraw()
		end
	end

	function view:onRowRender( event )

	    local phase = event.phase
	    local row = event.row
	    local key = tostring(row.index)
	    local employee = self.employeesHash[key]
	    local textForRow
	    if employee then
	    	textForRow = employee:getDisplayName()
	    else
	    	local letter = self.lettersHash[key]
	    	if letter then
	    		textForRow = letter.name
	    	else
	    		print("key:", key)
	    		error("Nothing found for index:", key)
	    	end
	    end

	    local rowTitle = display.newText(row, textForRow, 0, 0, native.systemFont, 28)
	    rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
	    rowTitle.x = rowTitle.x + 16
	    rowTitle.y = row.contentHeight * 0.5
	    rowTitle:setTextColor(unpack(self.HEADER_TEXT_COLOR))
	end

	function view:createSorted(filterOn)
		self.employeesSorted = {}
		local sorted = self.employeesSorted
		local i
		local employees
		local originalEmployees = self.employees

		if filterOn == nil or filterOn == "" then
			employees = self.employees
		else
			employees = {}
			local tempLen = table.maxn(originalEmployees)
			local tempIndex
			for tempIndex = 1,tempLen do
				local testEmployee = originalEmployees[tempIndex]
				local foundFirst = string.find(testEmployee.firstName:upper(), filterOn:upper())
				local foundLast = string.find(testEmployee.lastName:upper(), filterOn:upper())
				local foundNumber = string.find(testEmployee.phoneNumber, filterOn)
				
				-- print("tempIndex:", tempIndex, foundFirst, foundLast, foundNumber)
				if foundFirst ~= nil or foundLast ~= nil or foundNumber ~= nil then
					-- print("removing:", tempIndex)
					table.insert(employees, testEmployee)
				end
			end
		end

		print("after filter:", #employees)

		local len = #employees
		local localHash = {}
		for i=1,len do
			local vo = employees[i]
			local firstName = vo.firstName:upper()
			local char = string.sub(firstName, 1, 1)
			local employeesSorted = localHash[char]
			if employeesSorted == nil then
				employeesSorted = {}
				employeesSorted.name = char
				table.insert(employeesSorted, vo)
				table.insert(sorted, employeesSorted)
				localHash[char] = employeesSorted
			else
				employeesSorted = localHash[char]
				table.insert(employeesSorted, vo)
			end
		end

		
		table.sort(sorted, function(a, b) return a.name < b.name end)
		return employees, sorted
	end

	function view:setEmployees(employees)
		print("EmployeeView::setEmployees, employees:", table.maxn(employees))
		self.employees = employees
		self:redraw()
	end

	function view:redraw()
		local employees, sorted = self:createSorted(self.search:getSearch())

		if self.tableView then
			self.tableView:removeSelf()
			self.tableView = nil
		end

		if employees == nil or #employees < 1 then
			return false
		end

		local headerSearch = self.headerSearch

		local tableView = widget.newTableView
		{
		    top = 0,
		    width = stage.width, 
		    height = stage.height - (headerSearch.y + headerSearch.height),
		    listener = function(e)
		    end,
		    onRowRender = function(e)self:onRowRender(e)end,
		    onRowTouch = function(e)self:onRowTouch(e)end,
		    onRowUpdate = function(e)self:onRowUpdate(e)end
		}
		self:insert(tableView)
		tableView.y = headerSearch.y + headerSearch.height
		self.tableView = tableView

		local isCategory = false
	    local rowHeight = 80
	    local lineColor = { 220, 220, 220 }

		local l
		self.lettersHash = {}
		self.employeesHash = {}

		local lettersHash = self.lettersHash
		local employeesHash = self.employeesHash
		local counterIndex = 1
		print("now sorted:", #sorted)
		for l = 1, #sorted do
			
			local letters = sorted[l]
			lettersHash[tostring(counterIndex)] = letters
			counterIndex = counterIndex + 1
			tableView:insertRow
			{
				isCategory = true,
				rowHeight = 60,
				rowColor = 
		        { 
		            default = view.HEADER_COLOR,
		        },
				lineColor = lineColor
			}

			local k
			for k = 1, #letters do
				local employee = letters[k]
				employeesHash[tostring(counterIndex)] = employee
				counterIndex = counterIndex + 1
			    tableView:insertRow
				{
					isCategory = false,
					rowHeight = rowHeight,
					rowColor = rowColor,
					lineColor = lineColor
				}
				
			end
		end
	end

	function view:onRowTouch(event)
	    local phase = event.phase
	    if phase == "tap" or phase == "release" then
	    	local index = event.target.index
	       	local key = tostring(index)
	       	local employee = self.employeesHash[key]
	       	if employee then
	       		self:dispatchEvent({name="onViewEmployee", employee=employee})
	       	end
	    end
	    return true
	end


	view:init()

	return view
end

return EmployeeView