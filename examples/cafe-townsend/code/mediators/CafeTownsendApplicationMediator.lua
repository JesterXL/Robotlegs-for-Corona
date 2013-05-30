CafeTownsendApplicationMediator = {}

function CafeTownsendApplicationMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		Runtime:addEventListener("onLoginSuccess", self)
		Runtime:addEventListener("onEditEmployee", self)
		view:showView("loginView")
	end

	function mediator:onRemove()
		local view = self.viewInstance
		Runtime:removeEventListener("onLoginSuccess", self)
		Runtime:removeEventListener("onEditEmployee", self)
	end

	function mediator:onLoginSuccess()
		self.viewInstance:showView("employeeView")
	end

	function mediator:onEditEmployee(event)
		gEmployeesModel.currentEmployee = event.employee
		self.viewInstance:showView("editEmployeeView")
	end

	return mediator
end

return CafeTownsendApplicationMediator