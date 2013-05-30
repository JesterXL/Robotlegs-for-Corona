UpdateEmployeeCommand = {}

function UpdateEmployeeCommand:new()
	local command = {}

	function command:execute(event)
		print("UpdateEmployeeCommand::execute")
		local success = gEmployeesModel:update(event.employee)
		print("success:", success)
		if success then
			Runtime:dispatchEvent({name="onEmployeeUpdated"})
		end
	end

	return command
end

return UpdateEmployeeCommand