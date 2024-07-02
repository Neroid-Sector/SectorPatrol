//Recycling related items and structures

//salvager loop - backpack, nozzle, recycler

/obj/item/salvage/recycler_backpack
	name = "recycler backpack"
	desc = "Two hefty looking cylinders with some electronics attached to them, wrapped in several tubes connected to what looks like a Liquid Data enabled terminal on the back. Heavier than it looks, and it looks quite heavy."
	desc_lore = "Recycler backpacks store matter converted by nozzles that are paired with it in multiple separated compartment slots. Matter converted using Twilight Paradox reduction is atypically dense, which explains why these packs tend to get way heavier than one would think, especially as they fill up.</p><p>More than one nozzle can be paired with a single pack thanks to the Liquid Data transfer methods utilized, the nozzles just need to be in close range of the pack. The pack also does not have to be worn on the back to be effective, however due to its unusual weight, it is not advised to try and pull a pack that's close to being full."
	icon = 'icons/obj/sp_icons/salvaging/icon/recycler_items.dmi'
	icon_state = "recycler_back"
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_HUGE
	slowdown = 0.2
	drag_delay = 2
	flags_item = NOBLUDGEON
	no_salvage = 1
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/sp_icons/salvaging/onmob/recycler_lhand.dmi',
		WEAR_R_HAND = 'icons/obj/sp_icons/salvaging/onmob/recycler_rhand.dmi',
		WEAR_BACK = 'icons/obj/sp_icons/salvaging/onmob/recycler_back.dmi'
		)
	var/list/recycler_backpack_stored_materials = list(
		"metal" = 0,
		"resin" = 0,
		"alloy" = 0
		)
	var/recycler_backpack_storage_max = 1000
	var/recycler_backpack_storage = 0

/obj/item/salvage/recycler_backpack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/recycler_nozzle))
		var/obj/item/salvage/recycler_nozzle/nozzle = W
		if(nozzle.recycler_nozzle_paired_pack == null)
			nozzle.recycler_nozzle_paired_pack = src
			playsound(nozzle, 'sound/machines/ping.ogg', 25)
			talkas("Nozzle paired.")
			return
		if(nozzle.recycler_nozzle_paired_pack != null)
			talkas("Error. Nozzle already paired. Please reset pairing on the nozzle.")
			to_chat(usr, SPAN_INFO("The nozzle needs to be used in GRAB intent to reset its pairing before you can do that."))
			return

/obj/item/salvage/recycler_backpack/update_icon()
	recycler_backpack_storage = recycler_backpack_stored_materials["metal"] + recycler_backpack_stored_materials["resin"] + recycler_backpack_stored_materials["alloy"]
	if(recycler_backpack_storage == 0)
		slowdown = initial(slowdown)
		drag_delay = initial(drag_delay)
		icon_state = initial(icon_state)
	if(recycler_backpack_storage > 0 && recycler_backpack_storage < (recycler_backpack_storage_max * 0.35))
		slowdown = 0.4
		drag_delay = 3
		icon_state = initial(icon_state) + "_1"
	if(recycler_backpack_storage >= (recycler_backpack_storage_max * 0.35) && recycler_backpack_storage < (recycler_backpack_storage_max * 0.65))
		slowdown = 0.6
		drag_delay = 4
		icon_state = initial(icon_state) + "_2"
	if(recycler_backpack_storage >= (recycler_backpack_storage_max * 0.65) && recycler_backpack_storage < (recycler_backpack_storage_max))
		slowdown = 0.8
		drag_delay = 5
		icon_state = initial(icon_state) + "_3"
	if(recycler_backpack_storage >= (recycler_backpack_storage_max))
		slowdown = 1
		drag_delay = 6
		icon_state = initial(icon_state) + "_4"
		recycler_full_warning()
	. = ..()

/obj/item/salvage/recycler_backpack/proc/recycler_add_salvage(metal = 0,resin = 0,alloy = 0) // Called by nozzles depending on objects used on, adds resources to backpacks storage
	if (metal == 0 && resin == 0 && alloy == 0)
		talkas("Item recycled. Notice: No resources of note detected.")
		return
	recycler_backpack_stored_materials["metal"] += metal
	recycler_backpack_stored_materials["resin"] += resin
	recycler_backpack_stored_materials["alloy"] += alloy
	sleep(15)
	update_icon()

