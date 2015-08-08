local DeleteEmployeeService =  "services.DeleteEmployeeService"

local DeleteEmployeeCommand = {}

function DeleteEmployeeCommand:new()
	local command = {}
	command.employee = nil

	function command:execute(event)
		print("DeleteEmployeeCommand::execute")
		self.employee = event.employee
		local service = DeleteEmployeeService:new()
		service:addEventListener("onDeleteEmployeeSuccess", self)
		service:deleteEmployee(self.employee)
	end

	function command:onDeleteEmployeeSuccess()
		print("DeleteEmployeeCommand::onDeleteEmployeeSuccess")
		local success = gEmployeesModel:delete(self.employee)
		print("success:", success)
		if success then
			Runtime:dispatchEvent({name="onDeleteEmployeeSuccess"})
		end
	end

	return command
end

return DeleteEmployeeCommand