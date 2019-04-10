# Why?
Do you have a Leica Q or Leica Q2 and use the crop mode, but the crop is not recognized by Capture One?
This script solves this issue.

# Requirements
* A recent version of Capture One MacOS (unfortunatelly, the Windows version does not allow scripting)
* [ExifTool](https://sno.phy.queensu.ca/~phil/exiftool/) (see below for installation)

# Installation
First, you need to install ExifTool. The easiest method is to use [Homebrew](https://brew.sh/).
In a terminal, type (copied from the Homebrew documentation):
```bash
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Install ExifTool
brew install exiftool
```

Then, copy the script into the Capture One scripting folder:
* Download the file "Crop from EXIF.applescript"
* In Capture one, go to menu *Scripts > Open Scripts Folder*
* Copy the downloaded file in that directory (which is  "~/Library/Scripts/Capture One Scripts/")
* Go back to Capture One, choose menu *Scripts > Update Scripts Menu*
* Done!

Note: if you have a different version of Capture One than the 12, open the script and replace the string "Capture One 12" by "Capture One xx", where xx is your version.

# Usage
In Capture One, select all images you want to apply the EXIF crop to. Then choose menu *Scripts > Crop from EXIF*
Note: don't apply it multiple times, as it will crop proportionnaly to the existing crop.

# If you like it...
[Buy me coffee! Thanks!](buymeacoff.ee/KJoYI9Dnz)
