//Airlocks

/obj/structure/salvage/airlock
	name = "airlock"
	desc = "A heavy metal door that slides and locks into place when opened from a nearby terminal."
	desc_lore = "Airlocks, as the name suggests, are essentially what doors are to spacers. Typically opened remotely via a control panel next to them, but most with some sort of emergency release, these separate major 'rooms' in a ship from each other, forming protective, airtight seals if needed."
	desc_lore_affix = "A standard airlock is most likely going to have a fair share of metal and alloys, with some resins as well. It's generally advised to just salvage an airlock to gain entry to a closed off area if such a need arises."
	icon = 'icons/sectorpatrol/salvage/turfs/doors.dmi'
	icon_state = "door_1"
	salvage_decon_keyword = "AECBBADB"
	var/width = 1

/obj/structure/salvage/airlock/Initialize(mapload, ...)
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/structure/salvage/airlock/double
	icon = 'icons/sectorpatrol/salvage/turfs/doors64.dmi'
	icon_state = "door_1"
	width = 2

// Heavy Machinery

/obj/structure/salvage/heavy_machinery
	name = "heavy machinery"
	desc_affix = "It is a heavy machine that looks like it will require quite a bit of work to prepare it for salvaging."
	desc_lore_affix = "Heavy machinery is exceedingly common on spaceships and typically includes ships' engines, power systems, computer hardware, manufacturing and dispensing equipment. These machines will typically require all your attention while preparing them for scrap and should yield high amounts of resources when salvaged correclty."
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/computer_hardware.dmi'
	salvage_decon_keyword = "FBEACDDBABDB"
	salvage_big_item = 1
	salvage_contents = list(
	"metal" = 25,
	"resin" = 5,
	"alloy" = 20,
	)

/obj/structure/salvage/heavy_machinery/comp_hardware
	name = "computer hardware"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/computer_hardware.dmi'
	icon_state = "hadrware_1"
	desc = "A disabled computer tower with some status indicators, but no visible functional keyboard or monitor."
	desc_lore = "Computer hardware on ships typically means parts of computer systems that are not meant to be interacted with directly and have no input/output terminals on them by default. These are typically computer cores or other supplementary hardware, or elements of the ships AI system. They typically yield more alloys and resins than most heavy machines."
	salvage_contents = list(
	"metal" = 15,
	"resin" = 20,
	"alloy" = 15,
	)

/obj/structure/salvage/heavy_machinery/comm_hardware
	name = "communications hardware"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/comms_hardware.dmi'
	icon_state = "comms_1"
	desc = "Disabled communications equipment, which seems to have already been partially disassembled."
	desc_lore = "Communications equipment on ships typically contains Liquid Data, which means that this piece of hardware was likely scrubbed already by UAAC-TIS operatives. Still, it is likely to remain a good source of resins, typically the highest output among all machinery."
	salvage_contents = list(
	"metal" = 10,
	"resin" = 35,
	"alloy" = 5,
	)

/obj/structure/salvage/heavy_machinery/terminals
	name = "computer hardware"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/terminals.dmi'
	icon_state = "terminal_1"
	desc = "A disabled computer tower with a clearly visible data output and input device."
	desc_lore = "Like their terminal-less counter parts, these devices are usually diagnostic and servicing input and output stations for the hardware clusters they are connected to. While most end-user output is typically displayed on smaller terminals, these devices are indispensable to the people who try their best to keep the ship running. They typically yield more alloys and resins than most heavy machines."
	salvage_contents = list(
	"metal" = 20,
	"resin" = 10,
	"alloy" = 20,
	)

/obj/structure/salvage/heavy_machinery/atmos
	name = "atmosphere control machinery"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/atmos.dmi'
	icon_state = "atmos_1"
	desc = "A machine typically connected somewhere to the atmospherics control system on the ship. "
	desc_lore = "Atmospherics heavy machines are typically air warmers, air coolers and the diagnostic equipment that controls them. These machines keep the ship warm or cool it down as needed or are used to store and measure local atmospheric information to maintain a healthy environment on the ship. They share yields with other heavy machines."

