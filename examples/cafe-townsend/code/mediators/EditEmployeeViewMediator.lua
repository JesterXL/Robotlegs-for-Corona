require "vo.EmployeeVO"
EditEmployeeViewMediator = {}

function EditEmployeeViewMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("onDeleteEmployee", self)
		view:addEventListener("onBackButtonTouched", self)
		view:addEventListener("onSaveEmployee", self)
		view:setEmployee(gEmployeesModel.currentEmployee)
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
		local vo = EmployeeVO:new({id=view.employee.id,
									firstName=view.firstInput:getText(),
									lastName=view.lastInput:getText(),
									phoneNumber=view.phoneInput:getText(),
									iconURL=view:getImageFilename()})
		Runtime:dispatchEvent({name="updateEmployee", employee=vo})
	end

	function mediator:onBackButtonTouched()
		Runtime:dispatchEvent({name="onEditEmployeeBackButtonTouched"})
	end


	return mediator
end

return EditEmployeeViewMediator