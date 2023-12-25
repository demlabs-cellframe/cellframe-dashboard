QT += qml quick widgets svg network

include(../config.pri)
TARGET = $${BRAND}

DEFINES += DAP_SERVICE_NAME=\\\"$${BRAND}Service\\\" \
    DAP_SETTINGS_FILE=\\\"settings.json\\\"

DEFINES += SIMULATOR_DEX

HEADERS += $$PWD/DapServiceController.h \
    Autocomplete/CommandCmdController.h \
    ConfigWorker/configfile.h \
    ConfigWorker/configworker.h \
    DapApplication.h \
    NotifyController/DapNotifyController.h \
    Workers/dateworker.h \
    Workers/mathworker.h \
    Workers/stringworker.h \
    Translator/qmltranslator.h \
    dapvpnorderscontroller.h \
    mobile/QMLClipboard.h \
    mobile/testcontroller.h \
    quickcontrols/qrcodequickitem.h \
    resizeimageprovider.h \
    systemtray.h \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.h \
    windowframerect.h

SOURCES += $$PWD/main.cpp \
    $$PWD/DapServiceController.cpp \
    Autocomplete/CommandCmdController.cpp \
    ConfigWorker/configfile.cpp \
    ConfigWorker/configworker.cpp \
    DapApplication.cpp \
    NotifyController/DapNotifyController.cpp \
    Workers/dateworker.cpp \
    Workers/mathworker.cpp \
    Workers/stringworker.cpp \
    Translator/qmltranslator.cpp \
    dapvpnorderscontroller.cpp \
    mobile/testcontroller.cpp \
    quickcontrols/qrcodequickitem.cpp \
    resizeimageprovider.cpp \
    systemtray.cpp \
    thirdPartyLibs/QRCodeGenerator/QRCodeGenerator.cpp

include (Models/Models.pri)
include($$PWD/Modules/Modules.pri)

win32 {
    RC_ICONS = $$PWD/Resources/icon_win32.ico
    HEADERS += $$PWD/Modules/Diagnostics/WinDiagnostic.h
    SOURCES += $$PWD/Modules/Diagnostics/WinDiagnostic.cpp
}

mac {
    ICON = Resources/CellframeDashboard.icns
    HEADERS += $$PWD/Modules/Diagnostics/MacDiagnostic.h
    SOURCES += $$PWD/Modules/Diagnostics/MacDiagnostic.cpp
}
else: !win32 {
    ICON = qrc:/Resources/icon.ico

    HEADERS += $$PWD/Modules/Diagnostics/LinuxDiagnostic.h
    SOURCES += $$PWD/Modules/Diagnostics/LinuxDiagnostic.cpp
}


!android {
    MOC_DIR = moc
    OBJECTS_DIR = obj
    RCC_DIR = rcc
    UI_DIR = uic
}

INCLUDEPATH += $$_PRO_FILE_PWD_/../dapRPCProtocol/

OTHER_FILES += libdap-qt-ui-qml \
               libdap-qt-ui-chain-wallet

RESOURCES += $$PWD/qml.qrc
RESOURCES += $$PWD/../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.qrc

TRANSLATIONS += \
    Resources/Translations/Translation_ru.ts \
    Resources/Translations/Translation_zh.ts \
    Resources/Translations/Translation_cs.ts \
    Resources/Translations/Translation_pt.ts \
    Resources/Translations/Translation_nl.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: !mac: target.path = /opt/$${BRAND_LO}/bin
!isEmpty(target.path): INSTALLS += target

include (../dap-ui-sdk/qml/libdap-qt-ui-qml.pri)
include (../dap-ui-sdk/core/libdap-qt.pri)

LIBS += -L$$NODE_BUILD_PATH/dap-sdk/core/ -ldap_core
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/dap-sdk/core/libdap_core.a
INCLUDEPATH += $$PWD/../cellframe-node/dap-sdk/core/include/ \
    $$PWD/../cellframe-node/dap-sdk/3rdparty/uthash/src/

