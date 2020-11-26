local log = require("log")
local Api = require("coreApi")
local json = require("json")
local http = require("http")

local indexTable = 
{
    "来点涩图",
    "来点色图",
    "来点瑟图",
    "来份涩图",
    "来份色图",
    "来份瑟图",
    "来张涩图",
    "来张色图",
    "来张瑟图",
    "来、涩图",
    "来、色图",
    "来、瑟图",
    "涩图",
    "色图",
    "瑟图"
}
local whitelist = 
{
    1837099861,
    2656148918,
    1801267017,
    542109056,
    2796765941,
    473869679,
    1206126484
}

local function contains(table, val)
   for i = 1, #table do
      if table[i] == val then 
         return true
      end
   end
   return false
end

local function regex(table,val)
    for i = 1,#table do
        if (string.find(val,table[i]) == 1) then
            return true
        end
    end
    return false
end

function ReceiveFriendMsg(CurrentQQ, data)

    if not contains(whitelist, data.FromUin) then
        return 1
    end
    
    if not regex(indexTable,data.Content) then
        return 1
    end

    
    local idx = math.random(0, 20) -- 有效的索引从0000 ~ 0020
    idx = string.format('%04d', idx) -- 前面填充0,
    local url = "https://cdn.jsdelivr.net/gh/ipchi9012/setu_pics/setu_r18_" .. idx .. ".js" -- 索引文件地址
    log.info("url=%s", url)
    local resp = http.request("GET", url).body
    idx = string.find(resp, "(", 1, true)
    resp = string.sub(resp, idx + 1, -2) -- 去掉前面的setu_xxxx(和后面的)
    resp = json.decode(resp)
    local item = resp[math.random(#resp)] -- 从数组中随机选取一个元素
    local url = "https://cdn.jsdelivr.net/gh/ipchi9012/setu_pics/" .. item.path
    local text = "『" .. item.title .. "』 作者：" .. item.author
    log.info("url=%s, text=%s", url, text)
    Api.Api_SendMsg(
        CurrentQQ,
        {
            toUser = data.FromUin,
            sendToType = 1,
            sendMsgType = "TextMsg",
            groupid = 0,
            content = text,
            atUser = 0
        }
    )

    Api.Api_SendMsg(
        CurrentQQ,
        {
            toUser = data.FromUin,
            sendToType = 1,
            sendMsgType = "PicMsg", 
            groupid = 0,
            content = "",
            picUrl = url,
            atUser = 0
        }
    )
    return 1    
end

function ReceiveGroupMsg(CurrentQQ, data)
    return 1
end

function ReceiveEvents(CurrentQQ, data, extData)
    return 1
end