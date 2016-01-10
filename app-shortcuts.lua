-- Sets up application shortcuts - Ctrl + <number> - for the top 9 apps
-- Note that the shortcuts only work if the global keyboard shortcuts for
-- selecting a space have been changed, EVEN WHEN DISABLED!
--
-- Ctrl + 0 shows the list of application shortcuts

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

-- Set up a hotkey for each app. Note that this breaks if there are more than
-- 9 apps in the list!
for index, name in ipairs(apps) do
    help = help .. "⌃" .. tostring(index) ..  ": " .. name .. "\n"
    hs.hotkey.bind("ctrl", tostring(index), function()
        local app = hs.appfinder.appFromName(name)
        hs.application.launchOrFocus(name)
    end)
end

help = help:gsub("^%s*(.-)%s*$", "%1")

hs.hotkey.bind("ctrl", "0", function() hs.alert(help, 4) end)

