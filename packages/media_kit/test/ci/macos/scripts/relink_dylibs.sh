#!/bin/sh

set -e # exit on error
set -u # exit on undefined variable

# relink_dylibs updates the dependency paths of dynamic libraries by replacing a
# source prefix with a target prefix
relink_dylibs() {
    SOURCE_PREFIX=$1
    TARGET_PREFIX=$2
    DIR=$3

    find $DIR/*.dylib | while read DYLIB; do
        # sign the dylib because install_name_tool doesn't work on unsigned dylibs
        codesign --force -s - -v "${DYLIB}" 2>/dev/null

        # change id of current dylib
        otool -l "$DYLIB" |
            grep " name " |
            cut -d " " -f11 |
            head -n +1 |
            while read ID; do
                NAME=$(basename $ID)

                echo "$DYLIB: $NAME"
                install_name_tool -id "@rpath/$NAME" "$DYLIB" 2>/dev/null
            done

        # change path of current dependencies
        otool -l "$DYLIB" |
            grep " name " |
            cut -d " " -f11 |
            tail -n +2 |
            grep "$SOURCE_PREFIX" |
            while read DEP; do
                # libpng16.16.dylib => libpng16.dylib
                # libxml2.2.dylib => libxml2.dylib
                DEPNAME="$(basename "$DEP" | sed -r "s|([0-9]+)(\.[0-9]+)*|\1|g")"

                echo "$DYLIB: $DEPNAME"
                install_name_tool -change "$DEP" \
                    "$TARGET_PREFIX/$DEPNAME" \
                    "$DYLIB" \
                    2>/dev/null
            done

        # re-sign the dylib, as the change in dependencies invalidates the signature
        codesign --force -s - -v "${DYLIB}" 2>/dev/null
    done
}

SOURCE_PREFIX=$1
TARGET_PREFIX=$2
DIR=$3

relink_dylibs "$SOURCE_PREFIX" "$TARGET_PREFIX" "$DIR"
