QT += qml quick widgets svg gui-private network
!android {
    TEMPLATE = app
}
CONFIG += c++11 #nsis_build
CONFIG += node_build

LIBS += -ldl
include(../config.pri)

TARGET = $${BRAND}

win32 {
    RC_ICONS = $$PWD/resources/icons/icon_win32.ico
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += DAP_SERVICE_NAME=\\\"$${BRAND}Service\\\"
DEFINES += DAP_SETTINGS_FILE=\\\"settings.json\\\"
macx {
    ICON = resources/icons/CellframeDashboard.icns
}
else: !win32 {
    ICON = qrc:/resources/icons/icon.ico
}

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

!android {
    MOC_DIR = moc
    OBJECTS_DIR = obj
    RCC_DIR = rcc
    UI_DIR = uic


    CONFIG(debug, debug|release) {
        DESTDIR = bin/debug
    } else {
        DESTDIR = bin/release
    }
}

INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

SOURCES += \
    $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    DapApplication.cpp \
    ImportCertificate/ImportCertificate.cpp \
    NotifyController/DapNotifyController.cpp \
    PluginsController/DapFilesFunctions.cpp \
    PluginsController/DapNetworkManager.cpp \
    PluginsController/DapPluginsController.cpp \
    WalletRestore/commandcmdcontroller.cpp \
    WalletRestore/randomfile.cpp \
    WalletRestore/randomwords.cpp \
    WalletRestore/wallethashmanager.cpp \
    mobile/testcontroller.cpp \
    quickcontrols/qrcodequickitem.cpp \
    systemtray.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

RESOURCES += $$PWD/qml.qrc
RESOURCES += $$PWD/../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${BRAND_LO}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    $$PWD/DapServiceController.h \
    DapApplication.h \
    ImportCertificate/ImportCertificate.h \
    NotifyController/DapNotifyController.h \
    PluginsController/DapNetworkManager.h \
    PluginsController/DapPluginsController.h \
    WalletRestore/commandcmdcontroller.h \
    WalletRestore/randomfile.h \
    WalletRestore/randomwords.h \
    WalletRestore/wallethashmanager.h \
    mobile/QMLClipboard.h \
    mobile/testcontroller.h \
    quickcontrols/qrcodequickitem.h \
    systemtray.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/core/libdap.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/crypto/libdap-crypto.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/net/libdap-net.pri)
include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

unix: !mac : !android {
    gui_target.files = $${BRAND}
    gui_target.path = /opt/$${BRAND_LO}/bin/
    INSTALLS += gui_target
    BUILD_FLAG = static
}

defined(BUILD_FLAG,var){
    LIBS += -L/usr/lib/icu-static -licuuc -licui18n -licudata
}

unix: !mac : !android : node_build {
    node_build.commands = $$PWD/../prod_build/linux/debian/scripts/compile_node.sh \
        $$shell_path($$_PRO_FILE_PWD_/../cellframe-node)
    QMAKE_EXTRA_TARGETS += node_build
    POST_TARGETDEPS += node_build
}

win32: nsis_build {
    DESTDIR = $$shell_path($$_PRO_FILE_PWD_/../build_win32)
    build_node.commands = $$PWD/../cellframe-node/prod_build/windows/scripts/compile.bat \
        $$DESTDIR $$shell_path($$_PRO_FILE_PWD_/../cellframe-node)
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/../cellframe-node/dist/share/configs/.) $$shell_path($$DESTDIR/dist/etc) &&
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/../cellframe-node/dist/share/ca/.) $$shell_path($$DESTDIR/dist/share/ca) &&
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/../cellframe-node/dist.linux/etc/network/.) $$shell_path($$DESTDIR/dist/etc/network) &&
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/resources/icons/icon_win32.ico) $$DESTDIR &&
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/../prod_build/windows/scripts/build.nsi) $$DESTDIR &&
    copyconfig.commands += $(COPY_DIR) \
        $$shell_path($$_PRO_FILE_PWD_/../prod_build/windows/scripts/modifyConfig.nsh) $$DESTDIR
    nsis.commands += (echo !define APP_NAME \"$$BRAND\" && echo !define APP_VERSION \"$${VERSION}.0\" && echo !define APP_VER \"$${VER_MAJ}.$${VER_MIN}-$${VER_PAT}\") \
        > $$shell_path($$DESTDIR/Nsis.defines.nsh)

    QMAKE_EXTRA_TARGETS += build_node copyconfig nsis
    POST_TARGETDEPS += build_node copyconfig nsis
    QMAKE_POST_LINK += makensis.exe $$shell_path($$DESTDIR/build.nsi)
}

android {
    QT += androidextras

    DISTFILES += \
        android/AndroidManifest.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew \
        android/gradlew.bat \
        android/res/values/libs.xml \
        qzip/zlib/zlib-1.2.5.zip \
        qzip/zlib/zlib125dll.zip \
        android/src/com/Cellframe/Dashboard/*.java

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    gui_data_static.path = /
    gui_data_static.files = android/*
    INSTALLS += gui_data_static

include($$(OPENSSL_LIB)/openssl.pri)
}

DISTFILES += \
    android/src/com/Cellframe/Dashboard/TCPClient.java \
    android/src/com/Cellframe/Dashboard/TCPServer.java
