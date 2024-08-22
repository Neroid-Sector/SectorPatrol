

/obj/structure/terminal/briefing
	name = "briefing display"
	desc = "A large-scale display, safely mounted inside a slot made in the hull of the ship"
	desc_lore = "Computer displays on most ships tend to be adjusted for single colored text, initially due to lack of technology that allowed for better quality displays to survive out in space. Over time this became more a habit than anything else, as evidenced by PDAs which do not limit themselves in terms of display capabilities. Large scale displays such as this one have resisted over a hundred years' worth of technological progress and still reign supreme across human space ships. Truly, you are looking at a classic. For better or worse."
	icon = 'icons/obj/structures/machinery/displaymonitor.dmi'
	icon_state = "off"
	terminal_id = "briefing"
	var/terminal_range = 20
	terminal_window_size = "500x630"
	terminal_line_length = 38
	terminal_line_height = 13
	header_name = "RDML. Thomas Boulette"
	var/op_info = "PST INTERCEPTOR PROTOTYPING"

/obj/structure/terminal/Initialize(mapload, ...)
	. = ..()
	icon_state = "off"
	update_icon()

/obj/structure/terminal/briefing/kill_window(reset = 1)
	for (var/mob/mobs in world)
		mobs << browse(null, "window=[terminal_id]")
		if(reset == 1) reset_buffer()

/obj/structure/terminal/briefing/WriteHeader()
	terminal_header = {"<center><b>[header_name]</b><br>UACM 2ND LOGISTICS<hr>[op_info]</center>"}

