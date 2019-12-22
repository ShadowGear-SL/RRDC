// [SGD] RRDC Leash Handle v0.1 - Copyright 2019 Alex Pascal (Alex Carpenter) @ Second Life.
// ---------------------------------------------------------------------------------------------------------
// This Source Code Form is subject to the terms of the Mozilla Public License, v2.0. 
//  If a copy of the MPL was not distributed with this file, You can obtain one at 
//  http://mozilla.org/MPL/2.0/.
// =========================================================================================================

// Modifiable Variables.
// ---------------------------------------------------------------------------------------------------------
integer g_appChan           = -89039937;        // The channel for this application set.
// ---------------------------------------------------------------------------------------------------------

// getAvChannel - Given an avatar key, returns a static channel XORed with g_appChan.
// ---------------------------------------------------------------------------------------------------------
integer getAvChannel(key av)
{
    return (0x80000000 | ((integer)("0x"+(string)av) ^ g_appChan));
}

default
{
    // Initialize the script.
    // -----------------------------------------------------------------------------------------------------
    state_entry()
    {
        llSetMemoryLimit(llGetUsedMemory() + 512);
        llListen(getAvChannel(llGetOwner()), "", "", ""); // Open collar/cuffs avChannel.
    }

    // Listen for link requests.
    // -----------------------------------------------------------------------------------------------------
    listen(integer chan, string name, key id, string mesg)
    {
        if (llGetOwnerKey(id) != id) // Process RRDC commands.
        {
            list l = llParseString2List(mesg, [" "], []); // Match tag and command.
            if (llList2String(l, 1) == "leashanchor" && llList2String(l, 0) == "linkrequest")
            {
                llWhisper(getAvChannel(llGetOwnerKey(id)), "link " + // Send link message back.
                    llList2String(l, 3) + " " +
                    llList2String(l, 4) + " " + (string)llGetKey()
                );
            }
        }
    }
}