/obj/structure/salvage/heavy_machinery/dispensers
	name = "dispenser"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/dispensers.dmi'
	icon_state = "dispenser_1"
	desc = "An automated dispenser with a numeric button input visible on the side. It does not appear to be working. "
	desc_lore = "As the name implies, dispensers are used for storage, keeping inventory and, yes, dispensing a whole variety of items from food and tools to armor and weapons. Yields same resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/generators/gen_2
	name = "generation 2 Twilight Paradox power generator"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/generators.dmi'
	icon_state = "gen_1"
	desc = "A Twilight Paradox power generator without a visible rechargeable cell port. Seems to be offline."
	desc_lore = "Second generation Twilight Paradox generators are the most common power generator among both spaceships and space-based facilities. These models are encased in heavy shielding that evolved as Twilight Paradox became more understood, unfortunately this means that the power cell is not removable and in the case of malfunction or regular wear, the whole generator would need to be replaced. Has a balanced ratio of resins, metals and alloys and yields slightly more than a typical heavy machine."
	salvage_contents = list(
	"metal" = 25,
	"resin" = 25,
	"alloy" = 25,
	)

/obj/structure/salvage/heavy_machinery/generators/gen_3
	name = "generation 3 Twilight Paradox power generator"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/generators.dmi'
	icon_state = "gen_2"
	desc = "A Twilight Paradox power generator with a visible rechargeable cell port. Seems to be offline."
	desc_lore = "Third generation Twilight Paradox generators are considered top of the line and its presence on a ship indicates that the ship was most likely modernized or built in the last twenty years or so. The weight of the shielding has been considerably reduced and the power cell is now replaceable, meant to work in tandem with Twilight Paradox rechargers for extra power reserves and a longer lifespan of the generator. Yields mostly resins and alloys, and more resources than the average piece of heavy machinery."
	salvage_contents = list(
	"metal" = 5,
	"resin" = 35,
	"alloy" = 35,
	)

/obj/structure/salvage/heavy_machinery/kitchen
	name = "kitchen hardware"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/kitchen.dmi'
	icon_state = "kitchen_1"
	desc = "A piece of heavy kitchen hardware, most likely some sort of food processor."
	desc_lore = "Maintaining a healthy diet has a notable effect on the amount of instability incidents during long term voyages, which is why most ships typically have a dedicated kitchen area where food is prepared from as close to scratch as possible. As such, heavier machinery like grinders and food processors is often utilized. This is to supplement, and not replace the standard pre-prepared rations. Yields same amount of resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/morgue
	name = "morgue heavy equipment"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/morgue.dmi'
	icon_state = "morgue_1"
	desc = "A slab which can be used to store a body that can be extended and slid into a storage or incineration chamber."
	desc_lore = "While great strides have been made, especially after the Colony Wars, in terms of guaranteeing the safety of personnel on board of spaceships, death in space remains an all to common reality of any spaceship crew and should the worst happen, these machines help the crew manage and process any human remains on the ship. Yields same resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/generators/portable_gen
	name = "portable emergency power generator"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/portable_gen.dmi'
	icon_state = "generator_2"
	desc = "An emergency power generator, typically using a pre-charged energy cell or organic fuel source."
	desc_lore = "Prolonged loss of power on a ship, especially one during a hyperspace jump, spells certain doom for its entire crew. The dark reaches of space seem to consume all matter in a process that has so far defied any scientific explanation. What is certain however is that keeping the lights up while repairs are made is one of the key factors deciding whether a crew has a fighting chance to overcome whatever issue depowered their ship before the void drains the ship of light and life. Yields same resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/production
	name = "production hardware"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/production.dmi'
	icon_state = "prod_4"
	desc = "A lathe, 3d printer or otherwise a piece of heavy equipment used to manufacture simple or complex machines from basic components. "
	desc_lore = "From the earliest days of interstellar space travel, due to the extremely haphazard practical applications of early Twilight Paradox technology, equipment failure remains the most common reason for loss of life on board of space faring ships and installations. Over time, apart from carrying a stock of replacement parts, most ships started to operate part manufacturers so, in case of a real emergency, patchwork replacement parts can be manufactured on-site. Yields same resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/recharger
	name = "recharging station"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/recharger.dmi'
	icon_state = "recharger_2"
	desc = "A machine adorned with wires with a visible entrance chamber or slot."
	desc_lore = "Machines like these are used to recharge power cells and synthetic units during Hyperspace jumps utilizing the effectively constant Twilight Paradox conditions that exist in that form of reality. This property of Hyperspace, along with these devices and their predecessors, are one of the bases of modern interstellar travel, guaranteeing that even the most basic of spaceships can complete a Hyperspace jump and arrive on a different planet safely. Yields more resins at the cost of metals than a regular piece of heavy machinery."

	salvage_contents = list(
	"metal" = 15,
	"resin" = 15,
	"alloy" = 20,
	)


