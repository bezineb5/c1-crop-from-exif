set decimalDelimiter to character 2 of (1 / 3 as string) -- This is because the string numbers needs to be localized to be converted to numbers

tell application "Capture One 23"
	repeat with variantItem in (get selected variants)
		try
			set imagePath to (get path of (get parent image of variantItem))
			
			-- Extract the crop area from the EXIF
			set commandLine to "/opt/homebrew/bin/exiftool -X -DefaultUserCrop \"" & imagePath & "\""
			set xmlExif to (do shell script commandLine)
			tell application "System Events"
				set xmlData to make new XML data with properties {name:"xmldata", text:xmlExif}
				
				tell XML element "rdf:RDF" of xmlData
					tell XML element "rdf:Description"
						set cropValue to value of XML element "SubIFD:DefaultUserCrop"
						set replCropValue to my findAndReplaceInText(cropValue, ".", decimalDelimiter)
						set cropArray to my theSplit(replCropValue, " ")
					end tell
				end tell
			end tell
			
			set cropFromX to (item 1 of cropArray)
			set cropFromY to (item 2 of cropArray)
			set cropToX to (item 3 of cropArray)
			set cropToY to (item 4 of cropArray)
			
			-- Retrieve the current crop from the variant
			-- Note that we don't retrieve the image size, as it countains the "greyed out" zones
			set dim to (get crop of variantItem)
			set originalCenterX to (item 1 of dim)
			set originalCenterY to (item 2 of dim)
			set imageWidth to (item 3 of dim)
			set imageHeight to (item 4 of dim)
			
			-- "div 1" converts a real to an integer
			set cropWidth to imageWidth * (cropToX - cropFromX) div 1
			set cropHeight to imageHeight * (cropToY - cropFromY) div 1
			set cropCenterX to (originalCenterX - imageWidth / 2) + imageWidth * ((cropFromX + cropToX) / 2.0) div 1
			set cropCenterY to (originalCenterY - imageHeight / 2) + imageHeight * (1.0 - ((cropFromY + cropToY) / 2.0)) div 1 -- From the bottom
			
			set cropList to {cropCenterX, cropCenterY, cropWidth, cropHeight}
			
			set crop of variantItem to cropList
			
		on error number -1728
			-- Ignore this error, it means that the EXIF information doesn't exist
		end try
	end repeat
	
end tell

-- From: https://erikslab.com/2007/08/31/applescript-how-to-split-a-string/
on theSplit(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end theSplit

-- From: https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/ManipulateText.html
on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

