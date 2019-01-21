start_menu:
	while (start = 1)
		SetTextVisible(1, 1)
		SetTextVisible(2, 1)
		
		for i = 3 to 7 
			SetTextVisible(i, 0)
		next i
 
		if GetPointerPressed() = 1 
			click_x = GetPointerX()
			click_y = GetPointerY()
 
			if (click_x >= GetTextX(2) and click_x <= GetTextX(2) + GetTextTotalWidth(2) and click_y >= GetTextY(2) and click_y <= GetTextY(2) + GetTextTotalHeight(2))
 
				start = 0
				SetTextVisible(1,0)
				SetTextVisible(2,0)
				gosub chapter_select
			endif
 
		endif
 
		Sync()
	endwhile
 
return

chapter_select:
	chap_select = 1
	
	while (chap_select = 1)
		for i = 3 to 7 
			SetTextVisible(i, 1)
		next i
		
		if (GetPointerPressed() = 1)
			if (GetPointerX() >= GetTextX(4) and GetPointerX() <= GetTextX(4) + GetTextTotalWidth(4) and GetPointerY() >= GetTextY(4) and GetPointerY() <= GetTextY(4) + GetTextTotalHeight(4))
				for i = 3 to 7 
					SetTextVisible(i, 0)
				next i
				
				chapter = 0
				chap_select = 0
				StopSound(2)
			endif
			
			if (GetPointerX() >= GetTextX(5) and GetPointerX() <= GetTextX(5) + GetTextTotalWidth(5) and GetPointerY() >= GetTextY(5) and GetPointerY() <= GetTextY(5) + GetTextTotalHeight(5))
				for i = 3 to 7 
					SetTextVisible(i, 0)
				next i
				
				chapter = 1
				chap_select = 0
				StopSound(2)
			endif
			
			if (GetPointerX() >= GetTextX(6) and GetPointerX() <= GetTextX(6) + GetTextTotalWidth(6) and GetPointerY() >= GetTextY(6) and GetPointerY() <= GetTextY(6) + GetTextTotalHeight(6))
				for i = 3 to 7 
					SetTextVisible(i, 0)
				next i
				
				chapter = 2
				chap_select = 0
				StopSound(2)
			endif
			
			if (GetPointerX() >= GetTextX(7) and GetPointerX() <= GetTextX(7) + GetTextTotalWidth(7) and GetPointerY() >= GetTextY(7) and GetPointerY() <= GetTextY(7) + GetTextTotalHeight(7))
				for i = 3 to 7 
					SetTextVisible(i, 0)
				next i
				
				chapter = 3
				chap_select = 0
				StopSound(2)
			endif

		endif
	
		Sync()
	endwhile
		
return