/obj/structure/salvage/heavy_machinery/sleeper
	name = "sleeper bed"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/sleepers.dmi'
	icon_state = "sleeper_1"
	desc = "A comfortable looking bed encased in an airtight looking metal and glass cover. Typically comes with a display panel and keypad attached somewhere at its front."
	desc_lore = "Most commonly used on older spaceships as means of protecting its crews against long term Hyperspace exposure (which often leads to Crystaline infections of both internal and external organs and a painful death death) and as medical devices, these devices are mean to seal a humanoid inside, typically after sedation, and perform some specific task once the person is safely inside while offering external monitoring of their vitals. Yields more resins at the cost of metals than a regular piece of heavy machinery"

	salvage_contents = list(
	"metal" = 15,
	"resin" = 15,
	"alloy" = 20,
	)

/obj/structure/salvage/heavy_machinery/washer

	name = "washing machine"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/wm.dmi'
	icon_state = "wm_1"
	desc = "An alloy drum inside a metal container, consolidating both a washer and a dryer in one device."
	desc_lore = "While the exact psychological mechanism behind it remains a mystery, there is a generally accepted link between crews maintaining a high standard of cleanliness and hygiene, especially during long trips, and the number of mental episodes that Spacers are somewhat infamous for. As such, most ships use machines such as these to help crews stay clean and sane. Yields same resources as an average piece of heavy machinery."

/obj/structure/salvage/heavy_machinery/smes
	name = "smes device"
	icon = 'icons/sectorpatrol/salvage/heavy_machinery/smes.dmi'
	icon_state = "smes_1"
	desc = "A cluster of ring-shaped batteries stacked on top of each other, with a set of displays and dials hidden behind a panel on the front."
	desc_lore = "The SMES, or the Standardized Modular Energy Storage is essentially multiple high-capacity Twilight Paradox energy cores connected to the ships power grid and accumulating passive charge during any Hyperspace jump. SMES devices are used on space stations and during long term deployments, along with quick leapfrog 'recharger' jumps within the same solar system, to help keep its spaceship or station operational while stationary. Yields mostly resins and alloys."
	salvage_contents = list(
	"metal" = 5,
	"resin" = 20,
	"alloy" = 25,
	)

//Small machinery/electronics/wall ceilign stuff

/obj/structure/salvage/small_machinery
	name = "small machinery"
	desc_affix = "A small machine, computer or other electronic device or any other object that cannot be easily carried, either due to its assembly or mounting."
	desc_lore_affix = "These devices include any computer or electronic device, or any other object that cannot be easily carried and has some form of electronic circuitry inside requiring preparation before salvaging."
	icon = 'icons/sectorpatrol/salvage/small_machinery/computers.dmi'
	icon_state = "default"
	salvage_decon_keyword = "ABEBCD"
	salvage_contents = list(
	"metal" = 15,
	"resin" = 5,
	"alloy" = 10,
	)

/obj/structure/salvage/small_machinery/computer
	name = "computer"
	desc = "A computer or similar device, with a clearly visible data output and input method."
	desc_lore = "Computers big and small are extremely common on spaceships and can be used to both interact with specific systems of the ship as well as run an operating system with a more general application. Yields the same ammount of resources as a typical small machine."
	icon = 'icons/sectorpatrol/salvage/small_machinery/computers.dmi'
	icon_state = "computer_2"

