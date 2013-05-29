require "CafeTownsendContext"
require "views.LoginView"
require "views.LoadingView"
require "views.EmployeeView"

CafeTownsendAplication = {}

function CafeTownsendAplication:new()
	local application = display.newGroup()

	function application:init()
		local background = display.newRect(self, 0, 0, stage.width, stage.height)

		local context = CafeTownsendContext:new()
		context:init()
		
		-- local loginView = LoginView:new(self)
		-- loginView:move(stage.width / 2 - loginView.width / 2, stage.height * 0.2)

		local loadingView = LoadingView:new(self)

		local employeeView = EmployeeView:new(self)


	end

	application:init()

	return application
end

return CafeTownsendAplication