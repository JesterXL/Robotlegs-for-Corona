local function bootstrap()
	display.setStatusBar(display.HiddenStatusBar)
	_G.stage = display.getCurrentStage()

	require "CafeTownsendApplication"
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