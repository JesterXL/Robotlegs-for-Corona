local widget = require "widget"
EmployeeList = {}

function EmployeeList:new(parentGroup, layoutWidth, layoutHeight)

	local view = display.newGroup()
	view.employeesHash = {}
	view.lettersHash = {}
	view.COLOR_TEXT = {0, 0, 0}
	view.HEADER_TEXT_COLOR = {14, 106, 166}
	view.HEADER_COLOR = {89, 179, 245}
	view.layoutWidth = layoutWidth
	view.layoutHeight = layoutHeight
	view.searchFilter = nil
	view.lettersHash = nil
	view.employeesSorted = nil

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:getSearch()
		return self.searchFilter
	end

	function view:setSearch(filter)
		self.searchFilter = filter
		self:clearSearchTimer()
		timer.performWithDelay(100, function(e)
			view:setEmployees(view.employees)
		end)
	end

	function view:clearSearchTimer()
		if self.searchID then
			timer.cancel(self.searchID)
			self.searchID = nil
		end
	end

	function view:setEmployees(employees)
		self:clearSearchTimer()
		self.employees = employees
		local employees, sorted = self:createSorted(self:getSearch())

		if self.tableView then
			self.tableView:removeSelf()
			self.tableView = nil
		end

		if employees == nil or #employees < 1 then
			return false
		end

		local tableView = widget.newTableView
		{
		    top = 0,
		    width = self.layoutWidth, 
		    height = self.layoutHeight,
		    listener = function(e)
		    end,
		    onRowRender = function(e)self:onRowRender(e)end,
		    onRowTouch = function(e)self:onRowTouch(e)end,
		    onRowUpdate = function(e)self:onRowUpdate(e)end
		}
		self.tableView = tableView
		self:insert(tableView)
		
		-- local headerSearch = self.headerSearch

		
		-- tableView.y = headerSearch.y + headerSearch.height
		-- self.tableView = tableView

		local isCategory = false
	    local rowHeight = 80
	    local lineColor = { 220, 220, 220 }

		local l
		self.lettersHash = {}
		self.employeesHash = {}

		local lettersHash = self.lettersHash
		local employeesHash = self.employeesHash
		local counterIndex = 1
		-- print("now sorted:", #sorted)
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
		            default = self.HEADER_COLOR,
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

		-- print("after filter:", #employees)

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

	function view:onRowTouch(event)
	    local phase = event.phase
	    if phase == "tap" or phase == "release" then
	    	local index = event.target.index
	       	local key = tostring(index)
	       	local employee = self.employeesHash[key]
	       	if employee then
	       		-- [jwarden 5.29.2013] KLUDGE/HACK: The table View, after getting destroyed,
	       		-- attempts to fill it's up state, but can't, because it's dead.
	       		-- This, folks, is why I love Promises. :: Borat voice :: NOT!
	       		
	       		timer.performWithDelay(100, function(e)
	       			self:dispatchEvent({name="onViewEmployee", employee=employee})
	       		end)
	       	end
	    end
	    return true
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

	return view

end


return EmployeeList