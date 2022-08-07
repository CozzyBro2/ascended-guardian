-- HashCollision 08/03/22

local Module = {}

local Discordia = require('discordia')
local CommandMap = require('commands/manager').CommandMap

local Parser = require('parser')
local Config = require('config')

local command_error_format = [[<@%d>, Command "**%s**" failed with error:
%s]]

local Bot

-- Return token from 'secret' file
local function ReadToken()
    local Token = Config.readFile(Config.token_path)

    return Token
end

-- Invoked when the bot is logged in & ready
local function OnLogin()
    print('Logged in successfully!')

    Bot:setGame(Config.bot_game)
    Bot:setStatus(Config.bot_status)
end

-- Invoked when a user sends a message the bot can see
local function OnMessageSent(Message)
    if Message.author.bot then return end

    local Arguments, Flags = Parser.parseCommand(Message.content)

    local CommandName = Arguments[1]
    local Command = CommandMap[CommandName]

    if CommandName and Command then
        -- I would love for this to be async but idk how :(
        local Success, Err = pcall(Command.run, Arguments, Flags, Message)

        if not Success then
            Message:addReaction('❌')

            Message:reply(command_error_format:format(Message.author.id, CommandName, Err))
        end
    end
end

-- Start the bot, register it, etc.
function Module.start()
    Bot = Discordia.Client {bitrate = 96000}

    -- Events
    Bot:on('ready', OnLogin)
    Bot:on('messageCreate', OnMessageSent)

    -- Log em in
    local Token = ReadToken()

    Bot:run(Config.token_format:format(Token))
end

-- Stop the bot and clean it up
function Module.stop()
    os.exit()
end

return Module