/obj/item/salvage/recycler_backpack/proc/recycler_full_warning()
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	emoteas("Beeps twice")
	talkas("Internal pressure safety threshold reached. This backpack is full. Please head to your nearest deposit station.")

/obj/item/salvage/recycler_backpack/proc/recycler_empty()
	recycler_backpack_stored_materials["metal"] = 0
	recycler_backpack_stored_materials["resin"] = 0
	recycler_backpack_stored_materials["alloy"] = 0
	recycler_backpack_storage = 0
	playsound(src, 'sound/effects/tankhiss1.ogg', 25)
	update_icon()

/obj/item/salvage/recycler_nozzle
	name = "recycler nozzle"
	desc = "A pointed, long nozzle with a trigger attached to it and a long cable dangling from the back. The cable seems like it can be plugged into something. Liquid Data shimmers with an unusual green shade in a container attached to the top of the device."
	desc_lore = "On their own, these nozzles seem to be modified paint guns with an LD container on top, but jury rigged to work in reverse and aided by a small air cylinder near the trigger. This necessitates 'reloads' of the device, facilitated via plugging them into stationary charging machines. Once synced to a recycler collector unit, this device uses Liquid Data to create a localized Twilight Paradox field, which it then uses to break down any item into its very basic matter components and store this matter in a compartment on the collector.</p><p> While matter collected this way can only be effectively utilized by the Outer Veil Primary Supply Terminal which comes with its own slew of complications and restrictions, on paper at least widespread use of this technology could potentially help improve the quality of life of spacers everywhere by mercifully retiring some ships, particularly ones that still have elements of hulls from almost a century ago."
	icon = 'icons/obj/sp_icons/salvaging/icon/recycler_items.dmi'
	icon_state = "recycler_nozzle"
	w_class = SIZE_MEDIUM
	flags_item = NOBLUDGEON
	no_salvage = 1
	item_icons = list(
		WEAR_L_HAND = 'icons/obj/sp_icons/salvaging/onmob/recycler_lhand.dmi',
		WEAR_R_HAND = 'icons/obj/sp_icons/salvaging/onmob/recycler_rhand.dmi'
		)
	var/obj/item/salvage/recycler_backpack/recycler_nozzle_paired_pack = null
	var/recycler_nozzle_charges_max = 100
	var/recycler_nozzle_charges = 100

/obj/item/salvage/recycler_nozzle/proc/nozzle_recharge()
	recycler_nozzle_charges = recycler_nozzle_charges_max
	playsound(src, 'sound/effects/tankhiss1.ogg', 25)
	talkas("Nozzle recharged.")


