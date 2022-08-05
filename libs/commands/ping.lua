local Module = {}

local Luv = require('uv')

function Module.run(Arguments, Flags, Message)
    Message:addReaction("🏓")
end

-- Called on bot setup.
function Module.init()

end

return Module