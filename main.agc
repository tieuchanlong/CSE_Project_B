
// Project: CSE Project B 
// Author: Long Tieu
// Created: 2018-12-27

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "CSE Project B" )
SetWindowSize( 1920, 1280, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1920, 1280 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts

// import files
#include "level0.agc"
#include "level1.agc"
#include "level2.agc"
#include "level3.agc"
#include "start_screen.agc"

// Load image
LoadImage(1, "background.jpg")
LoadSound(1, "conversation.wav")
LoadSound(2, "title.wav")
LoadSound(3, "gameplay.wav")

// Create background
CreateImageColor(99, 255, 255, 255, 255)
CreateSprite(99, 1)
SetSpriteSize(99, GetVirtualWidth(), GetVirtualHeight())

CreateSprite(98, 1)
SetSpriteSize(98, GetVirtualWidth(), GetVirtualHeight())
SetSpriteColor(98, 0, 0, 0, 255)
SetSpriteVisible(98, 0)


// Create player sprite
CreateSprite(1, 99)
SetSpritePosition(1, 0, 0)
SetSpriteSize(1, 40, 40)
SetSpriteColor(1, 255, 255, 255, 255)
SetSpriteVisible(1, 0)

// initialize
global player_x = 0
global player_y = 0
global flip = 0
global press = 0
global block = 0
global block_x = 0
global block_y = 0
global ground = 4
global start = 1
global chapter = 0
global chap_select = 1
global end_game = 0

global enemy_x = 0
global enemy_y = 0
global speed = 0

physicson as integer[100]
color as integer [100, 5]

gosub init_start_screen

do
	PlaySound(2, 60, 1, 0)
	gosub start_menu
	
	if (chapter = 0)
		global stop = 0
		gosub begin_story
		gosub init_level0
		
		PlaySound(3, 100, 1, 0)
		
		for i = 16 to 20
			alpha = 255
			while (alpha > 0)
				SetTextVisible(i, 1)
				SetTextColor(i, 255, 255, 0, alpha)
				alpha = alpha - 2
				
				Sync()
			endwhile
		next i
		
		end_game = 0
		
		while (end_game = 0)
			gosub chapter0
			
			if (end_game = 1)
				StopSound(3)
				exit
			endif
			
			gosub create_blocks
			
			if (GetSpriteExists(99+block) = 1)
				gosub block_movements
			endif
			Sync()
		endwhile
	endif
	
	if (chapter = 1)
		stop = 0
		gosub level1_dialogues
		gosub init_level1
		
		PlaySound(3, 100, 1, 0)
		
		end_game = 0
		
		while (end_game = 0)
			gosub chapter1
			gosub create_blocks
			
			if (end_game = 1)
				StopSound(3)
				exit
			endif
			
			gosub ray_attack
			
			if (GetSpriteExists(99+block) = 1)
				gosub block_movements
			endif
			Sync()
		endwhile
	endif
	
	if (chapter = 2)
		stop = 0
		gosub level2_dialogues
		gosub init_level2
		
		PlaySound(3, 100, 1, 0)
		
		end_game = 0
		
		while(end_game = 0)
			gosub chapter2
			gosub create_blocks
			
			if (end_game = 1)
				StopSound(3)
				exit
			endif
			
			if (GetSpriteExists(99+block) = 1)
				gosub block_movements
			endif
			Sync()
		endwhile
	endif
	
	if (chapter = 3)
		stop = 0
		gosub level3_dialogues
	endif
	
    Sync()
loop

init_start_screen:
	// ---------------------- Load the Welcome Game Text ---------------- //
	CreateText(1, "UNRAVEL")
	SetTextSize(1, 200)
	SetTextColor(1, 255, 255, 0, 255)
	SetTextPosition(1, GetVirtualWidth()/2 - GetTextTotalWidth(1)/2, 240 - GetTextTotalHeight(1)/2) 
	 
	//------------------- Load the Press Text --------------------- //
	CreateText(2, "Play")
	SetTextSize(2, 100)
	SetTextColor(2, 255, 255, 0, 255)
	SetTextPosition(2, GetVirtualWidth()/2 - GetTextTotalWidth(2)/2, GetVirtualHeight()/2 - GetTextTotalHeight(2)/2 + 50)
	
	//---------- Load chapter selection texts ---------------- //
	CreateText(3, "CHAPTER SELECTION")
	SetTextSize(3, 100)
	SetTextColor(3, 255, 255, 0, 255)
	SetTextPosition(3, GetVirtualWidth()/2 - GetTextTotalWidth(3)/2, 50)
	
	CreateText(4, "Chapter 0")
	SetTextSize(4, 50)
	SetTextColor(4, 255, 255, 0, 255)
	SetTextPosition(4, GetVirtualWidth()/2 - GetTextTotalWidth(4)/2, 200)
	
	CreateText(5, "Chapter 1")
	SetTextSize(5, 50)
	SetTextColor(5, 255, 255, 0, 255)
	SetTextPosition(5, GetVirtualWidth()/2 - GetTextTotalWidth(5)/2, 400)
	
	CreateText(6, "Chapter 2")
	SetTextSize(6, 50)
	SetTextColor(6, 255, 255, 0, 255)
	SetTextPosition(6, GetVirtualWidth()/2 - GetTextTotalWidth(6)/2, 600)
	
	CreateText(7, "Chapter 3")
	SetTextSize(7, 50)
	SetTextColor(7, 255, 255, 0, 255)
	SetTextPosition(7, GetVirtualWidth()/2 - GetTextTotalWidth(7)/2, 800)
	
	CreateText(8, "Beep...Beep")
	SetTextSize(8, 50)
	SetTextColor(8, 255, 255, 255, 255)
	SetTextPosition(8, GetVirtualWidth()/2 - GetTextTotalWidth(8)/2, 200)
	SetTextVisible(8, 0)
	
	CreateText(9, "Beep...Beep")
	SetTextSize(9, 50)
	SetTextColor(9, 255, 255, 255, 255)
	SetTextPosition(9, GetVirtualWidth()/2 - GetTextTotalWidth(9)/2, 400)
	SetTextVisible(9, 0)
	
	CreateText(10, "Beep...Beep")
	SetTextSize(10, 50)
	SetTextColor(10, 255, 255, 255, 255)
	SetTextPosition(10, GetVirtualWidth()/2 - GetTextTotalWidth(10)/2, 600)
	SetTextVisible(10, 0)
	
	CreateText(11, "Beep...Beep")
	SetTextSize(11, 50)
	SetTextColor(11, 255, 255, 255, 255)
	SetTextPosition(11, GetVirtualWidth()/2 - GetTextTotalWidth(11)/2, 800)
	SetTextVisible(11, 0)
	
	CreateText(12, "Name: Unknown")
	SetTextSize(12, 50)
	SetTextColor(12, 255, 255, 255, 255)
	SetTextPosition(12, 100, 200)
	SetTextVisible(12, 0)
	
	CreateText(13, "Birth: Unknown")
	SetTextSize(13, 50)
	SetTextColor(13, 255, 255, 255, 255)
	SetTextPosition(13, 100, 300)
	SetTextVisible(13, 0)
	
	CreateText(14, "Brain capacity: Unregistered")
	SetTextSize(14, 50)
	SetTextColor(14, 255, 255, 255, 255)
	SetTextPosition(14, 100, 400)
	SetTextVisible(14, 0)
	
	CreateText(15, "Ready for experiment")
	SetTextSize(15, 50)
	SetTextColor(15, 255, 255, 255, 255)
	SetTextPosition(15, 100, 500)
	SetTextVisible(15, 0)
	
	
	// ------------- Instructions -------------- //
	CreateText(16, "Press WS to move left and right")
	SetTextSize(16, 40)
	SetTextPosition(16, GetVirtualWidth()/2 - GetTextTotalWidth(16)/2, 100)
	SetTextVisible(16, 0)
	
	CreateText(17, "Press E to create a block")
	SetTextSize(17, 40)
	SetTextPosition(17, GetVirtualWidth()/2 - GetTextTotalWidth(17)/2, 100)
	SetTextVisible(17, 0)
	
	CreateText(18, "Press arrow keys to move and press C to drop the box")
	SetTextSize(18, 40)
	SetTextPosition(18, GetVirtualWidth()/2 - GetTextTotalWidth(18)/2, 100)
	SetTextVisible(18, 0)
	
	CreateText(19, "Click the right mouse to perform the telportation on the block")
	SetTextSize(19, 40)
	SetTextPosition(19, GetVirtualWidth()/2 - GetTextTotalWidth(19)/2, 100)
	SetTextVisible(19, 0)
	
	CreateText(20, "Find your way to escape to the green door")
	SetTextSize(20, 40)
	SetTextPosition(20, GetVirtualWidth()/2 - GetTextTotalWidth(20)/2, 100)
	SetTextVisible(20, 0)
	
	CreateText(21, "Let's try the first puzzle!")
	SetTextSize(21, 40)
	SetTextPosition(21, GetVirtualWidth()/2 - GetTextTotalWidth(21)/2, 100)
	SetTextVisible(21, 0)
	
	CreateText(22, "Press WASD to move around and move to the red spot to debug. Remember to dodge the enemy.")
	SetTextSize(22, 40)
	SetTextPosition(22, GetVirtualWidth()/2 - GetTextTotalWidth(22)/2, 100)
	SetTextVisible(22, 0)
	
	
	// ----------- Chapter 0 dialogues -------------- //
	
	CreateText(26, "Where am I?")
	SetTextSize(26, 40)
	SetTextPosition(26, 100, 60)
	color[26, 1] = 255
	color[26, 2] = 255
	color[26, 3] = 255
	SetTextVisible(26, 0)
	
	CreateText(27, "Why do I see nothing? ")
	SetTextSize(27, 40)
	SetTextPosition(27, 100, 120)
	color[27, 1] = 255
	color[27, 2] = 255
	color[27, 3] = 255
	SetTextVisible(27, 0)
	
	CreateText(28, "Hello")
	SetTextSize(28, 40)
	SetTextPosition(28, 100, 180)
	color[28, 1] = 0
	color[28, 2] = 0
	color[28, 3] = 255
	SetTextVisible(28, 0)
	
	CreateText(29, "Woo. Who are you?")
	SetTextSize(29, 40)
	SetTextPosition(29, 100, 240)
	color[29, 1] = 255
	color[29, 2] = 255
	color[29, 3] = 255
	SetTextVisible(29, 0)
	
	CreateText(30, "Well, who are you first?")
	SetTextSize(30, 40)
	SetTextPosition(30, 100, 300)
	color[30, 1] = 0
	color[30, 2] = 0
	color[30, 3] = 255
	SetTextVisible(30, 0)
	
	CreateText(31, "I am uh... I...")
	SetTextSize(31, 40)
	SetTextPosition(31, 100, 360)
	color[31, 1] = 255
	color[31, 2] = 255
	color[31, 3] = 255
	SetTextVisible(31, 0)
	
	CreateText(32, "I don't know")
	SetTextSize(32, 40)
	SetTextPosition(32, 100, 420)
	color[32, 1] = 255
	color[32, 2] = 255
	color[32, 3] = 255
	SetTextVisible(32, 0)
	
	CreateText(33, "Seems like the experiment is effective.")
	SetTextSize(33, 40)
	SetTextPosition(33, 100, 480)
	color[33, 1] = 0
	color[33, 2] = 0
	color[33, 3] = 255
	SetTextVisible(33, 0)
	
	CreateText(34, "What experiment? Hey!")
	SetTextSize(34, 40)
	SetTextPosition(34, 100, 540)
	color[34, 1] = 255
	color[34, 2] = 255
	color[34, 3] = 255
	SetTextVisible(34, 0)
	
	CreateText(35, "Bastards! What ui tre tme?")
	SetTextSize(35, 40)
	SetTextPosition(35, 100, 600)
	color[35, 1] = 255
	color[35, 2] = 255
	color[35, 3] = 255
	SetTextVisible(35, 0)
	
	CreateText(36, "...")
	SetTextSize(36, 40)
	SetTextPosition(36, 100, 660)
	color[36, 1] = 255
	color[36, 2] = 255
	color[36, 3] = 255
	SetTextVisible(36, 0)
	
	CreateText(37, "...")
	SetTextSize(37, 40)
	SetTextPosition(37, 100, 720)
	color[37, 1] = 255
	color[37, 2] = 255
	color[37, 3] = 255
	SetTextVisible(37, 0)
	
	CreateText(38, "...")
	SetTextSize(38, 40)
	SetTextPosition(38, 100, 780)
	color[38, 1] = 255
	color[38, 2] = 255
	color[38, 3] = 255
	SetTextVisible(38, 0)
	
	CreateText(39, "He is silenced. Give him some doses and test will begin.")
	SetTextSize(39, 40)
	SetTextPosition(39, 100, 840)
	color[39, 1] = 0
	color[39, 2] = 0
	color[39, 3] = 255
	SetTextVisible(39, 0)
	
	CreateText(40, "                                                                    									Conversation ends.")
	SetTextSize(40, 40)
	SetTextPosition(40, 100, 1100)
	color[40, 1] = 255
	color[40, 2] = 255
	color[40, 3] = 255
	SetTextVisible(40, 0)
	
	
	// ------------------------ Chapter 1 dialogues ------------------------- //
	CreateText(41, "The process didn't completely eradicate your rationality.")
	SetTextSize(41, 40)
	SetTextPosition(41, 100, 100)
	color[41, 1] = 0
	color[41, 2] = 0
	color[41, 3] = 255
	SetTextVisible(41, 0)
	
	CreateText(42, "Interesting. Interesting!")
	SetTextSize(42, 40)
	SetTextPosition(42, 100, 160)
	color[42, 1] = 0
	color[42, 2] = 0
	color[42, 3] = 255
	SetTextVisible(42, 0)
	
	CreateText(43, "...")
	SetTextSize(43, 40)
	SetTextPosition(43, 100, 220)
	color[43, 1] = 255
	color[43, 2] = 255
	color[43, 3] = 255
	SetTextVisible(43, 0)
	
	CreateText(44, "You want another game? You look eager enough.")
	SetTextSize(44, 40)
	SetTextPosition(44, 100, 280)
	color[44, 1] = 0
	color[44, 2] = 0
	color[44, 3] = 255
	SetTextVisible(44, 0)
	
	CreateText(45, "...")
	SetTextSize(45, 40)
	SetTextPosition(45, 100, 340)
	color[45, 1] = 255
	color[45, 2] = 255
	color[45, 3] = 255
	SetTextVisible(45, 0)
	
	CreateText(46, "Sorry for this inconvenience. But, uhm...")
	SetTextSize(46, 40)
	SetTextPosition(46, 100, 400)
	color[46, 1] = 0
	color[46, 2] = 0
	color[46, 3] = 255
	SetTextVisible(46, 0)
	
	CreateText(47, "Small price to pay for humanity.")
	SetTextSize(47, 40)
	SetTextPosition(47, 100, 460)
	color[47, 1] = 0
	color[47, 2] = 0
	color[47, 3] = 255
	SetTextVisible(47, 0)
	
	CreateText(48, "...")
	SetTextSize(48, 40)
	SetTextPosition(48, 100, 520)
	color[48, 1] = 255
	color[48, 2] = 255
	color[48, 3] = 255
	SetTextVisible(48, 0)
	
	CreateText(49, "How's the interaction with your puppet?")
	SetTextSize(49, 40)
	SetTextPosition(49, 100, 580)
	color[49, 1] = 255
	color[49, 2] = 0
	color[49, 3] = 0
	SetTextVisible(49, 0)
	
	CreateText(50, "Splendid. Positive responses. Better than other candidates.")
	SetTextSize(50, 40)
	SetTextPosition(50, 100, 640)
	color[50, 1] = 0
	color[50, 2] = 0
	color[50, 3] = 255
	SetTextVisible(50, 0)
	
	CreateText(51, "Really. Cuz there ain't not much time for chit chat. So do it fast.")
	SetTextSize(51, 40)
	SetTextPosition(51, 100, 700)
	color[51, 1] = 255
	color[51, 2] = 0
	color[51, 3] = 0
	SetTextVisible(51, 0)
	
	CreateText(52, "Yes, sir. I will finish this by the end of the week.")
	SetTextSize(52, 40)
	SetTextPosition(52, 100, 760)
	color[52, 1] = 0
	color[52, 2] = 0
	color[52, 3] = 255
	SetTextVisible(52, 0)
	
	CreateText(53, "Then get to it. I need the result by the end of this week.")
	SetTextSize(53, 40)
	SetTextPosition(53, 100, 820)
	color[53, 1] = 255
	color[53, 2] = 0
	color[53, 3] = 0
	SetTextVisible(53, 0)
	
	CreateText(54, "...")
	SetTextSize(54, 40)
	SetTextPosition(54, 100, 860)
	color[54, 1] = 255
	color[54, 2] = 255
	color[54, 3] = 255
	SetTextVisible(54, 0)
	
	CreateText(55, "                                          																	Conversation ends.")
	SetTextSize(55, 40)
	SetTextPosition(55, 100, 920)
	color[55, 1] = 255
	color[55, 2] = 255
	color[55, 3] = 255
	SetTextVisible(55, 0)
	
	
	// ------------------------ Chapter 2 dialogues ------------------------- //
	CreateText(56, "...")
	SetTextSize(56, 40)
	SetTextPosition(56, 100, 100)
	color[56, 1] = 255
	color[56, 2] = 255
	color[56, 3] = 255
	SetTextVisible(56, 0)
	
	CreateText(57, "A hard challenge. For a kind like you.")
	SetTextSize(57, 40)
	SetTextPosition(57, 100, 160)
	color[57, 1] = 0
	color[57, 2] = 0
	color[57, 3] = 255
	SetTextVisible(57, 0)
	
	CreateText(58, "...")
	SetTextSize(58, 40)
	SetTextPosition(58, 100, 220)
	color[58, 1] = 255
	color[58, 2] = 255
	color[58, 3] = 255
	SetTextVisible(58, 0)
	
	CreateText(59, "But you passed. You are a one of a kind.")
	SetTextSize(59, 40)
	SetTextPosition(59, 100, 280)
	color[59, 1] = 0
	color[59, 2] = 0
	color[59, 3] = 255
	SetTextVisible(59, 0)
	
	CreateText(60, "...")
	SetTextSize(60, 40)
	SetTextPosition(60, 100, 340)
	color[60, 1] = 255
	color[60, 2] = 255
	color[60, 3] = 255
	SetTextVisible(60, 0)
	
	CreateText(61, "Anyone who's in this would have fried their mind already.")
	SetTextSize(61, 40)
	SetTextPosition(61, 100, 400)
	color[61, 1] = 0
	color[61, 2] = 0
	color[61, 3] = 255
	SetTextVisible(61, 0)
	
	CreateText(62, "...")
	SetTextSize(62, 40)
	SetTextPosition(62, 100, 460)
	color[62, 1] = 255
	color[62, 2] = 255
	color[62, 3] = 255
	SetTextVisible(62, 0)
	
	CreateText(63, "Species 4567 died. Expermiment terminated.")
	SetTextSize(63, 40)
	SetTextPosition(63, 100, 520)
	color[63, 1] = 0
	color[63, 2] = 255
	color[63, 3] = 0
	SetTextVisible(63, 0)
	
	CreateText(64, "Turn on the gass chamber. Recover their brain.")
	SetTextSize(64, 40)
	SetTextPosition(64, 100, 580)
	color[64, 1] = 0
	color[64, 2] = 0
	color[64, 3] = 255
	SetTextVisible(64, 0)
	
	CreateText(65, "You see. They're all dead after five minutes. Pathetic!")
	SetTextSize(65, 40)
	SetTextPosition(65, 100, 640)
	color[65, 1] = 0
	color[65, 2] = 0
	color[65, 3] = 255
	SetTextVisible(65, 0)
	
	CreateText(66, "...")
	SetTextSize(66, 40)
	SetTextPosition(66, 100, 700)
	color[66, 1] = 255
	color[66, 2] = 255
	color[66, 3] = 255
	SetTextVisible(66, 0)
	
	CreateText(67, "Well. Let's get you some easier test to chill, eh.")
	SetTextSize(67, 40)
	SetTextPosition(67, 100, 760)
	color[67, 1] = 0
	color[67, 2] = 0
	color[67, 3] = 255
	SetTextVisible(67, 0)
	
	CreateText(68, "...")
	SetTextSize(68, 40)
	SetTextPosition(68, 100, 820)
	color[68, 1] = 255
	color[68, 2] = 255
	color[68, 3] = 255
	SetTextVisible(68, 0)
	
	CreateText(69, "You will surely love it.")
	SetTextSize(69, 40)
	SetTextPosition(69, 100, 880)
	color[69, 1] = 0
	color[69, 2] = 0
	color[69, 3] = 255
	SetTextVisible(69, 0)
	
	CreateText(70, "                                          												Conversation ends.")
	SetTextSize(70, 40)
	SetTextPosition(70, 100, 940)
	color[70, 1] = 255
	color[70, 2] = 255
	color[70, 3] = 255
	SetTextVisible(70, 0)
	
	
	// ----------------------- Chapter 3 dialogues --------------- //
	CreateText(71, "Nice. Some small issues in the system you also fixed it.")
	SetTextSize(71, 40)
	SetTextPosition(71, 100, 100)
	color[71, 1] = 0
	color[71, 2] = 0
	color[71, 3] = 255
	SetTextVisible(71, 0)
	
	CreateText(72, "...")
	SetTextSize(72, 40)
	SetTextPosition(72, 100, 160)
	color[72, 1] = 255
	color[72, 2] = 255
	color[72, 3] = 255
	SetTextVisible(72, 0)
	
	CreateText(73, "Were you a coder?")
	SetTextSize(73, 40)
	SetTextPosition(73, 100, 220)
	color[73, 1] = 0
	color[73, 2] = 0
	color[73, 3] = 255
	SetTextVisible(73, 0)
	
	CreateText(74, "Hgjdsfb dfjnclsor hdfb.")
	SetTextSize(74, 40)
	SetTextPosition(74, 100, 280)
	color[74, 1] = 255
	color[74, 2] = 255
	color[74, 3] = 255
	SetTextVisible(74, 0)
	
	CreateText(75, "Wait, you can talk?")
	SetTextSize(75, 40)
	SetTextPosition(75, 100, 340)
	color[75, 1] = 0
	color[75, 2] = 20
	color[75, 3] = 255
	SetTextVisible(75, 0)
	
	CreateText(76, "Fhgdu!")
	SetTextSize(76, 40)
	SetTextPosition(76, 100, 400)
	color[76, 1] = 255
	color[76, 2] = 255
	color[76, 3] = 255
	SetTextVisible(76, 0)
	
	CreateText(77, "Damn it, it should have erased your thoughts.")
	SetTextSize(77, 40)
	SetTextPosition(77, 100, 460)
	color[77, 1] = 0
	color[77, 2] = 0
	color[77, 3] = 255
	SetTextVisible(77, 0)
	
	CreateText(78, "Ilk Kull ut! furk!")
	SetTextSize(78, 40)
	SetTextPosition(78, 100, 520)
	color[78, 1] = 255
	color[78, 2] = 255
	color[78, 3] = 255
	SetTextVisible(78, 0)
	
	CreateText(79, "God damn it!")
	SetTextSize(79, 40)
	SetTextPosition(79, 100, 580)
	color[79, 1] = 0
	color[79, 2] = 0
	color[79, 3] = 255
	SetTextVisible(79, 0)
	
	CreateText(80, "Lot mii ourt. Lerd mir fghdsj!")
	SetTextSize(80, 40)
	SetTextPosition(80, 100, 640)
	color[80, 1] = 255
	color[80, 2] = 255
	color[80, 3] = 255
	SetTextVisible(80, 0)
	
	CreateText(81, "Your case is very interesting! You suprise me!")
	SetTextSize(81, 40)
	SetTextPosition(81, 100, 700)
	color[81, 1] = 0
	color[81, 2] = 0
	color[81, 3] = 255
	SetTextVisible(81, 0)
	
	CreateText(82, "...")
	SetTextSize(82, 40)
	SetTextPosition(82, 100, 760)
	color[82, 1] = 255
	color[82, 2] = 255
	color[82, 3] = 255
	SetTextVisible(82, 0)
	
	CreateText(83, "Then you will love my big gun. Some thing to overdoze you little bit!")
	SetTextSize(83, 40)
	SetTextPosition(83, 100, 820)
	color[83, 1] = 0
	color[83, 2] = 0
	color[83, 3] = 255
	SetTextVisible(83, 0)
	
	CreateText(84, "...")
	SetTextSize(84, 40)
	SetTextPosition(84, 100, 880)
	color[84, 1] = 255
	color[84, 2] = 255
	color[84, 3] = 255
	SetTextVisible(84, 0)
	
	CreateText(85, "                                          														Conversation ends.")
	SetTextSize(85, 40)
	SetTextPosition(85, 100, 940)
	color[85, 1] = 255
	color[85, 2] = 255
	color[85, 3] = 255
	SetTextVisible(85, 0)
	
	
	// intro title
	CreateText(86, "Chapter 0")
	SetTextSize(86, 100)
	SetTextColor(86, 255, 255, 255, 255)
	SetTextPosition(86, GetVirtualWidth()/2 - GetTextTotalWidth(86)/2, GetVirtualHeight()/2 - GetTextTotalHeight(86)/2)
	SetTextVisible(86, 0)
	
	CreateText(87, "Chapter 1")
	SetTextSize(87, 100)
	SetTextColor(87, 255, 255, 255, 255)
	SetTextPosition(87, GetVirtualWidth()/2 - GetTextTotalWidth(87)/2, GetVirtualHeight()/2 - GetTextTotalHeight(87)/2)
	SetTextVisible(87, 0)
	
	CreateText(88, "Chapter 2")
	SetTextSize(88, 100)
	SetTextColor(88, 255, 255, 255, 255)
	SetTextPosition(88, GetVirtualWidth()/2 - GetTextTotalWidth(88)/2, GetVirtualHeight()/2 - GetTextTotalHeight(88)/2)
	SetTextVisible(88, 0)
	
	CreateText(89, "To be continued")
	SetTextSize(89, 100)
	SetTextColor(89, 255, 255, 255, 255)
	SetTextPosition(89, GetVirtualWidth()/2 - GetTextTotalWidth(89)/2, GetVirtualHeight()/2 - GetTextTotalHeight(89)/2)
	SetTextVisible(89, 0)
	
	 
	//---------------------- Load the Game over Text ----------------------//
	CreateText(24, "GAME OVER!")
	SetTextSize(24, 200)
	SetTextColor(24, 255, 255, 0, 255)
	SetTextPosition(24, GetVirtualWidth()/2 - GetTextTotalWidth(24)/2, 240 - GetTextTotalHeight(24)/2)
	SetTextVisible(24, 0)
	 
	// ----------------------------- Load the replay text ------------------ //
	CreateText(25, "Press R to replay the game or press E to end the game")
	SetTextSize(25, 70)
	SetTextColor(25, 255, 255, 0, 255)
	SetTextPosition(25, GetVirtualWidth()/2 - GetTextTotalWidth(25)/2, GetVirtualHeight()/2 - GetTextTotalHeight(25)/2 + 50)
	SetTextVisible(25, 0) 
return

init_level0:
	// initialize
	player_x = 0
	player_y = 0
	flip = 0
	pressed = 0
	block = 0
	ground = 2
	global alpha = 255
	
	SetSpriteVisible(1, 1)
	SetSpritePhysicsOn(1, 3)
	
	CreateSprite(2, 99)  // the ground
	SetSpritePosition(2, 0, GetVirtualHeight() - 50)
	SetSpriteSize(2, GetVirtualWidth(), 50)
	SetSpriteColor(2, 241, 143, 239, 255)
	
	SetSpritePosition(1, 0, GetSpriteY(2) - GetSpriteHeight(1))

	CreateSprite(3, 99)  // the block
	SetSpriteSize(3, 200, 50)
	SetSpritePosition(3, GetVirtualWidth() - 200, GetSpriteY(2) - 300)
	SetSpriteColor(3, 13, 0, 0, 255)

	CreateSprite(4, 99) // Sprite door for next level
	SetSpriteSize(4, 50, 100)
	SetSpritePosition(4, GetVirtualWidth() - 150, GetSpriteY(3) - GetSpriteHeight(4))
	SetSpriteColor(4, 25, 60, 32, 255)

	CreateSprite(5, 99)  // the ground collision box
	SetSpritePosition(5, 0, GetVirtualHeight() - 54)
	SetSpriteSize(5, GetVirtualWidth(), 50)
	SetSpriteColor(5, 0, 0, 0, 0)
return

init_level1:
	ground = 4
	block = 0
	alpha = 255
	color_change = 0
	
	SetSpriteVisible(1, 1)
	SetSpritePhysicsOn(1, 3)
	
	CreateSprite(2, 99) //ground 1
	SetSpriteSize(2, 200, 50)
	SetSpritePosition(2, 0, GetVirtualHeight() - 400)
	SetSpriteColor(2, 0, 0, 0, 255)
	
	CreateSprite(3, 99) //ground 2
	SetSpriteSize(3, 200, 50)
	SetSpritePosition(3, 800, GetVirtualHeight() - 200)
	SetSpriteColor(3, 0, 0, 0, 255)
	
	CreateSprite(4, 99)  //ground 3
	SetSpriteSize(4, 200, 50)
	SetSpritePosition(4, GetVirtualWidth() - GetSpriteWidth(4), GetVirtualHeight() - 400)
	SetSpriteColor(4, 0, 0, 0, 255)
	
	CreateSprite(5, 99) //ground 4
	SetSpriteSize(5, 200, 50)
	SetSpritePosition(5, GetVirtualWidth() - GetSpriteWidth(5), GetVirtualHeight() - 800)
	SetSpriteColor(5, 0, 0, 0, 255)
	
	CreateSprite(6, 99)  // exit door
	SetSpriteSize(6, 50, 100)
	SetSpritePosition(6, GetSpriteX(5) + 100, GetSpriteY(5) - GetSpriteHeight(6))
	SetSpriteColor(6, 25, 60, 32, 255)
	SetSpriteVisible(6, 0)
	
	CreateSprite(7, 99)  // button 1
	SetSpriteSize(7, 20, 20)
	SetSpritePosition(7, GetSpriteX(2) + 100, GetSpriteY(2) - GetSpriteHeight(7))
	SetSpriteColor(7, 250, 18, 82, 255)
	
	CreateSprite(8, 99)  // button 2
	SetSpriteSize(8, 20, 20)
	SetSpritePosition(8, GetSpriteX(3) + 100, GetSpriteY(3) - GetSpriteHeight(8))
	SetSpriteColor(8, 250, 18, 82, 255)
	
	CreateSprite(9, 99)  // button 3
	SetSpriteSize(9, 20, 20)
	SetSpritePosition(9, GetSpriteX(4) + 100, GetSpriteY(4) - GetSpriteHeight(9))
	SetSpriteColor(9, 250, 18, 82, 255)
	
	CreateSprite(10, 99) //laser light 1
	SetSpriteSize(10, 20, GetVirtualHeight())
	SetSpritePosition(10, GetSpriteX(2) + GetSpriteWidth(2) + 100, 0)
	SetSpriteColor(10, 0, 255, 0, 255)
	
	CreateSprite(11, 99) //laser light 2
	SetSpriteSize(11, 20, GetVirtualHeight())
	SetSpritePosition(11, GetSpriteX(4) - 100, 0)
	SetSpriteColor(11, 0, 255, 0, 255)
	
	SetSpritePosition(1, GetSpriteX(3) + 50, GetSpriteY(3) - GetSpriteHeight(1))

	
	// -- Create the wall protecting the button
return

init_level2:
	ground = 1
	block = 0
	alpha = 255
	color_change = 0
	enemy_x = 0
	enemy_y = 0
	speed = 5
	direction_x = 1
	direction_y = 1
	global count = 0
	global gameover = 0
	
	SetSpriteVisible(1, 1)
	SetSpritePhysicsOn(1, 3)
	
	CreateSprite(2, 99) // create first ground for player to stand
	SetSpriteSize(2, GetVirtualWidth(), 50)
	SetSpritePosition(2, 0, GetVirtualHeight() - GetSpriteHeight(2))
	SetSpriteColor(2, 0, 0, 0, 255)
	
	SetSpritePosition(1, 0, GetSpriteY(2) - GetSpriteHeight(1))
	
	CreateSprite(3, 99) // exit door
	SetSpriteSize(3, 40, 100)
	SetSpritePosition(3, 500, GetSpriteY(2) - GetSpriteHeight(3))
	SetSpriteColor(3, 25, 60, 32, 255)
	
	CreateSprite(4, 99) // debug place
	SetSpriteSize(4, 60, 60)
	SetSpritePosition(4, 0, 0)
	SetSpriteColor(4, 0, 255, 0, 255)
	SetSpriteVisible(4, 0)
	
	CreateSprite(5, 99) // enemy
	SetSpriteSize(5, 100, 100)
	SetSpritePosition(5, 0, 0)
	SetSpriteColor(5, 255, 0, 0, 255)
	SetSpriteVisible(5, 0)
	
return

block_movements:
	if (press = 1)
		if GetRawKeyState(37) = 1
			block_x = block_x - 20
		endif
	 
		if block_x < 0
			block_x = 0
		endif
	 
		if GetRawKeyState(39) = 1
			block_x = block_x + 20
		endif
	 
		if block_x > GetVirtualWidth() - GetSpriteWidth(99+block)
			block_x = GetVirtualWidth() - GetSpriteWidth(99+block)
		endif
	 
		if GetRawKeyState(38) = 1
			block_y = block_y - 20
			//SetSpriteAngle(1, 270)
		endif
	 
		if block_y < 0
			block_y = 0
		endif
	 
		if GetRawKeyState(40) = 1
			block_y = block_y + 20
			//SetSpriteAngle(1, 0)
		endif
	 
		if block_y > GetVirtualHeight() - GetSpriteHeight(99+block)
			block_y = GetVirtualHeight() - GetSpriteHeight(99+block)
		endif
		SetSpritePosition(99+block, block_x, block_y)
	endif
	
	for i = 1 to block
		if GetSpriteExists(99+i) = 1 and physicson[i] = 1
			for j = 1 to block
				if (GetSpriteExists(99+j) = 1)
					if i <> j and GetSpriteCollision(99+i, 99+j) = 1  // collide with the ground collision box
						SetSpritePhysicsVelocity(99+i, 0, 0)
						SetSpritePhysicsOff(99+i)
						physicson[i] = 0
					else
						SetSpritePhysicsVelocity(99+i, 0, 400)
					endif
				endif
			next j
			
			for j = 1 to ground
				if i <> j and GetSpriteCollision(99+i, j+1) = 1  // collide with the ground collision box
					SetSpritePhysicsVelocity(99+i, 0, 0)
					SetSpritePhysicsOff(99+i)
					physicson[i] = 0
				else
					SetSpritePhysicsVelocity(99+i, 0, 400)
				endif
			next j
		endif
	next i
return

create_blocks:
	if (GetRawKeyState(69) = 1 and press = 0) //press e will create blocks
		block = block + 1
		CreateSprite(99+block, 99)
		SetSpriteSize(99+block, 50, 50)
		SetSpriteColor(99+block, 43, 208, 199, 255)
		press = 1
		if (flip = 0)
			block_x = GetSpriteX(1) - GetSpriteWidth(99+block) - 10
			block_y = GetSpriteY(1) - GetSpriteHeight(99+block) + GetSpriteHeight(1)
		else
			block_x = GetSpriteX(1) + GetSpriteWidth(99+block) + 10
			block_y = GetSpriteY(1) - GetSpriteHeight(99+block) + GetSpriteHeight(1)
		endif
		SetSpritePosition(99+block, block_x, block_y)
	endif
	
	if (GetRawKeyState(67) = 1 and press = 1) //press c will make the block fall
		press = 0
		SetSpritePhysicsOn(99+block, 3)
		physicson[block] = 1

	endif
	
	if (GetPointerPressed() = 1 and GetSpriteExists(99+block) = 1) // if click mouse will teleport to the block you just built
		SetSpritePosition(1, GetSpriteX(99+block), GetSPriteY(99+block) - GetSpriteHeight(1))
	endif
return