/obj/structure/salvage/small_machinery/hanging
	name = "celing mounted device"
	desc = "An electronic device attached to or near the ceiling of the ship."
	desc_lore = "Loudspeakers or cameras that are attached near or directly to 'ceilings' on ships. These devices typically yield less than an average small machine, but the resource types remain in balance. They also do not require using a multitool as part of the perparation process."
	icon = 'icons/sectorpatrol/salvage/small_machinery/hanging.dmi'
	icon_state = "hanging_1"
	salvage_decon_keyword = "ABBC"
	salvage_contents = list(
	"metal" = 5,
	"resin" = 5,
	"alloy" = 5,
	)

/obj/structure/salvage/small_machinery/kitchen
	name = "kitchen appliance"
	desc = "A small device used in preparation or cooking of food."
	desc_lore = "Maintaining a healthy diet has a notable effect on the amount of instability incidents during long term voyages, which is why most ships typically have a dedicated kitchen area where food is prepared from as close to scratch as possible. In their spare time, crew are typically encouraged to take the extra time it takes to use devices like those to cook a proper meal. Yields the same ammount of resources as a typical small machine."
	icon = 'icons/sectorpatrol/salvage/small_machinery/kitchen.dmi'
	icon_state = "kitchen_2"

/obj/structure/salvage/small_machinery/medical
	name = "medical device"
	desc = "A medical device with a significant electrical or electronic component."
	desc_lore = "Ship medbays typically link most of their equipment to the on-board AI so that the computer can monitor levels and alert them of shortages. As such, most medical equipment that cannot be easily picked up carries electronic devices that need to be prepared for salvage"
	icon = 'icons/sectorpatrol/salvage/small_machinery/medical.dmi'
	icon_state = "medical_1"

/obj/structure/salvage/small_machinery/office
	name = "office electronics"
	desc = "A piece of office equipment."
	desc_lore = "Scanners, faxes linked to the LD network and other such devices are typically first handled by the UAAC-TIS due to the information they may have stored in their buffer and a chance that they have LD components. Yields more resins and alloys at the cost of metals."
	icon = 'icons/sectorpatrol/salvage/small_machinery/office.dmi'
	icon_state = "office_1"
	salvage_contents = list(
	"metal" = 5,
	"resin" = 10,
	"alloy" = 15,
	)

/obj/structure/salvage/small_machinery/wall_displays
	name = "wall-mounted display"
	desc = "A display monitor mounted on the wall."
	desc_lore = "Hyperspace ruins most computer displays, which is essentially why most of space travel is done by looking at a green, text only display, even one hundred years into the age of space travel. Larger displays such as these typically retain enough integrity over jumps that they can be used with some graphic elements, but they are also notoriously loud and buggy. Yields mostly alloys with some resins and no metal."
	icon = 'icons/sectorpatrol/salvage/small_machinery/wall_displays.dmi'
	icon_state = "wall_displays_1"
	salvage_contents = list(
	"metal" = 0,
	"resin" = 5,
	"alloy" = 25,
	)

/obj/structure/salvage/small_machinery/wall_electronics
	name = "wall-mounted electronic device"
	desc = "A small terminal, button, display or some other device attached to the wall controlling a nearby aspect of the ship."
	desc_lore = "Switches, buttons, levers, small wall mounted displays and status controls, atmospheric dan power controls for rooms all fall into this category. They are easier to dismantle than the typical small electronic but yield a bit less materials at the cost of metals."
	icon = 'icons/sectorpatrol/salvage/small_machinery/wall_electronics.dmi'
	icon_state = "wall_electronics_1"
	salvage_decon_keyword = "AEBD"
	salvage_contents = list(
	"metal" = 0,
	"resin" = 10,
	"alloy" = 10,
	)

