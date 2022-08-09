local Module = {}

local Subcommands = {}

local Config = require('config')
local Lavalink = require('discordia-lavalink')

local VoiceManager = Lavalink.VoiceManager

local LavalinkNodes = {
	{
        host = '127.0.0.1',
        port = 2333,
        password = 'polyphiagoatisagreatdemonstrationofguitarskill'
    }
}

local ActiveManager

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

    ActiveManager:join(Channel)
end

function Subcommands.leave(_, _, Message)
    local Channel = Message.guild.me.voiceChannel

    if not Channel then
        Message:addReaction(Config.command_problem)

        return Message:reply("I don't appear to be in a voice channel.")
    end

    ActiveManager:leave(Channel)
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

function Module.update(Bot)
    ActiveManager = VoiceManager(Bot, LavalinkNodes)
end

Subcommands.hopon = Subcommands.join
Subcommands.enter = Subcommands.join
Subcommands.e = Subcommands.join
Subcommands.j = Subcommands.join

return Module