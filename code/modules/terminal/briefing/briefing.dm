

/obj/structure/terminal/briefing
	name = "briefing display"
	desc = "This is a master item. It should not be placed anywhere in the game world."
	desc_lore = "If you have the time, please consider reporting this as a bug."
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "master"
	terminal_id = "briefing"
	var/terminal_range = 20
	terminal_window_size = "500x500"
	terminal_line_length = 44
	terminal_line_height = 13

/obj/structure/terminal/briefing/kill_window(reset = 1)
	for (var/mob/mobs in world)
		mobs << browse(null, "window=[terminal_id]")
		if(reset == 1) reset_buffer()

/obj/structure/terminal/briefing/terminal_display() // Display loop. HTML encodes (which incidentally should also prevent a lot of HTML shenanigans since it escapes characters) and displays current buffer. Please don't laugh at my placeholder HTML -_- , in normal circumstances should not need edits unless you want to change the style for an individual terminal.
	trim_buffer()
	var/terminal_output = ("<p>" + jointext((terminal_buffer), "</p><p>") + "/<p>")
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	}
	#terminal_text {
	font-family: 'Courier New',
	cursive, sans-serif;
	color: #1bdd4b;
	text-align: left;
	padding: 0em 1em;
	}
	</style>
	</head>
	<body>
	<div id="terminal_text">
	<p>
	[terminal_output]
	</p>
	</div>
	</body>
	"}
	for (var/mob/mobs_in_range in view(terminal_range, src))
		mobs_in_range << browse(terminal_html,"window=[terminal_id];display=1;size=[terminal_window_size];border=5px;can_close=1;can_resize=0;can_minimize=0;titlebar=1")
		onclose(mobs_in_range, "[terminal_id]")

/obj/structure/terminal/briefing/attack_hand(mob/user)
	to_chat(usr, SPAN_INFO("This monitor is activated remotely, as long as you are in range and it is active, its contents will be displayed to you. There is no escape."))
	return

/obj/structure/terminal/briefing/proc/display_briefing()
	var/obj/structure/machinery/light/marker/admin/marker = new(get_turf(src))
	marker.name = "Cassandra"
	marker.langchat_color = "#bb2356"
	marker.talkas("Hello. This is an example briefing. A proof of concept if you will.")
	marker.emoteas("laughs audibly")
	emoteas("Starts to display shit. It will open a window for everyone in range. There is no escape.")
	terminal_buffer += "<br><br><br>"
	terminal_buffer += "<center><b>UACM 2ND LOGISTICS</b></center>"
	terminal_display()
	marker.talkas("As the briefing continues, the display may or may not update. If someone closes it, it will reopen the next time something changes, as long as you stay in view and in range.")
	marker.talkas("It should also respect its positon. I guess we'll see.")
	terminal_header += "<b><center>UACM 2ND LOGISTICS</b><br>TEST CREW STG</center>"
	terminal_header += "<hr>"
	terminal_reserved_lines = 2
	reset_buffer()
	terminal_display_line("Objectives:", 0, 1)
	terminal_display_line("1. This is the first objective")
	marker.talkas("As I keep talking and new objectives are added, the display is refreshed.")
	marker.talkas("Again, as long as you are in range, in view of the display.")
	terminal_display_line("2. This is the second objective")
	marker.talkas("Then, when the briefing is over, it can cycle to some suumary. Or not. I havent decided. Anyway.")
	terminal_header = null
	terminal_header = list()
	reset_buffer()
	terminal_buffer += "<br><br><br>"
	terminal_buffer += "<center><b>GOOD LUCK</b></center>"
	marker.talkas("Then, the window closes 10 seconds after the last thing I say or emote. Fun!")
	sleep(100)
	kill_window()
