//Amelia setup. Also a template for ship specific defs. To create new ships, create new file with these and sat the name to the same things, then stick them all on a map in sts ares that also have the ship name set. They should be able to sync, as long as an entity with the same name exists on the sector map.
//Mission Control
/obj/structure/shiptoship_master/ship_missioncontrol/amelia
	sector_map_data = list(
	"name" = "UAS Amelia",
	"id_tag" = "none,",
	"initialized" = 0,
	"x" = 0,
	"y" = 0,
	)

//SIGNALS

/obj/structure/terminal/signals_console/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/probe_launcher/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/tracker_launcher/amelia
	ship_name = "UAS Amelia"

//WEAPONS

/obj/structure/terminal/weapons_console/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/primary_cannon/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/primer_lever/primary/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/secondary_cannon/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/primer_lever/secondary/amelia
	ship_name = "UAS Amelia"

//DAMAGE

/obj/structure/terminal/damage_console/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/damage_control_element/amelia
	ship_name = "UAS Amelia"

//CARGO, REMEMBER BAYS NEED ROUNDSTART CONTENTS IF NOT LOADED IN FROM SOMEWHERE POST LOAD

/obj/structure/terminal/cargo_console/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/cargo_bay/primary_munitions/amelia
	ship_name = "UAS Amelia"
	cargo_data = list(
		"missile_pst_homing" = 30,
		"missile_pst_dumbfire" = 30,
		"missile_pst_torpedo" = 30,
		"warhead_direct" = 30,
		"warhead_explosive" = 30,
		"warhead_mip" = 30,
		)

/obj/structure/ship_elements/cargo_bay/secondary_munitions/amelia
	ship_name = "UAS Amelia"
	cargo_data = list(
		"secondary_direct" = 30,
		"secondary_flak" = 30,
		"secondary_broadside" = 30,
		"probe" = 30,
		"tracker" = 30,
		)

//COMMAND

/obj/structure/ship_elements/command_chair/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/command_monitor/top/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/command_monitor/front/amelia
	ship_name = "UAS Amelia"

/obj/structure/ship_elements/command_monitor/bottom/amelia
	ship_name = "UAS Amelia"

//AREAS

/area/sts_ship/amelia/
	name = "UAS Amelia"
	ship_name = "UAS Amelia"
	area_id = "TST"

/area/sts_ship/amelia/command
	name = "UAS Amelia - Bridge"
	area_id = "TST"
	icon_state = "command"

/area/sts_ship/amelia/weapons
	name = "UAS Amelia - Weapons Bay"
	area_id = "TST"
	icon_state = "weapons"

/area/sts_ship/amelia/cargo
	name = "UAS Amelia - Cargo Bay"
	area_id = "TST"
	icon_state = "cargo"

/area/sts_ship/amelia/engineering
	name = "UAS Amelia - Engineering Bay"
	area_id = "TST"
	icon_state = "engie"


/obj/structure/machinery/light/shiplight/amelia/weapons
	ship_name = "UAS Amelia"
	ship_light_group = "weapons"

/obj/structure/machinery/light/shiplight/amelia/signals
	ship_name = "UAS Amelia"
	ship_light_group = "signals"

/obj/structure/machinery/light/shiplight/amelia/command
	ship_name = "UAS Amelia"
	ship_light_group = "command"

/obj/structure/machinery/light/shiplight/amelia/general
	ship_name = "UAS Amelia"
	ship_light_group = "general"

/obj/structure/ship_elements/control_pad/amelia
	ship_name = "UAS Amelia"
