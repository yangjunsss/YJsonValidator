# Set up the environment.

    PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
    XALIGN_PATH="$PLUGIN_DIR/YJsonValidator.xcplugin"

# check path, remove if exist
    
    if [ -d "$PLUGIN_DIR" ]; then
        if [ -d "$XALIGN_PATH" ]; then
            sudo rm -rf "$XALIGN_PATH"
        fi
    fi

# done 
  echo
  echo "YJsonValidator is uninstalled.\nPlease Restart Your Xcode.\nThank U for using it."
  echo "."