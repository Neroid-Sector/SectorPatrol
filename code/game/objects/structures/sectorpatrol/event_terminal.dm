//Event terminal master. All global and general procs go here.
/obj/structure/eventterminal
	icon = 'icons/obj/structures/machinery/clio_maint.dmi'
	icon_state = "closed"
	name = "terminal - placeholder"
	desc = "An admin or placeholder version of interaction terminals."
	desc_lore = "Use event specifc terminals you dunce."
	anchored = TRUE
	plane = FLOOR_PLANE
	unacidable = TRUE
	unslashable = TRUE
	var/global/puzzlebox_global_status = 0 // Global event progression measurment goes here
	var/puzzlebox_pythia_sign = "0"// For determining if this terminal had a Pythia episode
	var/puzzlebox_id //for doors and lights etc
	var/puzzlebox_user //Determines who can type if multiple users
	var/puzzlebox_user_loc // Moving away check
//Cutscene tools - speaking, doors, lights, etc
//Emote and say moved to general objects and device defs

/obj/structure/eventterminal/proc/open_doors(door_id = puzzlebox_id) //Sends a call to open doors with matching id string.
	var/dooorid = door_id
	if (!dooorid) return
	for(var/obj/structure/machinery/door/D in world)
		if(D.id == dooorid)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, unlock))
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, open))

/obj/structure/eventterminal/proc/close_doors(door_id = puzzlebox_id) //Sends a call to open doors with matching id string.
	var/dooorid = door_id
	if (!dooorid) return
	for(var/obj/structure/machinery/door/D in world)
		if(D.id == dooorid)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door, close))
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, lock))

/obj/structure/eventterminal/proc/change_lights(lights_id = puzzlebox_id, light_state = 1, lights_color, light_brightness = null, light_flicker = 0) // Changees and updates lights on working light fixtures. Lights_id corresponds to var on the fixtures to determine which lights to affect; light_state 0 for off, 1 for on; lights_color accepts color values; light_brightness self explanatory, light_flicker when non 0 will pass flicker for number of ticks)
	var/bulbid = "[lights_id]"
	var/bulbcolor = "[lights_color]"
	var/bulbbright = light_brightness
	var/bulbonoff = light_state
	var/bulbflicker = light_flicker
	if (!bulbid || !bulbcolor) return
	for(var/obj/structure/machinery/light/L in world)
		if(L.light_id == bulbid)
			L.bulb_color = bulbcolor
			L.light_color = bulbcolor
			L.on = bulbonoff
			if (bulbbright != null) L.brightness = bulbbright
			L.update()
			if (bulbflicker != 0) L.flicker(bulbflicker)
	return

//Terminal output shortcuts

/obj/structure/eventterminal/proc/terminal_speak(str, delay = TERMINAL_STANDARD_SLEEP) //Print string onto the console output format. Delay sets ammount until next line is printed/next command is sent.
	var/puzzlebox_temp_say = str
	var/puzzlebox_temp_delay = delay
	if (!puzzlebox_temp_say) return
	to_chat(usr, narrate_console("[puzzlebox_temp_say]"))
	if (puzzlebox_temp_delay != null)sleep(puzzlebox_temp_delay)
