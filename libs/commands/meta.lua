local Module = {}

-- Aliases mapped to command names.
local CommandMap = {

    ping = require('./ping'),
    p = require('./ping'),

    kill = require('./kill'),
    k = require('./kill'),

}

Module.CommandMap = CommandMap

return Module