/obj/structure/terminal/briefing/terminal_display() // Display loop. HTML encodes (which incidentally should also prevent a lot of HTML shenanigans since it escapes characters) and displays current buffer. Please don't laugh at my placeholder HTML -_- , in normal circumstances should not need edits unless you want to change the style for an individual terminal.
	trim_buffer()
	var/terminal_output = ("<p>" + jointext((terminal_trimmed_buffer), "</p><p>") + "</p>")
	var/terminal_html ={"<!DOCTYPE html>
	<html>
	<head>
	<style>
	body {
	background-color:black;
	width: calc(800px - 2em);
    }
    .box {
    border-style: solid;
    height: 110px;
    }
    .text {
    padding: 0px 5px;
    }
	.text_head {
    padding: 10px 5px;
    }
    .box_console {
    border-style: solid;
    height: 490px;
    }
	#terminal_text {
	font-family: 'Courier New',
	cursive, sans-serif;
	color: #1bdd4b;
	text-align: left;
	padding: 0em, 1em;
	}
	</style>
	</head>
	<body>
	<div id = "terminal_text">
	<div class="box">
	<div class="text_head">
	<p>
	[terminal_header]
	</p>
	</div>
	</div>
	<div class="box_console">
	<div class="text">
	<p>
	[terminal_output]
	</p>
	</div>
	</div>
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
	marker.name = "RDML. Thomas Boulette"
	marker.langchat_color = "#268323"
	icon_state = "blank"
	update_icon()
	emoteas("buzzes audibly then comes to life.", 1)
	terminal_display()
	emoteas("Buzzes loudly and starts to display a UACM logo")
	icon_state = "uacm"
	update_icon()
	marker.talkas("Good afternoon, Test Crews. I hope you are ready to make history.")
	marker.talkas("This is the first live crew test of the PSTs own interceptors. Essentially, on paper at least, this is literally why any of you are here, testing these prototypes.")
	marker.talkas("However, I can safely tell you this is likely way more than just a simple test.")
	icon_state = "list"
	emoteas("The buzzing intensifies as the terminal starts to display lists.", 1)
	update_icon()
	terminal_display_line("OV-PST PURSUIT INTERCEPTOR", 0, 1, 1)
	terminal_display_line("- Light weight, rapid interceptor craft.", 0, 1)
	terminal_display_line("- Can be safely operated by a crew of two to five men.", 0, 1)
	terminal_display_line("- Utilizes the Mission Control OV-PST link.", 0, 0)
	marker.talkas("We have two prototypes ready to test. I know that some of you are frequently called to other duties on the station...")
	marker.talkas("So, we will make the final decision how many prototypes are crewed and by whom once we get there.")
	marker.talkas("Take everything. You should have the tools to completely recycle the whole vessel.")
	marker.talkas("Now. There are two systems that you will be expected to write a report on.")
	marker.talkas("One, ships hyperspace.")
	reset_buffer()
	update_icon()
	terminal_display_line("TRADITIONAL HYPERSPACE JUMP", 0, 1, 1)
	terminal_display_line("- Gather Twilight Paradox Energy on the systems Twilight Boundary.", 0, 1)
	terminal_display_line("- Ship AI calculates departure and travel vector.", 0, 1)
	terminal_display_line("- Overcharging the ships twilight rails sends the ship into the jump.", 0, 1)
	terminal_display_line("- A minuscule error in calculations means missing target by light years.", 0, 0)
	marker.talkas("This, to remind you all, is the standard process of a hyperspace jump.")
	marker.talkas("Essentially you leave towards the system's edge, glide alongside it to charge your systems.")
	marker.talkas("Then push yourself through hyperspace to your target.")
	marker.talkas("Because of our station friend, the Interceptor takes a different route...")
	reset_buffer()
	update_icon()
	terminal_display_line("MISSION CONTROL ASSISTED JUMP", 0, 1, 1)
	terminal_display_line("- Mission Control establishes the position of target based on star chart information.", 0, 1)
	terminal_display_line("- Twilight Paradox energy, pushed from the PST overcharges the ship's engines, causing a Paradox Gap to form under the ship.", 0, 1)
	terminal_display_line("- The ship falls into the gap and into Hyperspace. The crew tries not to panic.", 0, 1)
	terminal_display_line("- A physical manifestation of Mission Control in their native enviroment pulls the ship to its destination.", 0, 0)
	marker.talkas("Now, I know what some of you may be thinking. Overcharging your ships engines is a sure way to kill everyone on board you ship.")
	marker.talkas("I can assure you we've sent literally hundreds of tester craft through the field this way.")
	marker.talkas("We are hoping that human presence during the jump will let us understand the mechanics of LD or Hyperspace better.")
	marker.talkas("But just in case, be ready for the unexpected. Our local 'experts' on unexpected contact with Liquid Data say that at most, it should be auditory hallucinations.")
	marker.talkas("They will be listening in once you deploy to help with any issues that may arise.")
	marker.talkas("The second system to test is Mission Controls absolute coordinate system.")
	reset_buffer()
	update_icon()
	terminal_display_line("MISSION CONTROL GRID", 0, 1, 1)
	terminal_display_line("- Segment the sector into a grid of squares.", 0, 1)
	terminal_display_line("- Tracks and relates all information to MC enabled systems using the grid as reference.", 0, 1)
	terminal_display_line("- Effectively no two ships and no two missiles can occupy the same MC grid.", 0, 0)
	marker.talkas("This means that all your ship navigation, weapons, problems and what have you can now be operated and interpreted by coordinates, and not relative position as we have done until now.")
	marker.talkas("Compared to you, other spaceships will be blind as bats. Literally.")
	reset_buffer()
	update_icon()
	terminal_display_line("MISSION CONTROL GRID, CONT.", 0, 1, 1)
	terminal_display_line("- All primary firing procedures require absolute coordinates.", 0, 1)
	terminal_display_line("- Coordinates are gathered by using ship probes, fired on relative vectors.", 0, 1)
	terminal_display_line("- Direct hit with probe gives more information.", 0, 0)
	marker.talkas("And this is basically what you need to remember when it comes to operating your ships. We will provide more instruction remotely.")
	marker.talkas("This is a test, and we do not expect everything to work perfectly.")
	marker.talkas("There are other features that the ships have, but I feel like I'll bore you if I drone on any longer.")
	marker.talkas("Decide among yourselves who crews what. For the time being, consider all posts fluid.")
	marker.talkas("Thank you and good luck.")
	icon_state = "off"
	update_icon()
	kill_window()
	reset_buffer()
