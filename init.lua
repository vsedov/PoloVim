local ok, impatient = pcall(require, "impatient")
if ok then
    impatient.enable_profile()
else
    log:warn(impatient)
end
require("core")
require("overwrite")