unix {
    INCLUDEPATH += $$PWD/../cellframe-node/dap-sdk/core/src/unix/
}

win32 {
    LIBS += -L$$NODE_BUILD_PATH/dap-sdk/core/src/win32/ -ldap_core_win32
    INCLUDEPATH += $$PWD/../cellframe-node/dap-sdk/core/src/win32/ \
        $$PWD/../cellframe-node/dap-sdk/3rdparty/wepoll/
}

LIBS += -L$$NODE_BUILD_PATH/dap-sdk/net/client/ -ldap_client \
    -L$$NODE_BUILD_PATH/dap-sdk/io/ -ldap_io \
    -L$$NODE_BUILD_PATH/dap-sdk/net/server/enc_server/ -ldap_enc_server \
    -L$$NODE_BUILD_PATH/dap-sdk/net/server/http_server/ -ldap_http_server \
    -L$$NODE_BUILD_PATH/dap-sdk/net/server/json_rpc/ -ldap_json_rpc \
    -L$$NODE_BUILD_PATH/dap-sdk/net/server/notify_server/ -ldap_notify_srv

#PRE_TARGETDEPS += $$NODE_BUILD_PATH/dap-sdk/net/client/libdap_client.a \
#    $$NODE_BUILD_PATH/dap-sdk/net/core/libdap_server_core.a \
#    $$NODE_BUILD_PATH/dap-sdk/net/server/enc_server/libdap_enc_server.a \
#    $$NODE_BUILD_PATH/dap-sdk/net/server/http_server/libdap_http_server.a \
#    $$NODE_BUILD_PATH/dap-sdk/net/server/json_rpc/libdap_json_rpc.a \
#    $$NODE_BUILD_PATH/dap-sdk/net/server/notify_server/libdap_notify_srv.a


INCLUDEPATH += $$PWD/../cellframe-node/dap-sdk/net/client/include/ \
    $$PWD/../cellframe-node/dap-sdk/io/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/server/enc_server/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/server/http_server/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/server/http_server/http_client/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/server/json_rpc/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/server/notify_server/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/stream/ch/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/stream/stream/include/ \
    $$PWD/../cellframe-node/dap-sdk/net/stream/session/include/

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/modules/common/ -ldap_chain_common
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/modules/common/libdap_chain_common.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/modules/common/include/

LIBS += -L$$NODE_BUILD_PATH/dap-sdk/crypto/ -ldap_crypto
LIBS += -L$$NODE_BUILD_PATH/dap-sdk/crypto/src/Kyber/crypto_kem/kyber512/optimized/ -ldap_crypto_kyber512
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/dap-sdk/crypto/libdap_crypto.a
INCLUDEPATH += $$PWD/../cellframe-node/dap-sdk/crypto/include/ \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/rand/ \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/ \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/Kyber/crypto_kem/kyber512/optimized \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/XKCP/lib/high/Keccak/FIPS202 \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/XKCP/lib/high/common \
    $$PWD/../cellframe-node/dap-sdk/crypto/src/XKCP/lib/common

INCLUDEPATH += $$NODE_BUILD_PATH/dap-sdk/deps/include/json-c/
LIBS += -L$$NODE_BUILD_PATH/dap-sdk/deps/lib/ -ldap_json-c
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/deps/lib/libdap_json-c.a

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../cellframe-ui-sdk/ui/chain/wallet/libdap-qt-ui-chain-wallet.pri)

linux-* {
    LIBS += -lrt -lmagic
    gui_target.files = $$OUT_PWD/$${BRAND}
    gui_target.path = /opt/$${BRAND_LO}/bin/
    INSTALLS += gui_target
    BUILD_FLAG = static
}

