EditEmployeeViewMediator = {}

function EditEmployeeViewMediator:new()
	local mediator = {}
 
	function mediator:onRegister()
		local view = self.viewInstance
		view:addEventListener("onDeleteEmployee", self)
		view:addEventListener("onBackButtonTouched", self)
		view:addEventListener("onSaveEmployee", self)
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
		Runtime:dispatchEvent({name="saveEmployee", employee=self.viewInstance.employee})
	end

	return mediator
end

return EditEmployeeViewMediator