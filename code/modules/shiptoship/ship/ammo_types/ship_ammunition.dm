/obj/structure/ship_elements/missile_ammo/missile_homing
	name = "UACM \"Hunter\" Missile"
	desc = "A medium sized missile painted in a very characteristic orange, without a warhead in a protective transport clamp."
	desc_lore = "Hunter missiles were designed on the OV-PST from the ground up and unlike other Mission Control-bound devices which are adaptations of existing technology contains components designed on and produced only on the PST. Unlike conventional homing missiles which fly towards their destination, then launch a short-range homing warhead, the PST homing missile is imprinted with an LD energy signature of its target which the missile actively re-homes towards during its journey."
	icon = 'icons/sectorpatrol/ship/weapon_ammo64.dmi'
	icon_state = "missile_pst_homing"
	missile_type = "LD Homing"
	bound_width = 64
	bound_height = 32
	element_value = 20

/obj/structure/ship_elements/missile_ammo/missile_dumbfire
	name = "Modified UACM \"Panther\" Missile"
	desc = "A small missile with most of its internal systems taken out, secured in protective clamps. Does not have a warhead."
	desc_lore = "Panther missiles are already the fastest UACM projectile, but the models made compatible with the PST's Mission Control system tap into the PSTs energy reserves and push it closer to TWE close-combat rockets which currently hold the crown in that specific performance category. The sacrifice here is the lack of a homing system or any other supplementary guidance. This device is almost literally just an LD engine carrying a warhead."
	icon = 'icons/sectorpatrol/ship/weapon_ammo64.dmi'
	icon_state = "missile_pst_dumbfire"
	missile_type = "Direct"
	bound_width = 64
	bound_height = 32
	element_value = 40

/obj/structure/ship_elements/missile_ammo/missile_torpedo
	name = "Modified UACM \"Inferno\" Torpedo"
	desc = "A massive projectile with what looks like a pair of LD power storage devices attached to it. It's secured by a protective clamp and does not have a warhead attached."
	desc_lore = "Meant for striking space stations, disabled, or larger ships, the Inferno sees use mostly on bigger capital ships during planetary sieges. The PST modified; Mission Control enabled variant attaches a Liquid Data power spooling device to the projectile which accumulates more energy with each successive LD leapfrog, which is then fed back into the torpedoes systems, increasing both its payload and speed. Essentially, the longer this projectile files, the faster it gets and the harder it hits, regardless of attached warhead."
	icon = 'icons/sectorpatrol/ship/weapon_ammo64.dmi'
	icon_state = "missile_pst_torpedo"
	missile_type = "Accelerating Torpedo"
	bound_width = 64
	bound_height = 32
	element_value = 5

/obj/structure/ship_elements/missile_ammo/warhead_direct
	name = "Standard warhead"
	desc = "A while tipped metal warhead resembling a bullet. An extremely common sight on spaceships."
	desc_lore = "The classic direct damage warhead follows a design principle that's older than space travel itself. Upon release from its delivery system, this warhead makes one final leapfrog jump towards its target, primes, and detonates a shaped charge that focuses all its energy forward. Should this projectile fully penetrate a ship's hull, the resulting explosion is typically enough to cripple the ship."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "warhead_direct"
	warhead_type = "Direct"
	bound_width = 32
	bound_height = 32
	element_value = 3

/obj/structure/ship_elements/missile_ammo/warhead_splash
	name = "Explosive warhead"
	desc = "An extremely heavy metal egg, painted in crimson red."
	desc_lore = "This warhead consists of a hard metal outer shell, an explosive charge shaped to focus its energy outward and a small scale, pre-charged Twilight Paradox Hyperspace device hidden away inside a hard, protective core. Upon reaching their destination and release from their delivery method, this warhead detonates its charge which shatters the outer core and creates a small shrapnel field. The TD device then is overloaded from its battery, crating an unstable Hyperspace rift that charges the shrapnel with latent Twilight energy and sends it barreling towards any vessel or projectile utilizing Twilight Paradox systems. The closer a given object is to the rift; the more shrapnel are attracted towards it. The shrapnel explode on contact."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "warhead_explosive"
	warhead_type = "Explosive"
	bound_width = 32
	bound_height = 32
	element_value = 2

/obj/structure/ship_elements/missile_ammo/warhead_mip
	name = "Prototype MIP warhead"
	desc = "A warhead made from a mixture of metal alloys and hardened resin, coated in dark blue."
	desc_lore = "MIP, or Multiple Independent Projectiles is one of the first weapons fully realized on board the PST, from design to prototyping. Upon reaching its destination, this warhead utilizes its link to the OV-PST's Mission Control system and utilizes its energy reserves to shape and send three smaller versions of itself from premade resources, its own hull and a prepackaged set of explosive cores. The projectiles then all independently track and strike their target, or home in and strike any target they can find depending on their programming. The utility of this missile is severely limited by the fact that the PST's systems are not able to reproduce organic, explosive compounds and as such must rely on premade, limited resources, however PST engineers are optimistic that with practical use they and Mission Control can design around this issue."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "warhead_mip"
	warhead_type = "MIP"
	bound_width = 32
	bound_height = 32
	element_value = 3

/obj/item/ship_elements/secondary_ammo/direct
	name = "prepackaged box of Type-S \"Direct\" ammunition"
	desc = "A large box with multiple rows of high caliber ammunition with green colored tips."
	desc_lore = "The design idea behind this type of ammo follows a classic idea - a sharpened mixture of metals that aims to penetrate anything it hits. This method of combat was unfeasible in the distances typical spaceship combat takes place in and only with the PST's Mission Control system, specifically its hyper accuracy, guaranteeing a virtually 100 percent hit rate, can it potentially make a comeback."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "secondary_direct"
	ammo_type = "direct"

/obj/item/ship_elements/secondary_ammo/flak
	name = "prepackaged box of Type-S \"Flak\" ammunition"
	desc = "A large box with multiple rows of high caliber ammunition with red colored tips."
	desc_lore = "Flak ammunition utilizes a localized LD rift shaped and maintained by the PST's Mission Control system to supercharge and send the ammo through an unstable LD rift, much like the shrapnel of explosive missile warheads. This method of delivery is only possible due to the Mission Control system's unusual energy capabilities, but the result is a reliable, short range large area clearing tool. Care must be utilized while targeting this type of ammunition, as the LD rift charged ammo will strike its origin point as much as any other target in its area."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "secondary_flak"
	ammo_type = "flak"

/obj/item/ship_elements/secondary_ammo/broadside
	name = "prepackaged box of Type-S \"Broadside\" ammunition"
	desc = "A large box with multiple rows of high caliber ammunition with yellow colored tips."
	desc_lore = "Broadside ammunition follows a design idea laid out by Mission Control and as such is one of the first devices in human hands which was designed for human use by a non-human. Broadside ammunition uses a targeted, short range Hyperspace field that is calibrated and targeted by the Mission Control system. Due to the systems unique compatibility with Hyperspace based computations, unique LD enhanced polymers used during production of the ammunition and the Type-S cannons natural accuracy, Broadside projectiles are delivered directly inside or on top of their targets, then detonate immediately causing massive internal damage."
	icon = 'icons/sectorpatrol/ship/weapon_ammo.dmi'
	icon_state = "secondary_broadside"
	ammo_type = "broadside"
