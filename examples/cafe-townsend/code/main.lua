local function startThisMug()
	local function bootstrap()
		display.setStatusBar(display.HiddenStatusBar)
		_G.stage = display.getCurrentStage()
		local widget = require "widget"
		-- widget_theme_android_holo_dark
		-- widget_theme_android
		-- widget_theme_ios
		widget.setTheme('widget_theme_ios')
		local CafeTownsendApplication = require "CafeTownsendApplication"
		local app = CafeTownsendApplication:new()

		function showProps(o)
			print("-- showProps --")
			print("o: ", o)
			for key,value in pairs(o) do
				print("key: ", key, ", value: ", value);
			end
			print("-- end showProps --")
		end

	end

	bootstrap()
end

local function onError(e)
	return true
end
Runtime:addEventListener("unhandledError", onError)
timer.performWithDelay(100, startThisMug)