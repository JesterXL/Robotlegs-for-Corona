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
		-- local k = event.kind
		-- if k == "remove" then

		-- elseif k == "add" then

		-- elseif k == "update" then

		-- end
		-- [jwarden 5.30.2013] TODO: optimize redraw
		self.viewInstance:setEmployees(gEmployeesModel.employees)
	end

	function mediator:onViewEmployee(event)
		Runtime:dispatchEvent({name="onEditEmployee", employee=event.employee})
	end

	return mediator
end

return EmployeeViewMediator