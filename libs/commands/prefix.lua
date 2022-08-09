local Module = {}

local Subcommands = {}

local Config = require('config')

function Subcommands.change(Arguments, Flags, Message)
    local NewPrefix = Arguments[3] or Flags['--prefix']

    if NewPrefix then
        Config.command_prefix = NewPrefix

        require('config').writeConfig()
        require('parser').update()
        require('bot').update()
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