require "vo.EmployeeVO"

EmployeesModel = {}

function EmployeesModel:new()
	local model = {}
	model.employees = nil
      model.currentEmployee = nil
      model.newEmployee = nil

	function model:init()
		self.employees = {
	 		EmployeeVO:new({id=1,firstName="Tina",lastName="Maintz",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 2,     firstName="Rachel",  lastName="Dougan",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 3,     firstName="Ellie",   lastName="Spencer",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 4,     firstName="Jamie",lastName="Avins", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 5,     firstName="Aaron",lastName="Conran",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 6,     firstName="Dave", lastName="Kaneda",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 7,     firstName="Jacky",lastName="Nguyen",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 8,     firstName="Abraham",lastName="Elias", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 9,     firstName="Jay",  lastName="Robinson",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 10,     firstName="Nickie",lastName="White", phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 11,    firstName="Daria",  lastName="Griffin",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 12,    firstName="Nico", lastName="Ferrero",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 13,   firstName= "Jason",lastName="Johnston",phoneNumber="508-566-6666" }),
            EmployeeVO:new({ id= 14,   firstName= "Ryan",lastName="Dyson",phoneNumber="508-566-6666" })
        }

            local employees = self.employees
            local i
            local len = #employees
            local base = "assets/headshots/"
            for i=1,len do
                  local vo = employees[i]
                  vo.iconURL = base .. tostring(vo.id) .. "-" .. vo.firstName .. "-" .. vo.lastName .. ".jpg"
            end
	end

      function model:getNewID()
            local highest = 1
            local employees = self.employees
            local i
            local len = #employees
            for i=1,len do
                  local vo = employees[i]
                  highest = math.max(highest, vo.id)
            end
            highest = highest + 1
            return highest
      end

      function model:delete(employee)
            local index = table.indexOf(self.employees, employee)
            if index then
                  table.remove(self.employees, index)
                  Runtime:dispatchEvent({name="EmployeesModel_onChanged", 
                                          target=self,
                                          index=index, 
                                          employee=employee,
                                          kind="remove"})
                  return true
            end
            return false
      end

      function model:save(employee)
            local index = table.indexOf(self.employees, employee)
            if index == nil then
                  employee.id = self:getNewID()
                  table.insert(self.employees, employee)
                  Runtime:dispatchEvent({name="EmployeesModel_onChanged", 
                                          target=self,
                                          index=table.indexOf(self.employees, employee), 
                                          employee=employee,
                                          kind="add"})
                  return true
            end
            return false
      end

      function model:update(employee)
            local i
            local employees = self.employees
            local len = #employees
            for i=1,len do
                  local vo = employees[i]
                  if vo.id == employee.id then
                        vo:copyFromVO(employee)
                        Runtime:dispatchEvent({name="EmployeesModel_onChanged", 
                                          target=self,
                                          index=i, 
                                          employee=vo,
                                          kind="update"})
                        return true
                  end
            end

            return false
      end

	model:init()

	return model
end

return EmployeesModel