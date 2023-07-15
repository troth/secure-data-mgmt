#
# Bash shell config for secure data operations.
#
# To be sourced by other scripts.
#

if [ $(id -u) -ne 0 ]
then
    echo "Need to be root to run this script. Running sudo..."
    exec sudo "$0" "$@"
fi

IMG="sec-data.img"
LOOP="$(ls -1 /dev/loop[0-9]* | sort -V | tail -1)"
MNT_PT="/sec-data"
SIZE_MB=1000
