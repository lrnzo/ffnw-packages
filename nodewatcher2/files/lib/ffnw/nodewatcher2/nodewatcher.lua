#!/usr/bin/env lua


local json = require ("dkjson")
--require("uci")

local uci = require("uci").cursor()


data ={}


function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function isArray(t)
  local i = 0
  for _ in pairs(t) do
      i = i + 1
      if t[i] == nil then return false end
  end
  return true
end

function xmlEncode(tbl,name,layer)
    local out=""
    if layer==1 then out=out.."<?xml version='1.0' ?>\n" end
    for i=1,layer do out=out..'\t' end
    out=out.."<"..name..">"
    if type(tbl)=="table" then

        out=out..'\n'
        local akey=nil
        if isArray(tbl) then
            akey=name:sub(0,-2)
        end	
        for k,v in pairs(tbl) do
            out=out..(xmlEncode(v,akey or k,layer+1))
        end
        for i=1,layer do out=out..'\t' end
    else
        out=out..(tostring(tbl))
    end
    out=out.."</"..name..">\n"
    return out
end


function writeToFile(string,filename)
    local path=uci:get("nodewatcher2","prefs","destination_folder")
    if path == nil then
        return
    end
    os.execute('if [[ ! -d "'..path..'" ]] ; then mkdir -p "'..path..'" ; fi')
    os.execute('if [[ ! -h /lib/gluon/status-page/www/nodedata ]] ; then ln -s '..path..' /lib/gluon/status-page/www/nodedata ; fi')
    path=path.."/"..filename
    local file = io.open(path, "w")
    file:write(string)
    file:close()
    if uci:get("nodewatcher2","prefs","enable_gzip") == "1" then
        os.execute("echo '"..string.."' |gzip > "..path..".gz") 
    end
end

function removeFile(filename)
    local path=uci:get("nodewatcher2","prefs","destination_folder")
    if path == nil then
        return
    end
    path=path.."/"..filename
    os.remove(path)
    if uci:get("nodewatcher2","prefs","enable_gzip") == "1" then
        os.remove(path..".gz")
    end
end


function generateXml()
    local path="nodedata.xml"
    if uci:get("nodewatcher2","prefs","generate_xml") == "1" then
        local string=xmlEncode(data,"data",1)
        writeToFile(string,path)
    else
        removeFile(path)
    end
end

function generateJson()
    local path="nodedata.json"
    if uci:get("nodewatcher2","prefs","generate_json") == "1" then
        local string=json.encode (data, { indent = true })
        writeToFile(string,path)
    else
        removeFile(path)    
    end
end

function linesToTable(lines)
    if lines==nil then
        return {}
    end
    local tab = {}
    for line in lines:lines() do
        table.insert (tab, line);
    end
   -- if next(tab) == nil then
   --     return nil
   -- end
    return tab
end

function readFile(filepath)
    local file = io.open(filepath, "r");
    return linesToTable(file)
end

function readOutput(command)

    local file = io.popen(command)
    return linesToTable(file)
end

function readFirstRow(tbl)
   if next(tbl)~=nil then --and table.getn(tbl)>0 then
       return tbl[1]
   else
       return nil
   end
end


function fetchMemory()
    local tmp=readOutput("cat /proc/meminfo | grep -E '^(MemFree|MemTotal|Cached|Buffers)'")
    local memLookup={MemT="total",MemF="free",Buff="buffer",Cach="cache"}
    data.memory={}
    for k,v in pairs(tmp) do 
        local t={string.match(v,"(.*) (%d+) .*")}
        --print(t[1])
        key=memLookup[string.sub(v,1,4)]
        if key~=nil then
            data.memory[key]=tonumber(t[2])
        end
    end
end

function fetchTimes()
    data.times={}
    data.times.up,data.times.idle=string.match(readFile("/proc/uptime")[1],"(.+) (.+)")
    for k,v in pairs(data.times) do 
        data.times[k]=math.floor(tonumber(v)*1000) 
    end
end

function fetchPositions()
    data.position={}
    data.position.lon=readFirstRow(readOutput("uci get gluon-node-info.@location[0].longitude 2>/dev/null"))
    data.position.lat=readFirstRow(readOutput("uci get gluon-node-info.@location[0].latitude 2>/dev/null"))
    if next(data.position)==nil then data.position=nil end
end

function fetchSoftware()
    data.software={}
    data.software.firmware=readFile("/lib/gluon/release")[1]
    data.software.kernel=readOutput("uname -r")[1]
    data.software.mesh="B.A.T.M.A.N. "..(readFile("/sys/module/batman_adv/version")[1])
    data.software.vpn=readOutput("fastd -v")[1]
--    if readFirstRow(getOutput("uci get autoupdater.settings.enabled 2>/dev/null")) == "1" then
--       data.software.autoupdate=readFirstRow(getOutput("uci get autoupdater.settings.branch 2>/dev/null"))
--    end
end

