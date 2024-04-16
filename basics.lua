return function(tab)
	local basicsLeft, basicsRight = tab:AddColumn(), tab:AddColumn()

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

	basicsLeft:AddToggle({
		text = 'Text',
		callback = function(t)
			print('tog:', t)
		end
	})
end