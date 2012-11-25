#!/sbin/sh
base=""
if [ -d "/data/media/multirom" ] ; then
    base="/data/media/multirom"
elif [ -d "/data/media/0/multirom" ] ; then
    base="/data/media/0/multirom"
else
    if [ -d "/data/media/0" ] ; then
        base="/data/media/0/multirom"
    else
        base="/data/media/multirom"
    fi

    mkdir "$base"
    chown media_rw:media_rw "$base"
    chmod 777 "$base"

    touch "$base/.nomedia"
    chown media_rw:media_rw "$base/.nomedia"

    # remove internal ROM in order to regenerate boot.img
    rm -r "$base/roms/Internal"
fi

cp /tmp/multirom/* "$base/"
chmod 755 "$base/multirom"
chmod 755 "$base/busybox"
chmod 750 "$base/trampoline"