/obj/structure/salvage/small_machinery/wall_electronics/lights
	name = "wall-mounted light"
	desc = "A light tube or bulb attached to a fixture on the wall."
	desc_lore = "While there are definite benefits to having a well-lit ship as far as crew morale is concerned, the main reason most ship engineers rigorously make sure all lights are up to snuff is the consequences of lacking light in case of a power related emergency in deep space. These fixtures typically require just one step to prepare for salvaging but yield only trace amounts of alloys and metals."
	icon = 'icons/sectorpatrol/salvage/small_machinery/lights.dmi'
	icon_state = "default"
	salvage_decon_keyword = "FD"
	salvage_contents = list(
	"metal" = 5,
	"resin" = 0,
	"alloy" = 5,
	)

/obj/structure/salvage/small_machinery/wall_electronics/lights/tube
	icon_state = "tube"
	icon_state_max = 4

/obj/structure/salvage/small_machinery/wall_electronics/lights/bigtube
	icon_state = "bigtube"
	icon_state_max = 4

/obj/structure/salvage/small_machinery/wall_electronics/lights/bulb
	icon_state = "bulb"
	icon_state_max = 3

/obj/structure/salvage/locker
	name = "storage container"
	desc = "A container used to store other items."
	desc_lore = "There is always a need for storage space to keep items big and small where you can find them easily. The container should reveal its contents once it's prepared for salvaging. Typically, is made from only resins."
	icon = 'icons/sectorpatrol/salvage/lockers/lockers.dmi'
	icon_state = "locker_3"
	icon_opens = 'icons/sectorpatrol/salvage/lockers/lockers_o.dmi'
	salvage_decon_keyword = "FBDB"
	salvage_contents = list(
	"metal" = 0,
	"resin" = 20,
	"alloy" = 0,
	)

/obj/structure/salvage/locker/crate
	icon_opens = null
	icon = 'icons/sectorpatrol/salvage/lockers/crates.dmi'
	icon_state = "crate_6"
	salvage_decon_keyword = "BB"
	salvage_contents = list(
	"metal" = 0,
	"resin" = 10,
	"alloy" = 0,
	)

/obj/structure/salvage/locker/crate/random
	icon_state = "crate"
	name = "storage container"
	icon_state_max = 22

/obj/structure/salvage/locker/crate/random/barrels
	icon_state_min = 1
	icon_state_max = 5

/obj/structure/salvage/locker/crate/random/wooden
	icon_state_min = 6
	icon_state_max = 9

/obj/structure/salvage/locker/crate/random/black_case
	icon_state_min = 10
	icon_state_max = 15

/obj/structure/salvage/locker/crate/random/assort
	icon_state_min = 16


/obj/structure/salvage/furniture
	name = "furniture"
	desc = "A surface to put things on, including yourself. Simple and effective"
	desc_lore = "Tables, chairs and other furniture are typically manufactured by the ships themselves and while the NRPS is slowly catching on, there is no real consistency in assembly and used mounts and tools. Furniture is typically made of resins and some metals and does not contain any alloys."
	icon = 'icons/sectorpatrol/salvage/furniture/table.dmi'
	icon_state = "table_4"
	salvage_decon_keyword = "ABBD"
	salvage_contents = list(
	"metal" = 5,
	"resin" = 10,
	"alloy" = 0,
	)

/obj/structure/salvage/furniture/chair

	icon = 'icons/sectorpatrol/salvage/furniture/chair.dmi'
	icon_state = "chair_1"
	salvage_contents = list(
	"metal" = 5,
	"resin" = 10,
	"alloy" = 0,
	)

/obj/structure/salvage/toilet
	name = "toilet implement"
	desc = "A bathroom item with an obvious use. Does not currently work."
	desc_lore = "Personal hygiene is a contributing factor to mental issues that notoriously plague Spacers and as such, most ships try to provide at least a basic shower and toilet for every crew member, as well as imposing mandatory showers on some ships. Due to their constant exposure to moisture, these objects have trace amount of alloys along with resins, but no metals. "
	icon = 'icons/sectorpatrol/salvage/toilet/toilet.dmi'
	icon_state = "toilet_1"
	salvage_decon_keyword = "BDDD"
	salvage_contents = list(
	"metal" = 0,
	"resin" = 10,
	"alloy" = 5,
	)
