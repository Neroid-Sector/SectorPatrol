//markers
//fixture
/obj/structure/machinery/light_construct/marker
	name = "marker light fixture frame"
	desc = "A light fixture using colored bulbs under construction."
	desc_lore = "Colored lights, often referred to as marker lights, are often employed on the outside segments of space stations or ships, marking specific maintenance areas. Over time, they were also adopted for inside use and often serve as warning or pathway lights on some ships, directing crewmembers to specific areas of the ship as needed."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "marker-construct-s1"
	anchored = TRUE
	layer = FLY_LAYER
	fixture_type = "marker"
	sheets_refunded = 2

//base finished light

/obj/structure/machinery/light/marker
	name = "marker light"
	icon = 'icons/obj/items/lighting.dmi'
	base_state = "marker" // base description and icon_state
	bulb_color = LIGHT_COLOR_HOLY_MAGIC
	color_state = "yellow"
	icon_state = "markeryellow1"
	desc = "A marker light fixture that currently has an yellow/natural light bulb."
	desc_lore = "Colored lights, often referred to as marker lights, are often employed on the outside segments of space stations or ships, marking specific maintenance areas. Over time, they were also adopted for inside use and often serve as warning or pathway lights on some ships, directing crewmembers to specific areas of the ship as needed."
	anchored = TRUE
	layer = FLY_LAYER
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = POWER_CHANNEL_LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	light_system = STATIC_LIGHT
	brightness = 6 // luminosity when on, also used in power calculation

	light_type = /obj/item/light_bulb/marker // the type of light item
	fitting = "marker"
	appearance_flags = TILE_BOUND

/obj/structure/machinery/light/marker/indigo
	name = "makrer light bulb - indigo"
	desc = "A marker light fixture that currently has an indigo light bulb."
	icon_state = "markerindigo1"
	color_state = "indigo"
	bulb_color = LIGHT_COLOR_DARK_BLUE

/obj/structure/machinery/light/marker/built/Initialize()
	. = ..()
	status = LIGHT_EMPTY
	update(0)

//bulbs
/obj/item/light_bulb/marker
	name = "makrer light bulb - natural yellow"
	desc = "A light bulb for a marker light. This one is colored yellow, meaning it gives a natural, warm light."
	desc_lore = "Colored lights, often referred to as marker lights, are often employed on the outside segments of space stations or ships, marking specific maintenance areas. Over time, they were also adopted for inside use and often serve as warning or pathway lights on some ships, directing crewmembers to specific areas of the ship as needed."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "markeryellowbulb"
	force = 2
	throwforce = 5
	w_class = SIZE_SMALL
	color_state = "yellow"
	bulb_color = LIGHT_COLOR_HOLY_MAGIC
	status = 0 // LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	base_state = "markerbulb"
	matter = list("metal" = 60)
	brightness = 6 //how much light it gives off

/obj/item/light_bulb/marker/indigo
	name = "makrer light bulb - indigo"
	desc = "A light bulb for a marker light. This one is tintend indigo, giving it a distinct, dark blue shade."
	icon_state = "markerbulbindigo"
	color_state = "indigo"
	bulb_color = LIGHT_COLOR_DARK_BLUE

//admin items, use invisible but alphamapped icon and clickthrough for trigerable mood lighting

/obj/structure/machinery/light/marker/admin

	name = "admin light"
	desc = "This shoudnt be visible to players"
	icon_state = "admin_light"
	base_state = "admin_light"
	light_id = "admin"
	color_state = null
	bulb_color = COLOR_WHITE
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_type = /obj/item/light_bulb/marker/admin

/obj/item/light_bulb/marker/admin

	name = "makrer light bulb - admin"
	desc = "Admin light bulb. Should not be visible."
	icon_state = "admin_lightbulb"
	base_state = "admin_lightbulb"
	color_state = null
	bulb_color = COLOR_WHITE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/machinery/light/shiplight
	name = "ship light"
	desc = "A sturdy looking see through tube with multiple rows of small diodes lined up on a small circuit board."
	desc_lore = "Manufacturers of hardened light bulbs saw a complete revival of their industry as space flight exploded and humanity became accommodated with the encroachment of the dark during their travel through the stars. These bulbs are the product of continued prosperity guaranteed to anyone lucky enough to break it into the highly competitive field. This light bulb is capable of changing its brightness and color and has a LD enabled chip which lets it be tied into other PST systems."
	light_color = COLOR_WHITE
	light_range = 8
	var/ship_name
	var/ship_light_group

/obj/structure/machinery/light/shiplight/proc/StatusChange(status)
	switch(status)
		if(null)
			return
		if("dim")
			light_color = COLOR_WHITE
			set_light(2)
		if("normal")
			light_color = COLOR_WHITE
			set_light(8)
		if("turn_on")
			light_color = COLOR_WHITE
			var/starting_value = 2
			while(starting_value <= 8)
				set_light(starting_value)
				starting_value += 1
				sleep(1)
		if("red_alert")
			light_color = "#be0606"
			set_light(8)
			sleep(15)
			set_light(3)
			sleep(5)
			set_light(8)
			sleep(15)
			set_light(3)
			sleep(5)
			set_light(8)
		if("off")
			set_light(0)
