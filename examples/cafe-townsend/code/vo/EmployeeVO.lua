EmployeeVO = {}

function EmployeeVO:new(params)
	local vo = {}
	vo.id = params.id
	vo.firstName = params.firstName
	vo.lastName = params.lastName
	vo.iconURL = params.iconURL
	vo.phoneNumber = params.phoneNumber

	function vo:getDisplayName()
		return self.firstName .. " " .. self.lastName
	end

	return vo
end

return EmployeeVO