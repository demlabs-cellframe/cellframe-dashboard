
TEMPLATE = aux

linux {
    node_build.commands = $$PWD/../cellframe-node/prod_build/build.sh --target linux release -DBUILD_WITH_PYTHON_ENV=ON
    node_targets.files = $$OUT_PWD/build_linux_release/dist/opt
}

win32 {
    node_build.commands = $$PWD/../cellframe-node/prod_build/build.sh --target windows 
    node_targets.files = $$OUT_PWD/build_windows_release/dist/opt
}

mac {
    node_build.commands = $$PWD/../cellframe-node/prod_build/build.sh --target osx 
    node_targets.files = $$OUT_PWD/build_osx_release/dist/Users/root/Applications/Cellframe.app
}

QMAKE_EXTRA_TARGETS += node_build
PRE_TARGETDEPS = node_build

node_targets.path = /
node_targets.CONFIG += no_check_exist

INSTALLS += node_targets