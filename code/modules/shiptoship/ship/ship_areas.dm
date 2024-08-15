/area/sts_ship/
	name = "sts ship area master"
	var/ship_name = "none"

/area/sts_ship/Initialize(mapload, ...)
	. = ..()
	GLOB.sts_ship_areas += src
