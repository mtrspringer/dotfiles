local function toggleApplication(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    app:hide()
  end
end

hs.hotkey.bind(mash, "1", function() toggleApplication("1Password") end)
hs.hotkey.bind(mash, "c", function() toggleApplication("Slack") end)
hs.hotkey.bind(mash, "d", function() toggleApplication("Dash") end)
hs.hotkey.bind(mash, "f", function() toggleApplication("Finder") end)
hs.hotkey.bind(mash, "g", function() toggleApplication("Google Chrome") end)
hs.hotkey.bind(mash, "k", function() toggleApplication("Keeper Password Manager") end)
hs.hotkey.bind(mash, "m", function() toggleApplication("Spotify") end)
hs.hotkey.bind(mash, "p", function() toggleApplication("Postman") end)
hs.hotkey.bind(mash, "s", function() toggleApplication("System Preferences") end)
hs.hotkey.bind(mash, "t", function() toggleApplication("Terminal") end)
hs.hotkey.bind(mash, "v", function() toggleApplication("Visual Studio Code") end)
hs.hotkey.bind(mash, "z", function() toggleApplication("Zoom") end)
