# Secure Data Storage

Collection of scripts to manage an encrypted loop back image.

To use these scripts, first clone the repo:

    $ cd $HOME
    $ git clone https://github.com/troth/secure-data-mgmt.git
    $ cd secure-data-mgmt

Then, create an encrypted loop back image:

    $ ./sec-create.sh

Once the loop back image is created, mount the image:

    $ ./sec-mount.sh

Use the encrypted image that is mounted at `/sec-data`.

When you are done with the image, unmount it:

    $ ./sec-umount.sh

Note: All the `sec-*.sh` scripts must be run from the `secure-data-mgmt` git
repo (created by the git clone command above).
