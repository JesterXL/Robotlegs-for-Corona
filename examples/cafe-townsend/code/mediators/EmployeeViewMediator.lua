local EmployeeViewMediator = {}

function EmployeeViewMediator:new()
	local mediator = {}

	function mediator:onRegister()
		Runtime:addEventListener("EmployeesModel_onChanged", self)
		local view = self.viewInstance
		view:addEventListener("onViewEmployee", self)
		view:addEventListener("onLogoff", self)
		view:addEventListener("onNewEmployee", self)

		if gEmployeesModel.loaded then
			view:setEmployees(gEmployeesModel.employees)
		else
			Runtime:dispatchEvent({name="onLoadEmployees"})
			timer.performWithDelay(1500,function()
				gEmployeesModel.loaded = true
				view:setEmployees(gEmployeesModel.employees)
				Runtime:dispatchEvent({name="onLoadEmployeesSuccess"})
			end)
		end
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
		print("EmployeeView::onViewEmployee")
		Runtime:dispatchEvent({name="onEditEmployee", employee=event.employee})
	end

	function mediator:onLogoff()
		Runtime:dispatchEvent({name="onLogoff"})
	end

	function mediator:onNewEmployee()
		Runtime:dispatchEvent({name="onCreateNewEmployee"})
	end

	return mediator
end

return EmployeeViewMediator