//Marie setup. Also a template for ship specific defs. To create new ships, create new file with these and sat the name to the same things, then stick them all on a map in sts ares that also have the ship name set. They should be able to sync, as long as an entity with the same name exists on the sector map.
//Mission Control
/obj/structure/shiptoship_master/ship_missioncontrol/marie
	sector_map_data = list(
	"name" = "UAS Marie",
	"id_tag" = "none,",
	"initialized" = 0,
	"x" = 0,
	"y" = 0,
	)

//SIGNALS

/obj/structure/terminal/signals_console/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/probe_launcher/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/tracker_launcher/marie
	ship_name = "UAS Marie"

//WEAPONS

/obj/structure/terminal/weapons_console/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/primary_cannon/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/primer_lever/primary/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/secondary_cannon/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/primer_lever/secondary/marie
	ship_name = "UAS Marie"

//DAMAGE

/obj/structure/terminal/damage_console/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/damage_control_element/marie
	ship_name = "UAS Marie"

//CARGO, REMEMBER BAYS NEED ROUNDSTART CONTENTS IF NOT LOADED IN FROM SOMEWHERE POST LOAD

/obj/structure/terminal/cargo_console/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/cargo_bay/primary_munitions/marie
	ship_name = "UAS Marie"
	cargo_data = list(
		"missile_pst_homing" = 30,
		"missile_pst_dumbfire" = 30,
		"missile_pst_torpedo" = 30,
		"warhead_direct" = 30,
		"warhead_explosive" = 30,
		"warhead_mip" = 30,
		)

/obj/structure/ship_elements/cargo_bay/secondary_munitions/marie
	ship_name = "UAS Marie"
	cargo_data = list(
		"secondary_direct" = 30,
		"secondary_flak" = 30,
		"secondary_broadside" = 30,
		"probe" = 30,
		"tracker" = 30,
		)

//COMMAND

/obj/structure/ship_elements/command_chair/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/command_monitor/top/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/command_monitor/front/marie
	ship_name = "UAS Marie"

/obj/structure/ship_elements/command_monitor/bottom/marie
	ship_name = "UAS Marie"

//light groups

/obj/structure/machinery/light/shiplight/marie/weapons
	name = "ship light"
	ship_name = "UAS Marie"
	ship_light_group = "weapons"

/obj/structure/machinery/light/shiplight/marie/signals
	name = "ship light"
	ship_name = "UAS Marie"
	ship_light_group = "signals"

/obj/structure/machinery/light/shiplight/marie/command
	name = "ship light"
	ship_name = "UAS Marie"
	ship_light_group = "command"

/obj/structure/machinery/light/shiplight/marie/general
	name = "ship light"
	ship_name = "UAS Marie"
	ship_light_group = "general"

/obj/structure/ship_elements/control_pad/marie
	ship_name = "UAS Marie"


//AREAS

/area/sts_ship/marie/
	name = "UAS Marie"
	ship_name = "UAS Marie"
	area_id = "XXX"
	unlimited_power = 1

/area/sts_ship/marie/exterior
	name = "UAS Marie"
	ship_name = "UAS Marie - Exterior"
	area_id = "XXX"
	unlimited_power = 1
	base_lighting_alpha = 255

/area/sts_ship/marie/airlock
	name = "UAS Marie - External Airlock"
	ship_name = "UAS Marie"
	area_id = "AIR"
	unlimited_power = 1

/area/sts_ship/marie/hall
	name = "UAS Marie - Main Hallway"
	ship_name = "UAS Marie"
	area_id = "HLW"

/area/sts_ship/marie/rec
	name = "UAS Marie - Recreation"
	ship_name = "UAS Marie"
	area_id = "REC"

/area/sts_ship/marie/med
	name = "UAS Marie - Medical"
	ship_name = "UAS Marie"
	area_id = "MED"

/area/sts_ship/marie/cryo
	name = "UAS Marie - Emergency Cryogenics"
	ship_name = "UAS Marie"
	area_id = "CRY"

/area/sts_ship/marie/wc
	name = "UAS Marie - Toilet and Shower"
	ship_name = "UAS Marie"
	area_id = "SAN"

/area/sts_ship/marie/command
	name = "UAS Marie - CIC"
	area_id = "CIC"
	icon_state = "command"

/area/sts_ship/marie/command_comms
	name = "UAS Marie - Liquid Data Telecommunications Array"
	area_id = "COM"
	icon_state = "command"

/area/sts_ship/marie/command/twryplus
	name = "UAS Marie - Twilight Rail - Y-Positive"
	area_id = "TYP"
	icon_state = "command"

/area/sts_ship/marie/command/twryminus
	name = "UAS Marie - Twilight Rail - Y-Negative"
	area_id = "TYM"
	icon_state = "command"

/area/sts_ship/marie/command/twrxplus
	name = "UAS Marie - Twilight Rail - X-Positive"
	area_id = "TXP"
	icon_state = "command"

/area/sts_ship/marie/command/twrxminus
	name = "UAS Marie - Twilight Rail - X-Negative"
	area_id = "TXM"
	icon_state = "command"

/area/sts_ship/marie/weapons_p
	name = "UAS Marie - Primary Weapons Bay"
	area_id = "PWP"
	icon_state = "weapons"

/area/sts_ship/marie/weapons_s
	name = "UAS Marie - Secondary Weapons Bay"
	area_id = "SWP"
	icon_state = "weapons"

/area/sts_ship/marie/cargo
	name = "UAS Marie - Cargo Bays"
	area_id = "CAR"
	icon_state = "cargo"

/area/sts_ship/marie/engineering
	name = "UAS Marie - Damage Control and Power Distribution"
	area_id = "ENG"
	icon_state = "engie"
