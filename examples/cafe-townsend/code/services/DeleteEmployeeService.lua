local require "utils.EventDispatcher"
local DeleteEmployeeService = {}

function DeleteEmployeeService:new()
	local service = {}
	EventDispatcher:initialize(service)
	service.timerID = nil

	function service:deleteEmployee(employee)
		print("DeleteEmployee::deleteEmployee...")
		self:cancelOperations()
		self.timerID = timer.performWithDelay(2000, self)
	end

	function service:timer(event)
		self.timerID = nil
		self:dispatchEvent({name="onDeleteEmployeeSuccess"})
	end


	function service:cancelOperations()
		if self.timerID then
			timer.cancel(self.timerID)
			self.timerID = nil
		end
	end

	return service
end

return DeleteEmployeeService