/obj/item/salvage/recycler_nozzle/attack_self(mob/user)
	. = ..()
	if(usr.a_intent == INTENT_GRAB)
		if(recycler_nozzle_paired_pack == null)
			to_chat(usr, SPAN_INFO("This nozzle is not paired to any packs."))
			return
		recycler_nozzle_paired_pack = null
		emoteas("Beps twice.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)

/obj/structure/salvage/recycler_base
	name = "recycler depositor"
	icon = 'icons/obj/sp_icons/salvaging/structures/deposit.dmi'
	icon_state = "salvage_deposit"
	desc = "A top chamber laid over a high-powered hydraulic press."
	desc_lore = "Matter processed by the recyclers backpacks is further compressed in these devices, the end output being highly compressed rods that can be used on the Primary Supply Terminal. Further processed resources like this can also be used on board ships that have compliant manufacturing printers or lathes, but these too are constructed on the PST and as such are currently mostly restricted to ships operated by the Test Crews."
	no_salvage = 1
	var/recycler_busy = FALSE

/obj/structure/salvage/recycler_base/proc/salvage_process_recycler(metal = 0, resin = 0, alloy = 0)
	recycler_busy = TRUE
	var/metal_to_add = metal
	var/resin_to_add = resin
	var/alloy_to_add = alloy
	var/LDPol_to_add
	talkas("Depositing...")
	icon_state = "salvage_deposit_on"
	update_icon()
	if(metal_to_add)
		GLOB.resources_metal += metal_to_add
		LDPol_to_add += metal_to_add
		talkas("Metals deposited. Units processed: [metal_to_add]")
		sleep(15)
	if(resin_to_add)
		GLOB.resources_resin += resin_to_add
		LDPol_to_add += resin_to_add
		talkas("Resins deposited. Units processed: [resin_to_add]")
		sleep(15)
	if(alloy_to_add)
		GLOB.resources_alloy += alloy_to_add
		LDPol_to_add += alloy_to_add
		talkas("Alloys deposited. Units processed: [alloy_to_add]")
		sleep(15)
	LDPol_to_add /= 5
	GLOB.resources_ldpol += LDPol_to_add
	sleep(15)
	talkas("LD-Polymer extraction complete. Units processed: [LDPol_to_add]")
	icon_state = initial(icon_state)
	update_icon()
	recycler_busy = FALSE
	talkas("Deposit complete! Thank you for your contirbution!")
	return 1


/obj/structure/salvage/recycler_base/attackby(obj/item/W, mob/user)
	if(recycler_busy == TRUE)
		to_chat(usr, SPAN_WARNING("This device is working. Please wait until it finishes processing its current task."))
		return
	if(istype(W, /obj/item/salvage/recycler_backpack))
		var/obj/item/salvage/recycler_backpack/backpack = W
		if(backpack.recycler_backpack_storage == 0)
			playsound(src, 'sound/machines/terminal_error.ogg', 25)
			talkas("Error: Backpack empty.")
			return
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			if(salvage_process_recycler(metal = backpack.recycler_backpack_stored_materials["metal"], resin = backpack.recycler_backpack_stored_materials["resin"], alloy = backpack.recycler_backpack_stored_materials["alloy"]) == 1)
				INVOKE_ASYNC(backpack, TYPE_PROC_REF(/obj/item/salvage/recycler_backpack, recycler_empty))

//Processing: Nozzle recharge, document handler

/obj/structure/salvage/nozzle_charger
	name = "recycler nozzle recharge station"
	desc = "A small air compressor hooked up to a bigger machine that seems to be connected to a small Liquid Data pipeline. Something can clearly be attached to its bottom left corner."
	desc_lore = "The LD-Polymer Recycler system nozzle chargers follow the general idea behind all LD technology on the PST and attempts to be a waste-free source of compressed air for the nozzles. As such, it is a small closed system where a localized Twilight Paradox power source is used to create air molecules from 'scratch' as it were. While this means a nearly five-minute recharge time, which leaves much to be desired, the zero-waste production cycle is generally fairly impressive. "
	icon = 'icons/sectorpatrol/salvage/structures.dmi'
	icon_state = "nozzle_charger"
	no_salvage = 1
	anchored = 1
	opacity = 0
	density = 0
	var/charge_in_ticks = 1800
	var/charge_timer = 1

/obj/structure/salvage/nozzle_charger/proc/set_delay_timer()
	charge_timer = world.time + charge_in_ticks
	icon_state = initial(icon_state) + "_on"
	update_icon()
	sleep(charge_in_ticks)
	icon_state = initial(icon_state)
	update_icon()
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	talkas("Recharge complete. Awaiting nozzle.")

/obj/structure/salvage/nozzle_charger/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/recycler_nozzle/))
		if(charge_timer < world.time)
			INVOKE_ASYNC(W, TYPE_PROC_REF(/obj/item/salvage/recycler_nozzle, nozzle_recharge))
			INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/salvage/nozzle_charger, set_delay_timer))
			return
		if(charge_timer >= world.time)
			talkas("Error. Compressed air recharge in progress. Estimated time until recharge ready: [(charge_timer - world.time) / 10] seconds.")
			return

