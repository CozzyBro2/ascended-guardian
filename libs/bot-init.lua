-- HashCollision 08/03/22

local Module = {}

-- List of modules to be initialized.
local init_list = {

    'parser',
    'commands/kill',

}

-- Run any tasks needed for the setup of the bot.
function Module.init()
    for _, Name in pairs(init_list) do
        local ToInit = require(Name)

        ToInit.init()
    end
end

return Module