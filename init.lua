require("core")
path = "/home/viv/.luarocks/lib/lua/5.1/yaml.so"

lyaml = "/home/viv/.luarocks/share/lua/5.1/lyaml/"

package.cpath = package.cpath .. ";" .. path
require("lyaml")
