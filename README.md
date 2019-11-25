# 📌 Notability Notes Converter 📌

This repository contains the necessary code to convert all of your notes to `.pdf` format. After running the script, all notes from the Notability app on your Mac will be exported as pdf to an `out` folder.

### ⚠️ Requirements ⚠️
1. macOS
2. [Notability.app](https://www.gingerlabs.com) for macOS

## Running the script

1. Append a pin emoji (📌) to each note file that you wan't to have exported.
2. (Optional if editing notes from another Apple device) Wait for iCloud to sync.
3. Then run from terminal

```
$ osascript notability_pdf_export.scpt
```

Or just run the file directly via Script Editor.

### Example

Structure of notes in Notability
```
subject_1/note1📌.note
subject_1/note2📌.note
subject_1/note3📌.note
subject_1/note4.note
subject_2/example_note📌.note
subject_3/private_note.note
```

```
$ osascript notability_pdf_export.scpt
Success
$
```

After running the script a new directory containing all the required pdfs is created.

```
# Structure of out folder
out/subject_1/note1.pdf
out/subject_1/note2.pdf
out/subject_1/note3.pdf
out/subject_2/example_note.pdf
```

## Features

  * Creates a `.pdf` file for each note that ends with the pin emoji (📌)
  * Each pdf file will be correctly categorized by a folder that represents the Note subject
  * The script doesn't export the same note twice. (i.e. the pdf files are overwritten only when the modification time of the Notability note is greater than the pdfs that were generated beforehand)
### Todo

- [ ] Add flags for including the Paper 📜 / Page Margin 📄 in the pdf export settings. Currently each pdf is exported without the paper and page margins.
- [ ] Add the option to flag (📌) an entire subject.
  - [ ] Add exclusion tag for notes that you don't want to be exported from tagged subjects.

## License

MIT
