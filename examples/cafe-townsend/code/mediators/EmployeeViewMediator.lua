EmployeeViewMediator = {}

function EmployeeViewMediator:new()
	local mediator = {}

	function mediator:onRegister()
		print("EmployeeViewMediator::onRegister")
		Runtime:addEventListener("EmployeesModel_onChanged", self)
		self.viewInstance:setEmployees(gEmployeesModel.employees)
	end

	function mediator:onRemove()
		Runtime:removeEventListener("EmployeesModel_onChanged", self)
	end

	function mediator:EmployeesModel_onChanged(event)
		self.viewInstance:setEmployees(gEmployeesModel.employees)
	end

	return mediator
end

return EmployeeViewMediator