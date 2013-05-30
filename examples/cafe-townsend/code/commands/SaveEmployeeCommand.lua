SaveEmployeeCommand = {}

function SaveEmployeeCommand:new()
	local command = {}

	function command:execute(event)
		print("SaveEmployeeCommand::execute")
		local success = gEmployeesModel:save(event.employee)
		print("success:", success)
		if success then
			Runtime:dispatchEvent({name="onNewEmployeeSaved"})
		end
	end

	return command
end

return SaveEmployeeCommand