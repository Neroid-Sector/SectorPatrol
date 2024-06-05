GLOBAL_VAR_INIT(savefile_number, 0) //Savefile number reference. Should be set automatically by the persistance system. Tells it which save file is latest while loding/saving

//Round infopanel readout:

GLOBAL_VAR_INIT(ingame_location, "UACM OV-PST, Neroid Sector")
GLOBAL_VAR_INIT(ingame_date, "Unknown Date/Time")
GLOBAL_VAR_INIT(ingame_time, 0)
GLOBAL_VAR_INIT(ingame_mission_type, "Open Session")

//Persistancy lists
GLOBAL_LIST_EMPTY(turfs_saved) //turfs to be saved/loaded, ordered by xyz coordiates
GLOBAL_LIST_EMPTY(objects_saved) //objects to be saved/loaded, orderd by an index number

//Intro/Outro Text
GLOBAL_VAR_INIT(start_narration_header, "You are a commissioned officer in the UACM.")
GLOBAL_VAR_INIT(start_narration_body, "You are currently assigned to the <b>Second UACM Logistics Fleet</b>, under <b>RDML Thomas Boulette</b>. As part of the <b>Test Crews</b> operating out of the <b>Outer Veil Primary Supply Terminal</b>, you handle the testing and implementation of prototype technology and are responsible for <b>supply and logistics operations in the Outer Veil</b>.")
GLOBAL_VAR_INIT(start_narration_footer, "This is an Open Session without a general objective.")
GLOBAL_VAR_INIT(end_narration_header, "Interval Complete.")
GLOBAL_VAR_INIT(end_narration_body, "Thank you for participating in the Alpha of Sector Patrol!")

//Display Values for Statpanel/Reference

GLOBAL_VAR_INIT(resources_ldpol, 0)
GLOBAL_VAR_INIT(resources_metal, 0)
GLOBAL_VAR_INIT(resources_resin, 0)
GLOBAL_VAR_INIT(resources_alloy, 0)

// Salvaging resource tallies for grading and reference

GLOBAL_VAR_INIT(salvaging_total_ldpol, 0)
GLOBAL_VAR_INIT(salvaging_total_metal, 0)
GLOBAL_VAR_INIT(salvaging_total_resin, 0)
GLOBAL_VAR_INIT(salvaging_total_alloy, 0)