function fetchOriginators()
    data.originators={}
    local tmp=readOutput("batctl o|sed -r 's/([0-9a-f:]+)[[:space:]]+([0-9.]+)s[[:space:]]+\\([[:space:]]*([0-9]{1,3})\\)[[:space:]]+([0-9a-f:]+)[[:space:]]+\\[[[:space:]]*(.+)\\]:.*/\\1 \\2 \\3 \\4 \\5/;tx;d;:x'")
    for k,v in pairs(tmp) do
        local o={}
        local m={}
        for v1 in string.gmatch(v,"[^ ]+") do
            table.insert(m,v1)
        end
        o.mac=m[1]
        o.nexthop=m[4]
        o.linkquality=tonumber(m[3])
        o.lastseen=math.floor(tonumber(m[2])*1000)
    --    print(o.mac.."->"..o.nexthop)
        if o.mac==o.nexthop then
                table.insert(data.originators,o);
        end

        
    end
end

function fetchInterfaces()
    data.interfaces={}
    for _,iface in pairs(readOutput("grep -E 'up|unknown' /sys/class/net/*/operstate")) do
     --  print(iface)
        i={}
        ipath,i.name=string.match(iface,"(.+/(.-))/operstate.*")
    --     print(ipath.." jjjjj "..i.name)
        if i.name~="lo" then
   --    print(ipath.." jjjjj "..i.name)
            i.ipv6={}
            i.traffic={}
            i.traffic.rx=readFirstRow(readFile(ipath.."/statistics/rx_bytes"))
            i.traffic.tx=readFirstRow(readFile(ipath.."/statistics/tx_bytes"))
            -- general interface info
            for _,ipl in pairs(readOutput("ip addr show "..i.name)) do
                local match=ipl:match("%s*inet6 ([0-9a-f:]+)(/%d+) .*")
                --ugly cascading if-else-if-... because of lua missing continue-command
                if match~=nil then
                    table.insert(i.ipv6,match)
                    --i.mac=match
                else
                    match=ipl:match("%s*link/ether (.-) .*")
                    if match ~=nil then 
                        i.mac=match
                    else    
                        match=ipl:match("%s*inet ([0-9.]+)(/%d+) .*")
                        if match~=nil then
                            i.ipv4=match
                        else
                            match=ipl:match(".* mtu (%d+) .*")
                            if match~=nil then
                                i.mtu=tonumber(match)
                            end
                        end
                    end
                end
            end
            if next(i.ipv6)==nil then i.ipv6=nil end
            -- wifi info
            i.radio={}
            for _,ipl in pairs(readOutput("iwinfo "..i.name.." info 2>/dev/null")) do
           --     print(ipl)
                local match=ipl:match('ESSID:%s+"(.*)".*')
                if match~=nil then
                    i.radio.essid=match
                else
                    match=ipl:match('Access Point:%s+([A-Za-z0-9:]+).*')
                    if match~=nil then
                        i.radio.bssid=match:lower()
                    else    
                        match={ipl:match('Tx%-Power: ([0-9]+) dBm  Link Quality: ([a-z0-9]+/[0-9]+)')}
                        
                        if next(match)~=nil then
                            i.radio.txpower=tonumber(match[1])                    
                            i.radio.linkquality=match[2]
                        end
                    end
                end
            end
            if next(i.radio)==nil then i.radio=nil end 
            --batman?
            if i.name~="bat0" then
                local bat=readFirstRow(readFile("/sys/class/net/"..i.name.."/batman_adv/iface_status"))
                i.meshstatus=(bat~=nil and bat~="not in use")
            else
                i.meshstatus=false
            end
            table.insert(data.interfaces,i)
        end
    end 
    
end

function fetchGateways()
    data.gateways={}
    for _,v in pairs(readOutput("batctl gwl|sed -r 's/^[[:space:]]+([a-f0-9:].*)/false \\1/ ; s/^=>(.*)/true \\1/ ; s/(true|false)[[:space:]]+([0-9a-f:]+)[[:space:]]+\\([[:space:]]*([0-9]+)\\)[[:space:]]+[a-f0-9:]+[[:space:]]+\\[[[:space:]]*(.+)\\]:[[:space:]]+([0-9.\\/]+).*$/\\1 \\2 \\3 \\4 \\5/;tx;d;:x'")) do 
        local g={}
        local m={}
        for v1 in string.gmatch(v,"[^ ]+") do
            table.insert(m,v1)
        end
        g.active=(m[1] == "true")
        g.mac=m[2]
        g.linkquality=tonumber(m[3])
        g.interface=m[4]
        g.class=m[5]
        table.insert(data.gateways,g)
    end
end


-- do the fetching
data.hostname=readFile("/etc/hostname")[1]
data.client_count=tonumber(readOutput("echo '5'")[1]);
fetchTimes()
fetchMemory()
fetchPositions()
fetchSoftware()
fetchOriginators()
fetchInterfaces()
fetchGateways()



generateXml()

generateJson()




