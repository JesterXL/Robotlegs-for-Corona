local AutoSizeText = require "components.AutoSizeText"
local Picture = require "components.Picture"
local InputText = require "components.InputText"
local DeleteButton = require "components.DeleteButton"
local BackButton = require "components.BackButton"
local HoverMenu = require "components.HoverMenu"

local EditEmployeeView = {}

function EditEmployeeView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "EditEmployeeView"
	view.employee = nil
	view.photo = nil

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local header = display.newImage(self, "assets/images/phone/header.png", 0, 0, true)
		header.width = display.actualContentWidth
		header:setReferencePoint(display.TopLeftReferencePoint)
		header.x = 0
		self.header = header

		local headerLabel = AutoSizeText:new(self)
		self.headerLabel = headerLabel
		headerLabel:setAutoSize(true)
		headerLabel:setFontSize(31)
		headerLabel:setTextColor(255, 255, 255)
		headerLabel:setFont(self.FONT_NAME)

		local picture = Picture:new(self)
		self.picture = picture
		picture:addEventListener("onAddTouched", self)

		local form = display.newImage(self, "assets/images/phone/employee-form-background.png")
		form:setReferencePoint(display.TopLeftReferencePoint)
		self.form = form

		local totalWidth = picture.width + 16 + form.width
		picture.x = (display.actualContentWidth - totalWidth) / 2
		picture.y = header.y + header.height + 32
		form.x = picture.x + picture.width + 16
		form.y = picture.y

		local firstInput = InputText:new(self, form.width - 8, 30, "First Name")
		self.firstInput = firstInput
		firstInput:move(form.x + 8, form.y + 4)
		firstInput:addEventListener("userInput", self)

		local lastInput = InputText:new(self, form.width - 8, 30, "Last Name")
		self.lastInput = lastInput
		lastInput:move(firstInput.x, firstInput.y + 43)
		lastInput:addEventListener("userInput", self)

		local phoneInput = InputText:new(self, form.width - 8, 30, "Phone")
		self.phoneInput = phoneInput
		phoneInput:move(lastInput.x, lastInput.y + 44)
		phoneInput:addEventListener("userInput", self)

		local deleteButton = DeleteButton:new(self, totalWidth, 67)
		self.deleteButton = deleteButton
		deleteButton:addEventListener("onDeleteButtonTouched", self)
		deleteButton.x = picture.x
		deleteButton.y = form.y + form.height + 32
		deleteButton:setLabel("Delete Employee")

		local backButton = BackButton:new(self)
		backButton:addEventListener("onBackButtonTouched", self)
		self.backButton = backButton
		backButton.x = 6
		backButton.y = 6

		local saveButton = PushButton:new(self, 140, 67)
		self.saveButton = saveButton
		saveButton.x = display.actualContentWidth - saveButton.width - 6
		saveButton.y = backButton.y
		saveButton:setLabel("Save")
		saveButton:addEventListener("onPushButtonTouched", self)

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})

	end

	function view:userInput(event)
		local vo = self.employee
		local t = event.target
		if t == self.firstInput then
			vo.firstName = self.firstInput:getText()
		elseif t == self.lastInput then
			vo.lastName = self.lastInput:getText()
		elseif t == self.phoneInput then
			vo.phoneNumber = self.phoneInput:getText()
		end
	end

	function view:onDeleteButtonTouched()
		if self.employee == nil then return false end
		local employeeName = self.employee:getDisplayName()
		native.showAlert("Delete Employee",
							"Are you sure you wish to delete employee '" .. employeeName .. "'?",
							{"Delete Employee", "Cancel"}, function(e) view:onConfirmDelete(e)end)
		
	end

	function view:onConfirmDelete(event)
		if event.action == "clicked" and event.index == 1 then
			self:dispatchEvent({name="onDeleteEmployee"})
		end
	end

	function view:onBackButtonTouched(event)
		self:dispatchEvent({name="onBackButtonTouched"})
	end

	function view:onPushButtonTouched(event)
		self:dispatchEvent({name="onSaveEmployee"})
	end

	function view:resize()
		local headerLabel = self.headerLabel
		local header = self.header
		-- ghetto measurement in full effect
		headerLabel.x = display.actualContentWidth / 2 - headerLabel.width / 2
		headerLabel.y = header.y + header.height / 2 - headerLabel.height / 2
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

	function view:onAddTouched()
		if media.hasSource( media.Camera ) then
			if self.menu == nil then
				local picture = self.picture
				local menu = HoverMenu:new(self, {"Choose Existing Photo", "New Photo"})
				menu:addEventListener("onMenuButtonTouched", self)
				self.menu = menu
				menu.x = picture.x + picture.width / 2 - menu.width / 2
				menu.y = picture.y + picture.height - 8
				if menu.x < 0 then
					menu.x = 0
				end
			else
				self.menu:removeSelf()
				self.menu = nil
			end
		else
			self:chooseExistingPhoto()
		end
	end

	function view:onMenuButtonTouched(event)
		self.menu:removeSelf()
		self.menu = nil
		local l = event.label
		if l == "Choose Existing Photo" then
			self:chooseExistingPhoto()
		else
			self:takeNewPhoto()
		end
	end

	function view:chooseExistingPhoto()
		 media.show(media.PhotoLibrary,
		        {listener=self, 
		        origin = self.picture.contentBounds, 
		        permittedArrowDirections = { "up", "right" } },
		        {baseDir=system.TemporaryDirectory, filename=self:getImageFilename(), type="image"} )

	end

	function view:takeNewPhoto()
		if media.hasSource( media.Camera ) then
		   media.show( media.Camera, self)
		else
		   native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
		end
	end

	function view:completion(event)
		if self.loadedImage then
			self.loadedImage:removeSelf()
		end

		local filename = self:getImageFilename()
		-- print("filename:", filename)
		if event.target == nil then
			-- print("loading local")
			-- print(self:getImageFilename())
			self.loadedImage = display.newImage(self, filename, system.TemporaryDirectory)
			-- showProps(self.loadedImage)
		else
			-- print("using event")
			self.loadedImage = event.target
			self:insert(self.loadedImage)
			display.save(self.loadedImage, filename)
		end
		self:sizePhoto()
	end

	function view:showPhoto(url)
		print("EditEmployeeView::showPhoto, url: ", url)
		if self.loadedImage then
			self.loadedImage:removeSelf()
		end
		if url and url ~= "" then
			self.loadedImage = display.newImage(self, url)
			if self.loadedImage == nil then
				self.loadedImage = display.newImage(self, url, system.TemporaryDirectory)
			end
			self:sizePhoto()
		end
	end

	function view:getImageFilename()
		local employee = self.employee
		if employee.iconURL and employee.iconURL ~= "" then
			return employee.iconURL
		else
			return employee.firstName .. "-" .. employee.lastName .. ".jpg"
		end
	end

	function view:sizePhoto()
	  local picture = self.picture
	  local photo = self.loadedImage
	  if picture and photo then
		   photo.width = picture.width
		   photo.height = picture.height
		   photo.x = picture.x + photo.width / 2
		   photo.y = picture.y + photo.height / 2
		end
	   -- local mask = graphics.newMask("assets/images/phone/photo-mask.png")
	   -- photo:setMask(mask)
	   -- photo.maskX = -4
	   -- photo.maskY = -4
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

return EditEmployeeView