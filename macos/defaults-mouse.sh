###############################################################################
# Trackpad, mouse, Bluetooth accessories                                      #
###############################################################################

# Magic Mouse: enable right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Magic Mouse: enable smart zoom on double-tap
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture -int 1

# Cursor: disable shake to find magnification
defaults write NSGlobalDomain CGDisableCursorLocationMagnification -int 1
