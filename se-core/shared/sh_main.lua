SECore = {}

function SECore.DebugPrint(msg)
    if Config.Debug then
        print(string.format('[SECore Debug] %s', msg))
    end
end


