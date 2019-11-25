#!/usr/bin/osascript

property exportFileExtension : ".pdf"
property noteExportFlag : "📌"
property notabilityName : "Notability"

# Create the out folder
tell application "Finder"
	set outFolder to my FilepathToThisFolderAsString() & "out"
end tell

# Launch Notability
tell application notabilityName
	quit
	delay 1
	launch
	delay 2
	activate
end tell

tell application "System Events"
	my WaitUntilExists(window 1 of application process notabilityName)
	# Save notability main window for later
	set notabilityWindow to window 1 of application process notabilityName
	tell process notabilityName
		# This selects the All Notes tab
		select (row 1 of outline 1 of scroll area 2 of window 1)

		# For each note in All notes
		repeat with aRow in (every row of table 1 of scroll area 3 of notabilityWindow)
			repeat 1 times
				# Variables
				set currentNoteCategory to name of static text 1 of UI element 1 of aRow
				set currentNoteName to name of static text 2 of UI element 1 of aRow
				set currentNoteModDate to name of static text 3 of UI element of aRow
				set currentNoteModDate to my CreateDateFromDatestring(currentNoteModDate as text)

				# if current row contains export flag
				if (currentNoteName contains noteExportFlag) then
					# create a new name for the note without the export flag
					set noteNameWithoutEmoji to text 1 thru -2 of currentNoteName
					# create the out filename for our note
					set outNoteFilename to noteNameWithoutEmoji & exportFileExtension
					set outFolder to outFolder & "/" & currentNoteCategory
					set outNoteFilepath to outFolder & "/" & outNoteFilename
					# create dir if needed
					do shell script "mkdir -p " & quoted form of outFolder


					# check if note already exists
					set noteFileExists to my FileExists(outNoteFilepath)
					if noteFileExists then
						# check if the current date is newer
						tell application "System Events" to set lastLocalModDate to modification date of file outNoteFilepath
						if lastLocalModDate ≥ currentNoteModDate then
							# continue the loop, we don't have to export this
							exit repeat -- continue
						end if
					end if

					# select it, so the export knows what to export
					select aRow

					# export
					click menu item "PDF..." of menu 1 of menu item "Export As" of menu 1 of menu bar item "File" of menu bar 1

					set exportDialogWindow to window "Export"
					my WaitUntilExists(exportDialogWindow)

					# handle Export dialog
					tell (exportDialogWindow)
						# set focus on the text field
						set focused of text field 1 to true

						# Change the output folder
						keystroke "g" using {command down, shift down}
						delay 0.1
						my WaitUntilExists(sheet 1)
						tell sheet 1
							set value of combo box 1 to outFolder
							click button "Go"
						end tell

						# set the new filename without emojis
						set value of text field 1 to outNoteFilename

						# we don't want page margins or the paper to be included in the final pdf (uncheck all checkboxes)
						repeat with aCheckbox in (every checkbox)
							tell aCheckbox to if value is 1 then click
						end repeat

						# finally, export
						click button "Export"

						# if the file exists
						if noteFileExists then
							# wait for the action sheet
							my WaitUntilExists(sheet 1)
							# click the button
							click button "Replace" of sheet 1
						end if
					end tell
				end if
			end repeat
		end repeat
	end tell
end tell

tell application notabilityName to quit

return "Success"


# Sub-routines
on FileExists(theFile) -- (String) as Boolean
	tell application "System Events"
		return (exists file theFile)
	end tell
end FileExists

on CreateDateFromDatestring(theString)
	return date (do shell script "python3 " & my FilepathToThisFolderAsString() & "date_converter.py " & quoted form of theString)
end CreateDateFromDatestring

on FilepathToThisFolderAsString()
	tell application "Finder"
		return POSIX path of (parent of (path to me) as string)
	end tell
end FilepathToThisFolderAsString

on WaitUntilExists(theElement)
	tell current application
		repeat until (exists theElement)
			delay 1
		end repeat
	end tell
end WaitUntilExists
