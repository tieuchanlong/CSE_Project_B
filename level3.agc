level3_dialogues:
	while (stop = 0)
		
		SetSpriteVisible(98, 1)
		
		PlaySound(1, 100, 1, 0)
		
		// conversation
		for i = 71 to 85
			alpha = 0
			while (alpha < 255)
				SetTextVisible(i, 1)
				SetTextColor(i, color[i, 1], color[i, 2], color[i, 3], alpha)
				alpha = alpha + 2
				
				Sync()
			endwhile
		next i
		
		for i = 71 to 85
			SetTextVisible(i, 0)
		next i
		
		for i = 26 to 40
			SetTextVisible(i, 0)
		next i
		
		alpha = 0
		while (alpha < 255)
			SetTextVisible(89, 1)
			SetTextColor(89, 255, 255, 255, alpha)
			alpha = alpha + 2
			
			Sync()
		endwhile
		
		alpha = 255
		while (alpha > 0)
			SetTextVisible(89, 1)
			SetTextColor(89, 255, 255, 255, alpha)
			alpha = alpha - 2
			
			Sync()
		endwhile
		
		SetSpriteVisible(98, 0)
		StopSound(1)
		
		exit
		Sync()
	endwhile
	
	end_game = 1
return