/obj/structure/salvage/drone_spike
	name = "OV-PST salvaging beacon"
	desc = "A thick metal disc of considerable weight. Seems to come with four heavy duty mounting struts that extend automatically. A big button and display light can be clearly seen on its top."
	desc_lore = "These beacons are used to take a detailed scan of the room they are in, convert the results of this scan into a Liquid Data compatible data format and then, once triggered by the salvaging operation commander and if no excess matter I detected, transmit this data to salvaging drones which in turn use it to dismantle the room completely. "
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "beacon_priming"
	anchored = 1
	no_salvage = 1
	opacity = 0
	density = 1
	var/spike_serial
	var/global/spike_serial_max = 0

/obj/structure/salvage/drone_spike/proc/icon_cycle()
	sleep(15)
	icon_state = "beacon_primed"
	update_icon()

/obj/structure/salvage/drone_spike/Initialize(mapload, ...)
	. = ..()
	spike_serial_max += 1
	spike_serial = spike_serial_max
	INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/structure/salvage/drone_spike, icon_cycle))
	GLOB.salvaging_active_spikes += src

/obj/item/salvage/data_spike
	name = "data spike"
	desc = "A small device that looks like a blue-tinted metal syringe with a swirling, bright purple liquid inside that seems to be oddly colored Liquid Data. The tip of the device does not look like it could break skin and there is no visible way to eject the liquid."
	desc_lore = "Data spikes contain a small amount of Liquid Data that comes directly from the OV-PSTs reserves and contains instructions written by Pythia in cooperation with UAAC-TIS engineers led by Commander Alysia Reed-Wilo. </p><p>When connected to a computer system, the data spike injects its Liquid Data content into the machine which results in a localized Crystalline infestation which instead of destroying the machine attempts to convert its contents into a Liquid Data compatible format, then transmits it to the PST's processing system, where the data is analyzed by Pythia and any usable intelligence is passed to UAAC-TIS operatives."
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "spike"
	no_salvage = 1
	flags_item = NOBLUDGEON

/obj/item/salvage/drone_spike
	name = "OV-PST salvaging beacon"
	desc = "A thick metal disc of considerable weight. Seems to come with four heavy duty mounting struts that extend automatically. A big button and display light can be clearly seen on its top."
	desc_lore = "These beacons are used to take a detailed scan of the room they are in, convert the results of this scan into a Liquid Data compatible data format and then, once triggered by the salvaging operation commander and if no excess matter I detected, transmit this data to salvaging drones which in turn use it to dismantle the room completely. "
	w_class = SIZE_LARGE
	icon = 'icons/sectorpatrol/salvage/items.dmi'
	icon_state = "beacon"
	no_salvage = 1


/obj/item/salvage/drone_spike/attack_self(mob/user)
	. = ..()
	if(icon_state == initial(icon_state))
		if(user.a_intent == INTENT_HELP)
			var/turf/current_turf = get_turf(src)
			if(current_turf.no_salvage == 1)
				talkas("Error. This room cannot be salvaged.")
				return
			if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				new /obj/structure/salvage/drone_spike(current_turf)
				qdel(src)
				return
			return

/obj/structure/salvage/intel_dropoff
	name = "OV-PST intelligence processor"
	desc = "A document scanner, at home in an office in the last century, combined with an LD-enabled processor."
	desc_lore = "Liquid Data enabled scanners utilize high speed data streams to not just scan the object but create a printable three-dimensional digital replica of it, down to the fine details. A full scan like this can take hours, so it's generally not recommended to do unless it's really needed, but even in its more basic mode, this device can be used to help Pythia extract information from physical sources."
	icon = 'icons/sectorpatrol/salvage/structures.dmi'
	icon_state = "intel_scanner"
	anchored = 1
	density = 1
	opacity = 0

/obj/structure/salvage/intel_dropoff/proc/process_intel(metal = null, resin = null, alloy = null)
	var/metal_to_rem = metal
	var/resin_to_rem = resin
	var/alloy_to_rem = alloy
	if(metal_to_rem) GLOB.salvaging_total_metal -= metal_to_rem
	if(resin_to_rem) GLOB.salvaging_total_resin -= resin_to_rem
	if(alloy_to_rem) GLOB.salvaging_total_alloy -= alloy_to_rem
	GLOB.salvaging_intel_items += 1
	return 1


