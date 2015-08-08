local EmployeeVO = require "vo.EmployeeVO"
local EditEmployeeViewMediator = {}

function EditEmployeeViewMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("onDeleteEmployee", self)
		view:addEventListener("onBackButtonTouched", self)
		view:addEventListener("onSaveEmployee", self)
		if gEmployeesModel.currentEmployee then
			view:setEmployee(gEmployeesModel.currentEmployee)
		elseif gEmployeesModel.newEmployee then

			view:setEmployee(gEmployeesModel.newEmployee)
			view.deleteButton.isVisible = false
		else
			error("Unknown state, why was I made? Why... WHY!!!???!")
		end
	end

	function mediator:onRemove()
		local view = self.viewInstance
		view:removeEventListener("onDeleteEmployee", self)
		view:removeEventListener("onBackButtonTouched", self)
		view:removeEventListener("onSaveEmployee", self)
	end

	function mediator:onDeleteEmployee()
		print("EditEmployeeViewMediator::onDeleteEmployee")
		Runtime:dispatchEvent({name="deleteEmployee", employee=self.viewInstance.employee})
	end

	function mediator:onSaveEmployee()
		print("EditEmployeeViewMediator::onSaveEmployee")
		local view = self.viewInstance
		local filename = view:getImageFilename()
		print("filename:", filename)
		local vo = EmployeeVO:new({id=view.employee.id,
										firstName=view.firstInput:getText(),
										lastName=view.lastInput:getText(),
										phoneNumber=view.phoneInput:getText(),
										iconURL=filename})
		if view.employee == gEmployeesModel.currentEmployee then
			Runtime:dispatchEvent({name="updateEmployee", employee=vo})
		else
			Runtime:dispatchEvent({name="saveEmployee", employee=vo})
		end
	end

	function mediator:onBackButtonTouched()
		Runtime:dispatchEvent({name="onEditEmployeeBackButtonTouched"})
	end


	return mediator
end

return EditEmployeeViewMediator