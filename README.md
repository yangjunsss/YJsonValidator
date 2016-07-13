##YJsonValidator ![img](https://travis-ci.org/yangjunsss/YJsonValidator.svg?branch=master)

An Xcode plugin to validate json file when save,it can highlight the error character.

## Usage

```
Xcode -> Edit -> Validate Json On Save
```
The default is enable.

![Demo](http://yangjunsss.github.io/assets/media/3dec26cdfb1f83eecf44e21a7b70b70e.gif)

### Install & Uninstall

####Install
```shell
curl -fsSL https://raw.githubusercontent.com/yangjunsss/YJsonValidator/master/install.sh | sh
```
####Unisntall
```shell
curl -fsSL https://raw.githubusercontent.com/yangjunsss/YJsonValidator/master/uninstall.sh | sh
```

or Delete the following directory:

```
~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/YJsonValidator.xcplugin
```


### Issue  
[GitHub Issue](https://github.com/yangjunsss/YJsonValidator/issues)
  
#### If you use New version Xcode, Try this in your terminal : 
  
  1. Get current Xcode UUID  
  
  ```shell
  XCODEUUID=`defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`
  ```
  2. Write it into the Plug-ins's plist  
  
  ```shell
  for f in ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/*; do defaults write "$f/Contents/Info" DVTPlugInCompatibilityUUIDs -array-add $XCODEUUID; done
  ```
  3. Restart your Xcode, and select <kbd>Load Bundles</kbd> on the alert
   