/obj/structure/salvage/intel_dropoff/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/salvage/))
		var/obj/item/salvage/processed_item
		if (processed_item.salvage_intel_item == FALSE)
			to_chat(usr, SPAN_INFO("There does not seem to be anything important to process."))
			return
		if(process_intel(metal = processed_item.salvage_contents["metal"], resin = processed_item.salvage_contents["resin"], alloy = processed_item.salvage_contents["alloy"]) == 1)
			qdel(processed_item)
			return

// Extra gear: Pouches etc as needed

/obj/item/storage/pouch/document/uacm_salvage
	name = "UACM embroidered document satchel"
	desc = "A document pouch made from what feels like high quality synthetic fiber with the UACM logo visible on the top flap. Upon closer inspection, the logo is intricately embroidered into the fabric."
	desc_lore = "The pouches and in particular the embroidery were initially a product of an early prototype of what ultimately became the textile 'forges' of the Outer Veil PST, dedicated sectors on each of the stations wings that produce high quality textile-like materials and turn them into finished product, like this very pouch."
	storage_slots = 30
	max_storage_space = 30
	can_hold = list(
		/obj/item/salvage/document
	)

/obj/item/storage/pouch/uacm/salvage/left
	name = "UACM salvaging toolkit left-hand pouch"
	desc = "A pouch that can fit a few tools on a mounting clip that is slightly offset to the left."
	desc_lore = "UACM salvaging pouches come with a slight offset to the right or left to allow quick access of the tools contained within. In the UACM engineering handbook, 'left hand' tools are, in order: a screwdriver, wire cutters and a multitool. These pouches are sometimes called 'electronics helpers'."
	icon_state = "salvage_tools_l"
	storage_slots = 3
	max_storage_space = 3
	can_hold = list(
		/obj/item/tool/screwdriver/uacm,
		/obj/item/tool/wrench/uacm,
		/obj/item/tool/crowbar/uacm,
		/obj/item/tool/wirecutters/uacm,
		/obj/item/device/multitool/uacm,
		/obj/item/tool/drill/uacm
	)

/obj/item/storage/pouch/uacm/salvage/left/fill_preset_inventory()
	new /obj/item/tool/screwdriver/uacm
	new /obj/item/tool/wirecutters/uacm
	new /obj/item/device/multitool/uacm

/obj/item/storage/pouch/uacm/salvage/right
	name = "UACM salvaging toolkit left-hand pouch"
	desc = "A pouch that can fit a few tools on a mounting clip that is slightly offset to the right."
	desc_lore = "UACM salvaging pouches come with a slight offset to the right or left to allow quick access of the tools contained within. In the UACM engineering handbook, 'left hand' tools are, in order: a drill, a crowbar and a wrench. These pouches are sometimes called 'construction helpers'."
	icon_state = "salvage_tools_r"
	storage_slots = 3
	max_storage_space = 3
	can_hold = list(
		/obj/item/tool/screwdriver/uacm,
		/obj/item/tool/wrench/uacm,
		/obj/item/tool/crowbar/uacm,
		/obj/item/tool/wirecutters/uacm,
		/obj/item/device/multitool/uacm,
		/obj/item/tool/drill/uacm
	)

/obj/item/storage/pouch/uacm/salvage/right/fill_preset_inventory()
	new /obj/item/tool/drill/uacm
	new /obj/item/tool/crowbar/uacm
	new /obj/item/tool/wrench/uacm

/obj/item/device/flashlight/salvage
	name = "UACM high powered, blubless flashlight"
	desc = "A simple metal tube with a glass insert on one side revealing blue-tinted circuitry inside. Lights up with a clear, white light."
	desc_lore = "You may think that flashlights of all things would not really stand to be improved by LD technology, but one of the PST's designers would likely say that's not thinking outside the box. In this case, thinking outside the box means a flashlight that does not have any light bulb or similar lighting element and instead relies by the glow of a small orb filled with what looks like a swirling light-blue liquid. This liquid seems to be able to stimulate itself and produce natural light on-demand."
	light_range = 8
	raillight_compatible = FALSE
