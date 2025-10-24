# 🗂️ FileGrouper

**Automatically sort your files by extensions with a simple Bash script!**  

FileGrouper scans a target directory, finds all files, and **copies** them into a new folder, creating dedicated subfolders for each file type (e.g., `txt_s`, `jpg_s`, `other_s`). Perfect for cleaning up messy folders! ✨

---

## 🌟 Features

- **Two Scanning Modes**:
  - **Non-recursive (`n`)**: Sorts files **only in the top-level directory**.  
  - **Recursive (`r`)**: Sorts files in the target directory **and all its subdirectories**.  
- **Safe Copying**: Files are **copied**, not moved — originals stay intact.  
- **Interactive & Automated**: Run without arguments for prompts, or pass directory + mode for automation.  
- **Handles No-Extension Files**: Files without extensions are grouped into an `other_s` folder.  
- **Informative Logging**: Tracks progress with **INFO**, **WARN**, and **SUCCESS** messages. ✅  

---

## 🖥️ Requirements

- Linux or macOS (or any system with Bash)  
- Standard utilities: `find`, `basename`, `mkdir`, `cp`  

---

## 🚀 Installation

1. Clone the repository or download the script:

```bash

git clone https://github.com/andriy1144/FileGrouper.git
cd FileGrouper

```

2. Make the script executable:

```bash

chmod +x grouper.sh

```

---

## 📝 Usage

You can run FileGrouper in **two modes**:  

---

### 1️⃣ Interactive Mode

Run the script without arguments and follow the prompts:

```bash

./grouper.sh

```

**Example:**

```

+================================================================+
|                   Welcome to the File Grouper                  |
|                                                                |
| - Written by Andriy Murhan using Bash                           |
| - Groups files by their extensions                              |
+================================================================+

Enter a path for a directory to group: ~/Downloads
Enter the parsing strategy (r - recursively, n - top-level only): r
[INFO] Scanning directory: /home/user/Downloads
[INFO] Grouping files by extensions...
[INFO] Preparing output structure: ../grouped_by_extension_Downloads
[INFO] Creating folder for .zip files
[INFO] Copied 2 file(s) to grouped_by_extension_Downloads/zip_s
[INFO] Creating folder for .pdf files
[INFO] Copied 5 file(s) to grouped_by_extension_Downloads/pdf_s
[SUCCESS] Copy completed! Results in ../grouped_by_extension_Downloads

```

---

### 2️⃣ Argument Mode

Run the script with **directory path** and **strategy**:

#### Syntax
```bash

./grouper.sh [PATH_TO_DIRECTORY] [STRATEGY]

```

- `PATH_TO_DIRECTORY`: directory to group (e.g., `/Documents`)  
- `STRATEGY`:  
  - `r` — Recursive sort (includes subfolders)  
  - `n` — Non-recursive sort (top-level only)  

#### Examples

**Recursive:**
```bash

./grouper.sh ~/Projects/my_messy_folder r

```

**Non-Recursive:**
```bash

./grouper.sh /var/log n

```

---

## 📂 Example Output

The script creates a new directory alongside (at the same level as) your target directory.

### Before:
```

my_folder/
├── doc1.pdf
├── image.jpg
├── notes.txt
├── archive.zip
└── subfolder/
    ├── doc2.pdf
    └── another.jpg

```

### After (running ./grouper.sh my_folder r):
```

my_folder/
│   ├── doc1.pdf
│   ├── image.jpg
│   ├── notes.txt
│   ├── archive.zip
│   └── subfolder/
│       ├── doc2.pdf
│       └── another.jpg
│
grouped_by_extension_my_folder/  <-- NEW FOLDER
    ├── pdf_s/
    │   ├── doc1.pdf
    │   └── doc2.pdf
    ├── jpg_s/
    │   ├── image.jpg
    │   └── another.jpg
    ├── txt_s/
    │   └── notes.txt
    └── zip_s/
        └── archive.zip

```

---

## 👨‍💻 Author

**Andriy Murhan**  
📧 Feel free to contribute, open issues, or suggest improvements! 🚀
