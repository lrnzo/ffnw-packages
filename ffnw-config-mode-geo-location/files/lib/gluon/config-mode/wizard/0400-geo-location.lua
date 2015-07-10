local cbi = require "luci.cbi"
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()

local M = {}

function M.section(form)
  local s = form:section(cbi.SimpleSection, nil, i18n.translate(
    'If you want the location of your node to be displayed on the map, '
      .. 'you can sed a automatically localization of your router or enter its coordinates here. Specifying the altitude '
      .. 'is optional and should only be done if a proper value is known.'))

  local o

  o = s:option(cbi.Flag, "_auto_location", i18n.translate("Show node on the map via automatic localization"))
  o.default = uci:get_first("gluon-node-info", "location", "share_location", o.disabled)
  o.rmempty = true

  o = s:option(cbi.Value, "_interval", i18n.translate("Interval in minutes"))
  o.value = uci:get_first("gluon-node-info", "location", "refresh_interval")
  o:depends("_auto_location", "1")
  o.rmempty = false
  o.datatype = "integer"
  o.description = i18n.translatef("sed refresh interval the default is ons a day")

  o = s:option(cbi.Flag, "_static_location", i18n.translate("Set location manualy"))
  o.default = uci:get_first("gluon-node-info", "location", "static_location", o.disabled)
  o:depends("_auto_location", "1")
  o.rmempty = true
  o.description = i18n.translatef("the wifi locator will be still running in the backround but not overwriting the location")

  o = s:option(cbi.Value, "_latitude", i18n.translate("Latitude"))
  o.default = uci:get_first("gluon-node-info", "location", "latitude")
  o:depends("_static_location", "1")
  o.rmempty = false
  o.datatype = "float"
  o.description = i18n.translatef("e.g. %s", "53.873621")

  o = s:option(cbi.Value, "_longitude", i18n.translate("Longitude"))
  o.default = uci:get_first("gluon-node-info", "location", "longitude")
  o:depends("_static_location", "1")
  o.rmempty = false
  o.datatype = "float"
  o.description = i18n.translatef("e.g. %s", "10.689901")

  o = s:option(cbi.Value, "_altitude", i18n.translate("Altitude"))
  o.default = uci:get_first("gluon-node-info", "location", "altitude")
  o:depends("_static_location", "1")
  o.rmempty = true
  o.datatype = "float"
  o.description = i18n.translatef("e.g. %s", "11.51")

end

function M.handle(data)
  local sname = uci:get_first("gluon-node-info", "location")
-- _auto_location
-- _interval
-- _static_location
-- _latitude
-- _longitude
-- _altitude

--  uci:set("gluon-node-info", sname, "share_location", data._auto_location)
--  uci:set("gluon-node-info", sname, "static_location", data._static_location)
  if data._auto_location then
    if data._interval ~= nil and data._interval >= 2 and data._interval <= 43200 then
      uci:set("gluon-node-info", sname, "refresh_interval", data._interval)
    end
    if data._static_location and data._latitude ~= nil and data._longitude ~= nil then
      uci:set("gluon-node-info", sname, "static_location", data._static_location)
      uci:set("gluon-node-info", sname, "latitude", data._latitude)
      uci:set("gluon-node-info", sname, "longitude", data._longitude)
      if data._altitude ~= nil then
        uci:set("gluon-node-info", sname, "altitude", data._altitude)
      else
        uci:delete("gluon-node-info", sname, "altitude")
      end
    end
  end
  uci:save("gluon-node-info")
  uci:commit("gluon-node-info")
end

return M
