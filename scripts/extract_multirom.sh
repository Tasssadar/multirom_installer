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
    chmod 777 "$base"
    touch "$base/.nomedia"
fi

cp /tmp/multirom/* "$base/"
chmod 755 "$base/multirom"
chmod 755 "$base/busybox"
chmod 750 "$base/trampoline"
