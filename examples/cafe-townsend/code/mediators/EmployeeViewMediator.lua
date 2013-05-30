EmployeeViewMediator = {}

function EmployeeViewMediator:new()
	local mediator = {}

	function mediator:onRegister()
		Runtime:addEventListener("EmployeesModel_onChanged", self)
		local view = self.viewInstance
		view:addEventListener("onViewEmployee", self)
		view:setEmployees(gEmployeesModel.employees)
	end

	function mediator:onRemove()
		Runtime:removeEventListener("EmployeesModel_onChanged", self)
		local view = self.viewInstance
		view:removeEventListener("onViewEmployee", self)
	end

	function mediator:EmployeesModel_onChanged(event)
		self.viewInstance:setEmployees(gEmployeesModel.employees)
	end

	function mediator:onViewEmployee(event)
		Runtime:dispatchEvent({name="onEditEmployee", employee=event.employee})
	end

	return mediator
end

return EmployeeViewMediator