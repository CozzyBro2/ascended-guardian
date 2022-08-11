local Module = {}

local Subcommands = {}

local Config = require('config')
local Voice = require('./vc')

local search_failed_format = 'Could not find any audio for search: **"%s"**'
local search_format = '%s:%s'

local no_search = [[**You didn't search anything.** 

Here's an example:
`audio play nerd vs geek rap battle`

(You may also use the --search flag)]]

local ConnectionsMap
local Manager

local function combineSpaces(Arguments)
    local NewInput = {}

    for Index = 3, #Arguments do
        table.insert(NewInput, Arguments[Index])
    end

    return table.concat(NewInput, ' ')
end

function Subcommands.play(Arguments, Flags, Message)
    local Player = ConnectionsMap[Message.guild.id]

    local Input = Arguments[3]

    if not Input then
        error(no_search, 0)
    end

    if not Player then
        Voice.run({}, {}, Message)

        Player = ConnectionsMap[Message.guild.id]
    end

    if Arguments[4] then
        Input = combineSpaces(Arguments)
    end

    local Searcher = Flags['--searcher'] or 'ytsearch'
    local Query = search_format:format(Searcher, Input)

    local Result = Manager.api:get(Query)

    if Result then
        local Tracks = Result.tracks

        if Tracks and #Tracks > 0 then
            local TrackInfo = Tracks[1]

            Player:play(TrackInfo.track)
        else
            error(search_failed_format:format(Query), 0)
        end
    else
        error("Failed to search anything, i couldn't tell you why")
    end
end

function Subcommands.stop(Arguments, Flags, Message)
    local Player = ConnectionsMap[Message.guild.id]

    Player:stop()
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

function Module.update(NewManager)
    Manager = NewManager
    ConnectionsMap = Voice.ConnectionsMap
end

Subcommands.play = Subcommands.play
Subcommands.p = Subcommands.play
Subcommands.start = Subcommands.play

Subcommands.stop = Subcommands.stop
Subcommands.s = Subcommands.stop
Subcommands.quit = Subcommands.stop

return Module