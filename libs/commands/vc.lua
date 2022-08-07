local Module = {}

local Subcommands = {}

local Config = require('config')

function Subcommands.join(Arguments, Flags, Message)
    local IdFromFlag = Arguments[3] or Flags['--id']
    local Channel

    if tonumber(IdFromFlag) then
        Channel = Message.guild:getChannel(IdFromFlag)
    else
        Channel = Message.guild:getMember(Message.author).voiceChannel
    end

    if not Channel then
        Message:addReaction(Config.command_problem)

        return Message:reply("You're not in a vc, or could not find the channel you specified")
    end

    Channel:join()
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

Subcommands.hopon = Subcommands.join
Subcommands.enter = Subcommands.join
Subcommands.e = Subcommands.join
Subcommands.j = Subcommands.join

return Module