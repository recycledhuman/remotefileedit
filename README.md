# remotefileedit
I. Purpose: To alter a file remotely

II. Method: Mounts a remote directory, edits a file, passes changes through a convertor for mac to windows, deletes any detritus and unmounts the directory

A. Variables: USER, SCRIPT, IP, SHARE, CHECKFILE, WRITEFILEA, WRITEFILEB, NOW 

B. Used: SED to pass mac text to pc, READ to prompt for data to be used as variables in the script

III. Script Outline: Set Variables, Create Logfile, Read Credentials, Determine Needs, Mount Directory, Create Placeholder, Translate Mac Newline to Windows with SED, Write to File, Delete Placeholder, Move and Delete logfile, Unmount Directory

IV. Takeaways: Learned that conventions for Mac (newline) do not hold for Windows Environment, leanred that folders must be shared from host account to access remotely through mount command

V. Questions: Is there a more elegant way to do this task (ssh or remote access)? Do I need to adjust the number of Variables to provide for more tweaking of the script?
