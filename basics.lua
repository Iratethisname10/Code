return function(tab)
	local basicsLeft, basicsRight = tab:AddColumn(), tab:AddColumn()

	local flySection = basicsLeft:AddSection('Flight')
	local speedSection = basicsLeft:AddSection('Speed')
	local characterSection = basicsLeft:AddSection('Character')

	local effectsSection = basicsRight:AddSection('Effects')

	-- basics
	--[[
		left:
		fly
		speed
		inf jump
		noclip
		no jump delay

		right:
		fullbring
		no blur
		no fog

	]]

	flySection:AddToggle({
		text = 'Enabled',
		flag = 'fly',
		callback = function(t)
			print('tog:', t)
		end
	}):AddBind({
		flag = 'fly bind',
		callback = function()
			library.options.fly:SetState(not library.flags.fly)
		end
	})
end
