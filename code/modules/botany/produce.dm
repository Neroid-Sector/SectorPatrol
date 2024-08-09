// Seed packs and produce goes here

// Seeds

/obj/item/botany/seed_packet/berry
	name = "seed packet - berries"
	desc = "A packet of berry seeds ready for planting in a OV-PST bioturf tray."
	icon_state = "berry-seed"
	botany_plant_data = list(
		"name" = "berry",
		"yield" = 5,
		"additive" = "Pesticide",
		"aftercare" = "Prune",
		"repeating" = 0,
		)

/obj/item/reagent_container/food/snacks/produce/berry
	name = "berries"
	desc = "a handfull of multicolored berries"
	icon_state = "berry"
	produce_properties = list(
		"quality" = 0,
		"type" = "berry",
		"nutriment" = 5,
		"bitesize" = 1,
		)
