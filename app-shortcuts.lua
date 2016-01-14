-- Sets up application shortcuts - Cmd + Alt + <number> - for the top 10 apps
-- Note that the shortcuts only work if the global keyboard shortcuts for
-- selecting a space have been changed, EVEN WHEN DISABLED!
--
-- Cmd + Alt + § shows the list of application shortcuts

local mods = {"⌘", "⌥"}
local mods_text = table.concat(mods)

local apps = {
    "Safari",
    "TextMate",
    "OmniFocus",
    "Reeder",
    "Mail",
    "Keynote",
    "IntelliJ IDEA 15",
    "OmniGraffle",
    "iTunes"
}

local help = ""

-- Set up a hotkey for each app. This breaks if there are more than 9 apps!
for index, name in ipairs(apps) do
    help = help .. mods_text .. tostring(index) ..  ": " .. name .. "\n"
    hs.hotkey.bind(mods, tostring(index), function()
        local app = hs.application.find(name)
        hs.application.launchOrFocus(name)
    end)
end

-- Citrix Viewer (Telewerkportaal) requires a different algorithm to activate:
hs.hotkey.bind(mods, "0", function()
    local window = hs.window.get("Telewerkportaal-Shared")
    if window then window:focus() end
end)
help = help .. mods_text .. "0: Citrix Viewer"

hs.hotkey.bind(mods, "§", function() hs.alert(help, 4) end)
