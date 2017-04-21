-- App switcher
--
-- The app switcher uses a modal hotkey that, when pressed, gives access to
-- a configurable list of running applications by pressing one other key. 
-- This means you can switch to another application in 2 key presses.
--
-- Why? I like spaces for some apps, like IntelliJ IDEA, Ulyssses and OmniFocus.
-- But when you're looking at one, where's the other you need? To the left? To
-- the right? I typically don't remember, so I use ⌘+Tab. But that more often
-- than not requires multiple key presses to get to the app I need.
--
-- Alfred helps, but not enough: Launch Alfred, type at least 1 character, press
-- Enter. That's 3 key presses. At least. With this app switcher, it's always 2.
--
-- The app switcher doesn't launch applications when they're not running, on
-- purpose. I find I like it better to be told that an app is not running, than
-- that it's being launched if that happens to be the case. Some applications
-- take quite some time to startup, like IntelliJ. Your mileage may vary..
--
-- TODO: register a key that shows a table of registered shortcuts.

local hotkey
local notification = hs.canvas.new { x = 100, y = 50, w = 400, h = 40 }
notification:appendElements({
    type = "rectangle",
    strokeColor = { red = 1.0, blue = 1.0, green = 1.0 },
    fillColor = { alpha = 0.8, red = 0.2, blue = 0.2, green = 0.2 },
    frame = { x = "0", y = "0", w = "1", h = "1" },
    withShadow = "false"
}, {
    type = "text",
    text = "Application shortcut?",
    textAlignment = "center"
})

local function exitModal()
    notification:hide()
    hotkey:exit()
end

local function activateApplication(name)
    local app = hs.application.find(name)
    if app then
        if app:activate() and not app:focusedWindow() then
            -- The application was activated but no window was shown. Try again:
            -- (This is OmniFocus, which has a global popup window)
            app:selectMenuItem({"Window", "Main Window"})
        end
    else
        hs.alert(name .. " is not running", 0.5)
    end
end

function setupApplicationLauncherModalHotkey(modifiers, key)
    hotkey = hs.hotkey.modal.new(modifiers, key)
    function hotkey:entered()
        notification:show()
    end
    hotkey:bind({}, "escape", exitModal)
    hotkey:bind(modifiers, key, exitModal)
    -- Set a default function for each key, in case of pressing the wrong one
    -- By registering an application the key is overridden.
    characters = "abcdefghijklmnopqrstuvwxyz1234567890"
    for c in characters:gmatch "." do
        hotkey:bind(modifiers, c, function() 
            hs.alert.show("No shortcut registered for key '" .. c .. "'", 0.5)
            exitModal()
        end)
    end
    return hotkey
end

function registerApplicationHotkey(character, name)
    hotkey:bind({}, character, function()
        activateApplication(name)
        exitModal()
    end)
end