win32  {
    LIBS += -lntdll -lpsapi -lmagic -lmqrt -lshlwapi -lregex -ltre -lintl -liconv -lbcrypt -lcrypt32 -lsecur32 -luser32 -lws2_32 -lole32
    CONFIG(debug, debug|release) {
            TARGET_PATH = $$OUT_PWD/debug/$${TARGET}.exe
    }
    CONFIG(release, debug|release) {
            TARGET_PATH = $$OUT_PWD/release/$${TARGET}.exe
    }

    gui_target.files = $$TARGET_PATH
    gui_target.path = /opt/$${BRAND_LO}/bin/
    #force qmake generate installs in makefiles for unbuilded targets
    gui_target.CONFIG += no_check_exist
    INSTALLS += gui_target

    nsisfmt.commands += (echo !define APP_NAME \"$$BRAND\" && \
                        echo !define APP_VERSION \"$${VERSION}.0\" && \
			echo !define APP_VER \"$${VER_MAJ}.$${VER_MIN}-$${VER_PAT}\") \
			> $$shell_path($$OUT_PWD/nsis.defines.nsh)

    QMAKE_EXTRA_TARGETS += nsisfmt
    POST_TARGETDEPS += nsisfmt

    nsisfmt_target.files = $$OUT_PWD/nsis.defines.nsh
    nsisfmt_target.path = /
    nsisfmt_target.CONFIG += no_check_exist

    nsis_target.files = $$PWD/../os/windows/*
    nsis_target.path = /

    icon_target.files = $$RC_ICONS
    icon_target.path = /

    INSTALLS += nsis_target nsisfmt_target icon_target
}

mac {
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Security.framework/
    QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/../Frameworks/
    LIBS += -framework Security -framework Carbon -lobjc
        
    QMAKE_INFO_PLIST = $$_PRO_FILE_PWD_/../os/macos/Info.plist
    QMAKE_PROVISIONING_PROFILE=1677e600-eb71-4cab-a38f-13b4aa7bd976
    QMAKE_DEVELOPMENT_TEAM=5W95PVWDQ3
        
    gui_target.files = $${OUT_PWD}/$${TARGET}.app
    gui_target.path = /
    gui_target.CONFIG += no_check_exist
    INSTALLS += gui_target


    DASHBOARD_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cellframe-uninstaller \
        $$_PRO_FILE_PWD_/../os/macos/com.demlabs.Cellframe-DashboardService.plist \
	$$_PRO_FILE_PWD_/../os/macos/com.demlabs.cellframe-node.plist \
	$$_PRO_FILE_PWD_/../os/macos/uninstall \
	$$_PRO_FILE_PWD_/../os/macos/uninstall_icon.rsrc
    DASHBOARD_RESOURCES.path = Contents/Resources

    DASHBOARD_CLEANUP_RESOURCES.files += $$_PRO_FILE_PWD_/../os/macos/cleanup/
    DASHBOARD_CLEANUP_RESOURCES.path = Contents/Resources/cleunup/
        
    QMAKE_BUNDLE_DATA += DASHBOARD_RESOURCES DASHBOARD_CLEANUP_RESOURCES

    pkginstall.files = $$_PRO_FILE_PWD_/../os/macos/PKGINSTALL/
    pkginstall.path = /
    INSTALLS += pkginstall
}

#android {
#    QT += androidextras

#    DISTFILES += \
#        android/AndroidManifest.xml \
#        android/build.gradle \
#        android/gradle/wrapper/gradle-wrapper.jar \
#        android/gradle/wrapper/gradle-wrapper.properties \
#        android/gradlew \
#        android/gradlew.bat \
#        android/res/values/libs.xml \
#        qzip/zlib/zlib-1.2.5.zip \
#        qzip/zlib/zlib125dll.zip \
#        android/src/com/Cellframe/Dashboard/*.java

#    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

#    gui_data_static.path = /
#    gui_data_static.files = android/*
#    INSTALLS += gui_data_static

#include($$(OPENSSL_LIB)/openssl.pri)
#}
