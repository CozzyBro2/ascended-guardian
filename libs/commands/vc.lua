local Module = {}

local Subcommands = {}

local Config = require('config')
local ConnectionsMap = {}

local Manager

function Subcommands.join(Arguments, Flags, Message)
    local IdFromFlag = Arguments[3] or Flags['--id']
    local GuildId = Message.guild.id

    local Channel

    if ConnectionsMap[GuildId] then
        Subcommands.leave(Arguments, Flags, Message)
    end

    if tonumber(IdFromFlag) then
        Channel = Message.guild:getChannel(IdFromFlag)
    else
        Channel = Message.guild:getMember(Message.author).voiceChannel
    end

    if not Channel then
        error("You're not in a vc, or could not find the channel you specified", 0)
    end

    Manager:join(Channel)
end

function Subcommands.leave(_, _, Message)
    local Channel = Message.guild.me.voiceChannel

    if not Channel then
        Message:addReaction(Config.command_problem)

        return Message:reply("I don't appear to be in a voice channel.")
    end

    Manager:leave(Channel)
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
    Manager = require('bot').VoiceManager

    require('./audio').update()
end

Subcommands.hopon = Subcommands.join
Subcommands.enter = Subcommands.join
Subcommands.e = Subcommands.join
Subcommands.j = Subcommands.join

Module.ConnectionsMap = ConnectionsMap

return Module