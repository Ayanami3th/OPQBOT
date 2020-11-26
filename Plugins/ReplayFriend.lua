local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

function ReceiveFriendMsg(CurrentQQ, data)
    
    if (string.find(data.Content, "测试") == 1 ) then
        Api.Api_SendMsg(
            CurrentQQ,
            {
                toUser = data.FromUin,
                sendToType = 1,
                sendMsgType = "TextMsg",
                groupid = 0,
                content = data.Content,
                atUser = 0
            }
        )
    end
    return 1
end
function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end
function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end
