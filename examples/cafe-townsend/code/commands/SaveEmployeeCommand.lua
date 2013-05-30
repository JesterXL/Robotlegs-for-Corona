SaveEmployeeCommand = {}

function SaveEmployeeCommand:new()
	local command = {}

	function command:execute(event)
		gEmployeesModel:save(event.employee)
		Runtime:dispatchEvent({name="onNewEmployeeSaved"})
	end

	return command
end

return SaveEmployeeCommand