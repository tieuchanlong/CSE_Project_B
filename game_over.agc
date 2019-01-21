game_over:
	stop = 0
	
	while (stop = 0)
		SetTextVisible(24, 1)
		SetTextVisible(25, 1)
		SetSpriteVisible(98, 1)
		
		if (GetRawKeyPressed(69) = 1) // press E
			chapter = -1
			start = 1
			SetTextVisible(24, 0)
			SetTextVisible(25, 0)
			SetSpriteVisible(98, 0)
			exit
		endif
		
		if (GetRawKeyPressed(82) = 1) // press R
			start = 0
			SetTextVisible(24, 0)
			SetTextVisible(25, 0)
			SetSpriteVisible(98, 0)
			exit
		endif
		
		Sync()
	endwhile
	
	end_game = 1
return


