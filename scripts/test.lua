local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Iratethisname10/Code/main/aztup-ui/ui-lib.lua'))()

local a = library:AddTab('test Tab')
local a1, a2 = a:AddColumn(), a:AddColumn()

local v = a1:AddSection('Test Section')

v:AddToggle({text = 'Test Button'})

library:Init()
