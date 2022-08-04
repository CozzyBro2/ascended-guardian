local Module = {}

-- Aliases mapped to command names.
local CommandMap = {

    ping = require('./ping'),
    p = require('./ping'),

}

Module.CommandMap = CommandMap

return Module