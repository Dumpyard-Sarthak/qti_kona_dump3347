if [ -s /odm/etc/wifi/bin_version ]; then
    system_version=`cat /odm/etc/wifi/bin_version`
    echo "system_version=$system_version"
    if [ ! -s /mnt/vendor/persist/bin_version ]; then
        cp /odm/etc/wifi/bin_version /mnt/vendor/persist/bin_version
        sync
    fi
else
    system_version=1
fi

if [ -s /mnt/vendor/persist/bin_version ]; then
    persist_version=`cat /mnt/vendor/persist/bin_version`
else
    persist_version=1
fi

if [ ! -s /mnt/vendor/persist/bdwlan.elf  -o $system_version -gt $persist_version ]; then
        cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
        echo "copy bdwlan.elf successfully"
    echo "$system_version" > /mnt/vendor/persist/bin_version
    sync
fi

if [ $system_version -eq $persist_version ] ; then
    persistbdf=`md5sum /mnt/vendor/persist/bdwlan.elf |cut -d" " -f1`
    vendorbdf=`md5sum /odm/etc/wifi/bdwlan.elf |cut -d" " -f1`
    if [ x"$vendorbdf" != x"$persistbdf" ]; then
            cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
            echo "MD5 copy bdwlan.elf successfully"
        sync
        echo "bdf check"
    fi
fi
