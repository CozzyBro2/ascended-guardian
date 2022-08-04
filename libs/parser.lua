local Module = {}

local Config = require('config')

local function parsePrefix()

end

local function getArguments(Input)
    local Arguments = {}

    for Argument in Input:gmatch(Config.command_arg_seperator) do
        table.insert(Arguments, Argument)
    end

    return Arguments
end

function Module.parseCommand(Input)
    local Arguments = getArguments(Input)

    local NewArgs = {}
    local Flags = {}

    local Blacklist = {}

    for Index, Flag in ipairs(Arguments) do
        local IsFlag = Flag:sub(1, 1) == Config.command_flag_seperator

        if IsFlag then
            local IsOption = Flag:sub(1, 2) == Config.command_option_seperator
            local Value = true

            if IsOption then
                local ArgumentIndex, Argument = next(Arguments, Index)

                if Argument then
                    Blacklist[ArgumentIndex] = true

                    Value = Argument
                end
            end

            Blacklist[Index] = true
            Flags[Flag] = Value
        end

        if not Blacklist[Index] then
            table.insert(NewArgs, Flag)
        end
    end

    return NewArgs, Flags
end

return Module