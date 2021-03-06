#!/bin/bash

DIR=`dirname $0`

copy() {
    from="$1"
    if [ -z "$2" ]; then
        to="$1"
    else
        to="$2"
    fi

    rm -rf "$HOME/$to"
    cp -frv "$from" "$HOME/$to"
}

symlink() {
    from="$1"
    if [ -z "$2" ]; then
        to="$1"
    else
        to="$2"
    fi

    rm "$HOME/$to"
    ln -Fsv "$from" "$HOME/$to"
}

loadconf() {
    REPO="$DIR/$1"
    source "$REPO/config.sh"
}

save_last_update() {
    date '+%s' > "$DIR/.last_update"
}

source_config() {
    if [ -f "$DIR/config-local.sh" ]; then
        source "$DIR/config-local.sh"
    else
        source "$DIR/config.sh"
    fi

    save_last_update
}

dotfiles_init() {
    pushd $DIR > /dev/null
    git submodule update --recursive --init
    git submodule foreach --recursive git checkout master
    popd > /dev/null
    source_config
}

dotfiles_update() {
    pushd $DIR > /dev/null
    git pull
    git submodule update
    source_config
    popd > /dev/null
}

dotfiles_push() {
    pushd $DIR > /dev/null
    git commit -a -m 'Submodules update'
    git push
    popd $DIR > /dev/null
}

case $1 in
init|--init)
    dotfiles_init
    ;;
update|--update)
    dotfiles_update
    ;;
push|--push)
    dotfiles_push
    ;;
*)
    echo "Usage: $0 <init|update|push>" >&2
    ;;
esac



