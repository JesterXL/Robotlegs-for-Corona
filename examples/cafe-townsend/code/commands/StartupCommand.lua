local EmployeesModel = require "models.EmployeesModel"
StartupCommand = {}

function StartupCommand:new()
	local command = {}

	function command:execute(event)
		_G.gEmployeesModel = EmployeesModel:new()
	end

	return command
end

return StartupCommand