require "components.Picture"
require "components.InputText"
require "components.AutoSizeText"

EditEmployeeLarge = {}

function EditEmployeeLarge:new(parentGroup)

	local view = display.newGroup()

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local picture = Picture:new(self)
		self.picture = picture
		picture:addEventListener("onAddTouched", self)

		local headerLabel = AutoSizeText:new(self)
		self.headerLabel = headerLabel
		headerLabel:setAutoSize(true)
		headerLabel:setFontSize(31)
		headerLabel:setTextColor(255, 255, 255)
		headerLabel:setFont(self.FONT_NAME)

		local form = display.newImage(self, "assets/images/phone/employee-form-background.png")
		form:setReferencePoint(display.TopLeftReferencePoint)
		self.form = form

		local firstInput = InputText:new(self, form.width - 8, 30, "First Name")
		self.firstInput = firstInput
		firstInput:addEventListener("userInput", self)

		local lastInput = InputText:new(self, form.width - 8, 30, "Last Name")
		self.lastInput = lastInput
		lastInput:addEventListener("userInput", self)

		local phoneInput = InputText:new(self, form.width - 8, 30, "Phone")
		self.phoneInput = phoneInput
		phoneInput:addEventListener("userInput", self)

		self:move(self.x, self.y)
	end

	function view:move(targetX, targetY)
		local picture = self.picture
		local form = self.form
		local firstInput = self.firstInput
		local lastInput = self.lastInput
		local phoneInput = self.phoneInput
		local totalWidth = picture.width + 16 + form.width
		picture.x = (display.actualContentWidth - totalWidth) / 2
		form.x = picture.x + picture.width + 16
		form.y = picture.y + picture.height + 16

		firstInput:move(form.x + 8, form.y + 4)
		lastInput:move(firstInput.x, firstInput.y + 43)
		phoneInput:move(lastInput.x, lastInput.y + 44)
	end

	function view:resize()
		local headerLabel = self.headerLabel
		local picture = self.picture
		-- ghetto measurement in full effect
		headerLabel.x = display.actualContentWidth / 2 - headerLabel.width / 2
		headerLabel.y = picture.y + picture.height / 2 - headerLabel.height / 2
	end

	function view:setEmployee(employee)
		self.employee = employee
		self.headerLabel:setText(employee:getDisplayName())
		self.firstInput:setText(employee.firstName)
		self.lastInput:setText(employee.lastName)
		self.phoneInput:setText(employee.phoneNumber)
		self:showPhoto(employee.iconURL)
		self:resize()
	end

	function view:destroy()
		self.firstInput:destroy()
		self.firstInput = nil

		self.lastInput:destroy()
		self.lastInput = nil

		self.phoneInput:destroy()
		self.phoneInput = nil

		self:removeSelf()
	end

	view:init()

	return view
end

return EditEmployeeLarge