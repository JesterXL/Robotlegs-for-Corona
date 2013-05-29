require "services.DeleteEmployeeService"

DeleteEmployeeCommand = {}

function DeleteEmployeeCommand:new()
	local command = {}

	function command:execute(event)
		local service = DeleteEmployeeService:new()
		service:addEventListener("onDeleteEmployeeSuccess", self)
		service:deleteEmployee(event.employee)
	end

	function command:onDeleteEmployeeSuccess()
		Runtime:dispatchEvent({name="onDeleteEmployeeSuccess"})
	end

	return command
end

return DeleteEmployeeCommand