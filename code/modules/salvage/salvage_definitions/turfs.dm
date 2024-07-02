/turf/open/salvage/plating
	name = "hull - floor"
	icon = 'icons/sectorpatrol/salvage/turfs/floortiles.dmi'
	icon_state = "default"
	desc = "A hull segment that acts as a floor of the ship. Made from thick, hull metal, cold to the touch."
	desc_affix = "It's covered with plating seemingly cobbled together in a 3d printer somewhere. Not NRPS compliant."
	desc_lore = "Hull metal is a colloquial term for any metal durable enough to withstand the rigors of space travel and that literally means any metal. To this day there is no reliable standard to what is considered 'safe' to build hulls out of and if the ship makes its planned journey, most people don't ask questions. Ship hulls cannot be salvaged with a recycler and require a drone spike. They should yield a good amount of metal and some alloys."
	desc_lore_affix = "Ship plating is not considered an essential part of any spaceship and some in fact do without, either covering the naked hulls with something more akin to rugs, or outright just using naked plating. It's generally not considered a good idea, as the plating helps in retaining considerable amounts of heat, especially considering the tendency for spaceships to get cold. Plating should be an average source of resins and not much else."
	salvage_decon_keyword = "ACBBDB"
	salvage_contents = list(
	"metal" = 15,
	"resin" = 0,
	"alloy" = 5,
	)
	salvage_contents_tile = list(
	"metal" = 0,
	"resin" = 10,
	"alloy" = 0,
	)

/turf/closed/wall/salvage
	name = "hull - wall"
	desc = "A sturdy looking metal wall. Cold to the touch. Seems almost impenetrable."
	desc_lore = "Unlike their 'floor' counterparts, hull walls are typically at least twice as thick and are expected to be able to separate the cold vacuum of space from whatever they are protecting, even if outside hull walls should fail. As such, they tend to consider a balanced, decent amount of metals and heavier alloys. Walls cannot be salvaged using normal recycles and need to be converted by a drone via a deployed drone spike."
	hull = 1
	salvage_contents = list(
	"metal" = 10,
	"resin" = 0,
	"alloy" = 10,
	)
