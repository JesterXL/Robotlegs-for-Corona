require "components.AutoSizeText"
require "components.PushButton"
LoginView = {}

function LoginView:new(parentGroup)
	local view = display.newGroup()
	view.classType = "LoginView"
	view.FONT_NAME = "HelveticaNeue-Bold"
	view.FONT = native.newFont(view.FONT_NAME)

	if parentGroup then
		parentGroup:insert(view)
	end

	function view:init()
		local titleField = AutoSizeText:new(self)
		self.titleField = self
		titleField:setFont(self.FONT_NAME)
		titleField:setTextColor(0, 0, 0)
		titleField:setFontSize(21)
		titleField:setAutoSize(true)
		titleField:setText("Cafe Townsend Login")

		local loginBackground = display.newImage("assets/images/phone/login-form-background.png")
		self.loginBackground = loginBackground
		loginBackground:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(loginBackground)
		
		local line = display.newLine(self, 0, 0, loginBackground.width, 0)
		line:setColor(180, 180, 180)
		self.line = line
		
		local usernameField = native.newTextField(0, 0, loginBackground.width - 8, 40)
		self.usernameField = usernameField
		usernameField:setReferencePoint(display.TopLeftReferencePoint)
		usernameField.hasBackground = false
		usernameField.font = self.FONT
		usernameField:addEventListener("userInput", self)

		local passwordField = native.newTextField(0, 0, usernameField.width, 40)
		self.passwordField = passwordField
		passwordField:setReferencePoint(display.TopLeftReferencePoint)
		passwordField.hasBackground = false
		passwordField.font = self.FONT
		-- passwordField.isSecure = true
		passwordField:addEventListener("userInput", self)

		local usernameLabel = AutoSizeText:new(self)
		self.usernameLabel = usernameLabel
		usernameLabel:setFont(self.FONT)
		usernameLabel:setTextColor(150, 150, 150)
		usernameLabel:setFontSize(21)
		usernameLabel:setAutoSize(true)
		usernameLabel:setText("Username")

		local passwordLabel = AutoSizeText:new(self)
		self.passwordLabel = passwordLabel
		passwordLabel:setFont(self.FONT)
		passwordLabel:setTextColor(150, 150, 150)
		passwordLabel:setFontSize(21)
		passwordLabel:setAutoSize(true)
		passwordLabel:setText("Password")

		local loginButton = PushButton:new(self)
		self.loginButton = loginButton
		loginButton:setSize(loginBackground.width, loginButton.layoutHeight)
		loginButton:setLabel("Login")
		loginButton:addEventListener("touch", self)

		local errorLabel = AutoSizeText:new(self)
		self.errorLabel = errorLabel
		errorLabel:setFont(self.FONT)
		errorLabel:setTextColor(200, 0, 0)
		errorLabel:setFontSize(21)
		-- errorLabel:setAutoSize(true)
		errorLabel:setSize(loginBackground.width, 0)
		errorLabel.isVisible = false

		loginBackground.y = titleField.y + titleField.height + 8
		
		line.y = loginBackground.y + loginBackground.height / 2

		local targetX, targetY = self:localToContent(loginBackground.x + 1, loginBackground.y + 1)

		usernameField.x = targetX
		usernameField.y = targetY

		passwordField.x = usernameField.x + 1
		passwordField.y = usernameField.y + usernameField.height + 3

		usernameLabel.x = usernameField.x + 4
		usernameLabel.y = usernameField.y

		passwordLabel.x = passwordField.x + 4
		passwordLabel.y = passwordField.y

		loginButton.y = loginBackground.y + loginBackground.height + 8
		loginButton.x = loginBackground.x

		errorLabel.x = loginButton.x
		errorLabel.y = loginButton.y + loginButton.height + 8

		Runtime:dispatchEvent({name="onRobotlegsViewCreated", target=self})
	end

	function view:move(targetX, targetY)
		self.x = targetX
		self.y = targetY

		local loginBackground = self.loginBackground
		local usernameField = self.usernameField
		local passwordField = self.passwordField

		local targetX, targetY = self:localToContent(loginBackground.x + 1, loginBackground.y + 1)

		usernameField.x = targetX
		usernameField.y = targetY

		passwordField.x = usernameField.x + 1
		passwordField.y = usernameField.y + usernameField.height + 3
	end

	function view:error(message)
		local errorLabel = self.errorLabel
		if message ~= nil and message ~= "" then
			errorLabel.isVisible = true
			errorLabel:setText(message)
		else
			errorLabel.isVisible = false
		end
		self:showTextFields(true)
	end

	function view:showTextFields(show)
		self.usernameField.isVisible = show
		self.passwordField.isVisible = show
	end

	function view:userInput(event)
		local t = event.target
		local usernameField = self.usernameField
		local passwordField = self.passwordField
		local usernameLabel = self.usernameLabel
		local passwordLabel = self.passwordLabel

		local pStr = tostring(passwordField.text)
		if pStr == "" and pStr:len() < 1 then
			passwordLabel.isVisible = true
		else
			passwordLabel.isVisible = false
		end

		local uStr = tostring(usernameField.text)
		if uStr == "" and uStr:len() < 1 then
			usernameLabel.isVisible = true
		else
			usernameLabel.isVisible = false
		end

		if event.phase == "submitted" then
			self:dispatchLogin()
		end
	end

	function view:touch(event)
		local p = event.phase
		if p == "ended" then
			self:dispatchLogin()
		end
		return true
	end

	function view:dispatchLogin()
		local usernameField = self.usernameField
		local passwordField = self.passwordField
		stage:setFocus(self, nil)
		self:showTextFields(false)

		self:dispatchEvent({name="onLogin", username=usernameField.text, password=passwordField.text})
	end

	function view:destroy()
		Runtime:dispatchEvent({name="onRobotlegsViewDestroyed", target=self})
		self.usernameField:removeSelf()
		self.passwordField:removeSelf()
		self:removeSelf()
	end

	view:init()

	return view
end

return LoginView