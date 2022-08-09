-- HashCollision 08/03/22

local Module = {}

local Config = require('config')

local PrefixName
local PrefixLen

-- Determine if the message is actually a command, based on the argument.
local function hasPrefix(Argument)
    local Prefix = Argument:sub(1, PrefixLen)

    if Prefix == PrefixName then
        return true
    end
end

-- Extract arguments from text.
local function getArguments(Input)
    local Arguments = {}
    local FoundPrefix = false

    for Argument in Input:gmatch(Config.command_arg_seperator) do
        -- If we need to get it, get prefix and set the command name to the part after the prefix.
        if not FoundPrefix then
            local IsPrefix = hasPrefix(Argument)

            if IsPrefix then
                local CommandName = Argument:sub(PrefixLen + 1)

                Arguments[1] = CommandName
                FoundPrefix = true
            end
        else
            -- Insert command name / command agument.

            table.insert(Arguments, Argument)
        end
    end

    return Arguments
end

-- Parse the command and return a tuple of Arguments & Flags with their values, or nil if not recognized as a command.
function Module.parseCommand(Input)
    if not hasPrefix(Input) then return end

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

-- Used to update the cached prefix information, call whenever you change the prefix.
function Module.update()
    PrefixName = Config.command_prefix
    PrefixLen = string.len(PrefixName)
end

-- Called on bot setup.
function Module.init()
    Module.update()
end

return Module