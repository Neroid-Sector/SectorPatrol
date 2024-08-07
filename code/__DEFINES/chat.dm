/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

#define MESSAGE_TYPE_SYSTEM "system"
#define MESSAGE_TYPE_LOCALCHAT "localchat"
#define MESSAGE_TYPE_RADIO "radio"
#define MESSAGE_TYPE_HIVEMIND "hivemind"
#define MESSAGE_TYPE_INFO "info"
#define MESSAGE_TYPE_WARNING "warning"
#define MESSAGE_TYPE_DEADCHAT "deadchat"
#define MESSAGE_TYPE_OOC "ooc"
#define MESSAGE_TYPE_ADMINPM "adminpm"
#define MESSAGE_TYPE_COMBAT "combat"
#define MESSAGE_TYPE_ADMINCHAT "adminchat"
#define MESSAGE_TYPE_MODCHAT "modchat"
#define MESSAGE_TYPE_MENTOR "mentor"
#define MESSAGE_TYPE_STAFF_IC "staff_ic"
#define MESSAGE_TYPE_EVENTCHAT "eventchat"
#define MESSAGE_TYPE_ADMINLOG "adminlog"
#define MESSAGE_TYPE_ATTACKLOG "attacklog"
#define MESSAGE_TYPE_DEBUG "debug"
#define MESSAGE_TYPE_TERMINAL "terminal"
#define MESSAGE_TYPE_LABELS "labels"
#define MESSAGE_TYPE_NICHE "niche"

/// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define examine_block(str) ("<div class='examine_block'>" + str + "</div>")

// Role Display
#define role_header(str) ("<div class='role_header'><p>" + str + "</p></div>")
#define role_body(str) ("<div class='role_body'><p>" + str + "</p></div>")

// Global Narrate
#define narrate_head(str) ("<div class='narrate_head'><p>" + str + "</p></div>")
#define narrate_body(str) ("<div class='narrate_body'><p>" + str + "</p></div>")

// Console outputs

#define narrate_console(str) ("<div class='narrate_console'><p>" + str + "</p></div>")

