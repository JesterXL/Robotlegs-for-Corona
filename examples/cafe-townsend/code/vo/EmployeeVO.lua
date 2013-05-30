EmployeeVO = {}

function EmployeeVO:new(params)

	if params == nil then
		params = {
			id=-1,
			firstName="",
			lastName="",
			iconURL=nil,
			phoneNumber="000-000-0000"
		}
	end

	local vo = {}
	vo.id = params.id
	vo.firstName = params.firstName
	vo.lastName = params.lastName
	vo.iconURL = params.iconURL
	vo.phoneNumber = params.phoneNumber

	function vo:getDisplayName()
		return self.firstName .. " " .. self.lastName
	end

	function vo:copyFromVO(copyVO)
		self.id 		= copyVO
		self.firstName	= copyVO.firstName
		self.lastName	= copyVO.lastName
		self.iconURL	= copyVO.iconURL
		self.phoneNumber	= copyVO.phoneNumber
	end

	return vo
end

return EmployeeVO