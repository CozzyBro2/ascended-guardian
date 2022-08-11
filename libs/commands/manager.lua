local Module = {}

-- Aliases mapped to command names.
local CommandMap = {

    ping = require('./ping'),
    p = require('./ping'),

    prefix = require('./prefix'),

    player = require('./audio'),
    audio = require('./audio'),
    a = require('./audio'),

    voice = require('./vc'),
    vc = require('./vc'),
    v = require('./vc'),

}

Module.CommandMap = CommandMap

return Module