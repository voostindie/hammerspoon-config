-- Sets up application shortcuts - Cmd + Alt + <number> - for the top 10 apps
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
    "iTunes",
    "Citrix Viewer"
}

local help = ""

-- Set up a hotkey for each app. This breaks if there are more than 9 apps!
for index, name in ipairs(apps) do
    local shortcut = index % 10
    help = help .. mods_text .. tostring(shortcut) ..  ": " .. name .. "\n"
    hs.hotkey.bind(mods, tostring(shortcut), function()
        local app = hs.application.find(name)
        if app then
            app:activate()
        else
            hs.alert(name .. " is not running")
        end
    end)
end

hs.hotkey.bind(mods, "§", function() hs.alert(help, 4) end)
