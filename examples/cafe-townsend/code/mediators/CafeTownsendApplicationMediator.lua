CafeTownsendApplicationMediator = {}

function CafeTownsendApplicationMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		Runtime:addEventListener("onLoginSuccess", self)
		Runtime:addEventListener("onEditEmployee", self)
		Runtime:addEventListener("onEmployeeUpdated", self)
		Runtime:addEventListener("onEditEmployeeBackButtonTouched", self)
		view:showView("loginView")
	end

	function mediator:onLoginSuccess()
		self.viewInstance:showView("employeeView")
	end

	function mediator:onEditEmployee(event)
		gEmployeesModel.currentEmployee = event.employee
		self.viewInstance:showView("editEmployeeView")
	end

	function mediator:onEmployeeUpdated()
		self.viewInstance:showView("employeeView")
	end

	function mediator:onEditEmployeeBackButtonTouched()
		self.viewInstance:showView("employeeView")
	end

	return mediator
end

return CafeTownsendApplicationMediator