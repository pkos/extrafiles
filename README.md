extrafiles v0.5 - Utility to compare the filenames in two directories, the source and standard directories.
                  Then move extra files from the source directory to source ../extra that do not have
                  matching filenames in the standard directory.

with extrafiles [options] [directory of files to move..] [directory of files to compare to..]

Options:
  -move       move files to the ../extra subdirectory, otherwise just log.

Example:
              extrafiles "D:/Atari - 2600/Source" "D:/Atari - 2600/Standard"

Author:
   Discord - Romeo#3620