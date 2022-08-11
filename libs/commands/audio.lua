local Module = {}

local Subcommands = {}

local Config = require('config')
local Voice = require('./vc')

local ConnectionsMap

function Subcommands.play(Arguments, Flags, Message)
    local Manager = ConnectionsMap[Message.guild.id]

    print(Manager)
end

function Module.run(Arguments, Flags, Message)
    local SubcommandName = Arguments[2] or 'join'
    local Subcommand = Subcommands[SubcommandName]

    if Subcommand or SubcommandName == nil then
        Subcommand(Arguments, Flags, Message)
    else
        error(Config.subcommand_invalid:format(SubcommandName, Arguments[1]), 0)
    end
end

function Module.update()
    ConnectionsMap = Voice.ConnectionsMap
end

Subcommands.play = Subcommands.play
Subcommands.p = Subcommands.play
Subcommands.start = Subcommands.play

return Module