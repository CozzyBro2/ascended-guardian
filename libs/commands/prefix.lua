local Module = {}

local Subcommands = {}

local Config = require('config')

local invalid_length_format = 'Command prefix cannot be over %d characters long'

local prefix_length_limit = 5

function Subcommands.change(Arguments, Flags, Message)
    local NewPrefix = Arguments[3] or Flags['--prefix']

    if NewPrefix then
        local Len = NewPrefix:len()

        if Len > prefix_length_limit then
            error(invalid_length_format:format(prefix_length_limit), 0)
        end

        if NewPrefix:match('%s') then
            error('Command prefix cannot have spaces in it', 0)
        end

        if Len ~= utf8.len(NewPrefix) then
            error('Command prefix must be a plain old string, no emoji, etc.', 0)
        end

        Config.command_prefix = NewPrefix

        require('config').writeConfig()
        require('parser').update()
        require('bot').update()

        Message:addReaction(Config.command_success)
    end
end

function Module.run(Arguments, Flags, Message)
    local SubcommandName = Arguments[2] or 'change'
    local Subcommand = Subcommands[SubcommandName]

    if Subcommand or SubcommandName == nil then
        Subcommand(Arguments, Flags, Message)
    else
        error(Config.subcommand_invalid:format(SubcommandName, Arguments[1]), 0)
    end
end

return Module