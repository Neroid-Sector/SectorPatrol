/area/sts_ship/
	name = "sts ship area master"
	icon = 'icons/sectorpatrol/areas/sts_areas.dmi'
	icon_state = "general"
	var/ship_name = "none"
	var/area_id = "ID"

/area/sts_ship/Initialize(mapload, ...)
	. = ..()
	GLOB.sts_ship_areas += src
