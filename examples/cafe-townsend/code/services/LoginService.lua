local EventDispatcher = require "utils.EventDispatcher"
local json = require "json"
local ReadFileContentsService = require "services.ReadFileContentsService"
local LoginService = {}

function LoginService:new()
	local service = {}
	EventDispatcher:initialize(service)
	service.timerID = nil
	service.networkID = nil
	service._username = nil
	service._password = nil

	function service:login(username, password)
		print("LoginService::login...")
		self:cancelOperations()
		self._username = username
		self._password = password
		self.timerID = timer.performWithDelay(2000, self)
	end

	function service:timer(event)
		self.timerID = nil
		local url
		print(self._username, self._password)
		if self._username == "admin" and self._password == "password" then
			url = "services/mocks/login_success.json"
		else
			url = "services/mocks/login_error.json"
		end
		-- [jwarden 5.29.2013] NOTE: Normally you'd make a network request,
		-- but we're just going to open a mock file. If you have a server,
		-- feel free to use that instead.
		-- local params = {}
		-- params.body = "username=" .. self._username .. "&password=" .. self._password
		-- self.networkID = network.request(url, "GET", self, params)
		local service = ReadFileContentsService:new()
		local jsonString = service:readFileContents(url, system.ResourceDirectory)
		self:networkRequest({phase="ended", response=jsonString})
	end

	function service:networkRequest(event)
		print("LoginService::networkRequest, phase:", event.phase)
		if event.phase == "ended" then
			if event.response then
				local jResponse = json.decode(event.response)
				if jResponse.success == true then
					print("success is true")
					self:dispatchEvent({name="onLoginSuccess"})
				else
					local errorMessage
					print("success is false")
					if jResponse.errorMessage then
						print("known error:", jResponse.errorMessage)
						errorMessage = jResponse.errorMessage
					else
						print("unknown error")
						errorMessage = "Unknown error."
					end
					self:dispatchEvent({name="onLoginError", errorMessage=errorMessage})
				end
			else
				print("unknown response")
				self:dispatchEvent({name="onLoginError", errorMessage="No response."})
			end
		end
	end

	function service:cancelOperations()
		if self.timerID then
			timer.cancel(self.timerID)
			self.timerID = nil
		end

		if self.networkID then
			network.cancel(self.networkID)
		end
	end

	return service
end

return LoginService