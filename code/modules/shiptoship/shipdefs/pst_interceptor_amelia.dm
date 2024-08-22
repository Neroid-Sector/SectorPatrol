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

//light groups

/obj/structure/machinery/light/shiplight/amelia/weapons
	name = "ship light"
	ship_name = "UAS Amelia"
	ship_light_group = "weapons"

/obj/structure/machinery/light/shiplight/amelia/signals
	name = "ship light"
	ship_name = "UAS Amelia"
	ship_light_group = "signals"

/obj/structure/machinery/light/shiplight/amelia/command
	name = "ship light"
	ship_name = "UAS Amelia"
	ship_light_group = "command"

/obj/structure/machinery/light/shiplight/amelia/general
	name = "ship light"
	ship_name = "UAS Amelia"
	ship_light_group = "general"

/obj/structure/ship_elements/control_pad/amelia
	ship_name = "UAS Amelia"


//AREAS

/area/sts_ship/amelia/
	name = "UAS Amelia"
	ship_name = "UAS Amelia"
	area_id = "XXX"
	unlimited_power = 1

/area/sts_ship/amelia/exterior
	name = "UAS Amelia"
	ship_name = "UAS Amelia - Exterior"
	area_id = "XXX"
	unlimited_power = 1
	base_lighting_alpha = 255

/area/sts_ship/amelia/airlock
	name = "UAS Amelia - External Airlock"
	ship_name = "UAS Amelia"
	area_id = "AIR"
	unlimited_power = 1

/area/sts_ship/amelia/hall
	name = "UAS Amelia - Main Hallway"
	ship_name = "UAS Amelia"
	area_id = "HLW"

/area/sts_ship/amelia/rec
	name = "UAS Amelia - Recreation"
	ship_name = "UAS Amelia"
	area_id = "REC"

/area/sts_ship/amelia/med
	name = "UAS Amelia - Medical"
	ship_name = "UAS Amelia"
	area_id = "MED"

/area/sts_ship/amelia/cryo
	name = "UAS Amelia - Emergency Cryogenics"
	ship_name = "UAS Amelia"
	area_id = "CRY"

/area/sts_ship/amelia/wc
	name = "UAS Amelia - Toilet and Shower"
	ship_name = "UAS Amelia"
	area_id = "SAN"

/area/sts_ship/amelia/command
	name = "UAS Amelia - CIC"
	area_id = "CIC"
	icon_state = "command"

/area/sts_ship/amelia/command_comms
	name = "UAS Amelia - Liquid Data Telecommunications Array"
	area_id = "COM"
	icon_state = "command"

/area/sts_ship/amelia/command/twryplus
	name = "UAS Amelia - Twilight Rail - Y-Positive"
	area_id = "TYP"
	icon_state = "command"

/area/sts_ship/amelia/command/twryminus
	name = "UAS Amelia - Twilight Rail - Y-Negative"
	area_id = "TYM"
	icon_state = "command"

/area/sts_ship/amelia/command/twrxplus
	name = "UAS Amelia - Twilight Rail - X-Positive"
	area_id = "TXP"
	icon_state = "command"

/area/sts_ship/amelia/command/twrxminus
	name = "UAS Amelia - Twilight Rail - X-Negative"
	area_id = "TXM"
	icon_state = "command"

/area/sts_ship/amelia/weapons_p
	name = "UAS Amelia - Primary Weapons Bay"
	area_id = "PWP"
	icon_state = "weapons"

/area/sts_ship/amelia/weapons_s
	name = "UAS Amelia - Secondary Weapons Bay"
	area_id = "SWP"
	icon_state = "weapons"

/area/sts_ship/amelia/cargo
	name = "UAS Amelia - Cargo Bays"
	area_id = "CAR"
	icon_state = "cargo"

/area/sts_ship/amelia/engineering
	name = "UAS Amelia - Damage Control and Power Distribution"
	area_id = "ENG"
	icon_state = "engie"
