/obj/item

	name = "Generic item, or missed empty name iheritance. Please report this if you see it in the wild."
	var/item_serial
	var/item_serial_distance = SERIAL_ITEM_SIZE_MEDIUM

/obj/item/examine(mob/user)
	..()
	if (item_serial != null)
		if(!isxeno(user) && (get_dist(user, src) < item_serial_distance || isobserver(user)))
			to_chat(usr, SPAN_NOTICE("You can see a serial number. <a href='byond://?src=\ref[src];show_serial=1'>Click here to take a closer look.</a>."))

/obj/item/Topic(href, list/href_list)
	. = ..()
	if(href_list["show_serial"])
		var/serial_windowname = name + "_serial_[rand(1, 1000)]"
		var/serial_displayhtml = {"<!DOCTYPE html>
		<html>
		<head>
		<style>
		body {
		background-color:black;
		}
		#narrate_serial {
		font-family: 'Lucida Grande', monospace;
		color: #d4d6d6;
		text-align: center;
		padding: 0em 1em;
		}
		#narrate_serial_block {
		background: #1b1c1e;
		border: 1px solid #a4bad6;
		margin: 0.5em 15%;
		padding: 0.5em 0.75em;
		}
		</style>
		</head>
		<body>
		<div id="narrate_serial">
		<div id="narrate_serial_block">
		<p>
		[item_serial]
		</p>
		</div>
		</div>
		</body>
		"}
		usr << browse(serial_displayhtml,"window=[serial_windowname];display=1;size=500x150;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
		onclose(usr, "[serial_windowname]")

//Going to take this chance to sneak in emoting and speaking procs :P

/obj/item/proc/talkas(str, delay) //Talk as item. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE)
	src.visible_message("<b>[src]</b> says, \"[str]\"")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return


/obj/item/proc/emoteas(str, delay) //Emote as item. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
	src.visible_message("<b>[src]</b> [str]")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return

/obj/structure

	name = "Generic structure, or missed empty name inheritance. Should not be seen anywhere in game. Plese report this if you see it in the wild."
	var/item_serial
	var/item_serial_distance = SERIAL_STRUCTURE_SIZE_MEDIUM

/obj/structure/examine(mob/user)
	..()
	if (item_serial != null)
		if(!isxeno(user) && (get_dist(user, src) < item_serial_distance || isobserver(user)))
			to_chat(usr, SPAN_NOTICE("You can see a serial number. <a href='byond://?src=\ref[src];show_serial=1'>Click here to take a closer look.</a>."))

/obj/structure/Topic(href, list/href_list)
	. = ..()
	if(href_list["show_serial"])
		var/serial_windowname = name + "_serial_[rand(1, 1000)]"
		var/serial_displayhtml = {"<!DOCTYPE html>
		<html>
		<head>
		<style>
		body {
		background-color:black;
		}
		#narrate_serial {
		font-family: 'Lucida Grande', monospace;
		color: #d4d6d6;
		text-align: center;
		padding: 0em 1em;
		}
		#narrate_serial_block {
		background: #1b1c1e;
		border: 1px solid #a4bad6;
		margin: 0.5em 15%;
		padding: 0.5em 0.75em;
		}
		</style>
		</head>
		<body>
		<div id="narrate_serial">
		<div id="narrate_serial_block">
		<p>
		[item_serial]
		</p>
		</div>
		</div>
		</body>
		"}
		usr << browse(serial_displayhtml,"window=[serial_windowname];display=1;size=500x130;border=0;can_close=1;can_resize=1;can_minimize=1;titlebar=1")
		onclose(usr, "[serial_windowname]")

//As above

/obj/structure/proc/talkas(str, delay) //Talk as structure. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE)
	src.visible_message("<b>[src]</b> says, \"[str]\"")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return

/obj/structure/proc/emoteas(str, delay) //Emote as structure. Delay in BYOND ticks (about 1/10 of a second per tick) If not provided, delay calculated automatically depending in message length.
	if (!str) return
	var/list/heard = get_mobs_in_view(GLOB.world_view_size, src)
	src.langchat_speech(str, heard, GLOB.all_languages, skip_language_check = TRUE, animation_style = LANGCHAT_FAST_POP, additional_styles = list("langchat_small", "emote"))
	src.visible_message("<b>[src]</b> [str]")
	var/talkdelay = delay
	if (!talkdelay)
		if ((length("[str]")) <= 64)
			talkdelay = 40
		if ((length("[str]")) > 64)
			talkdelay = 60
	sleep(talkdelay)
	return
