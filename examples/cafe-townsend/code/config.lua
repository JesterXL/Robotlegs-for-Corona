application =
{
        content =
        {
                width = 640,
                height = 960,
                scale = "zoomEven",
		xAlign = "left",
		yAlign = "top",
		fps = 60,
		antialias = false,
        },
}

-- if system.getInfo("platformName") == "Android" then
--         application =
--         {
--                 content =
--                 {
--                         --zoom
--                         width = 640,
--                         height = 960,
--                         scale = "letterbox"
--                 },
--         }
-- elseif system.getInfo("model") ~= "iPad" then   

--         application =
--         {
--                 content =
--                 {
--                         --zoom
--                         width = 640,
--                         height = 960,
--                         scale = "zoomEven"
--                 },
--         }       
-- end