require "vo.EmployeeVO"

CafeTownsendApplicationMediator = {}

function CafeTownsendApplicationMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		Runtime:addEventListener("onLoginSuccess", self)
		Runtime:addEventListener("onEditEmployee", self)
		Runtime:addEventListener("onEmployeeUpdated", self)
		Runtime:addEventListener("onEditEmployeeBackButtonTouched", self)
		Runtime:addEventListener("onLogoff", self)

		Runtime:addEventListener("onCreateNewEmployee", self)
		Runtime:addEventListener("onNewEmployeeSaved", self)

		Runtime:addEventListener("onDeleteEmployeeSuccess", self)
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
		gEmployeesModel.currentEmployee = nil
		self.viewInstance:showView("employeeView")
	end

	function mediator:onEditEmployeeBackButtonTouched()
		gEmployeesModel.currentEmployee = nil
		self.viewInstance:showView("employeeView")
	end

	function mediator:onLogoff()
		gEmployeesModel.currentEmployee = nil
		self.viewInstance:showView("loginView")
	end

	function mediator:onCreateNewEmployee()
		gEmployeesModel.newEmployee = EmployeeVO:new()
		self.viewInstance:showView("editEmployeeView")
	end

	function mediator:onNewEmployeeSaved()
		gEmployeesModel.newEmployee = nil
		self.viewInstance:showView("employeeView")
	end

	function mediator:onDeleteEmployeeSuccess()
		gEmployeesModel.currentEmployee = nil
		self.viewInstance:showView("employeeView")
	end

	return mediator
end

return CafeTownsendApplicationMediator