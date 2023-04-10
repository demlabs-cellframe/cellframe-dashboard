QT += core gui network

include(../config.pri)

TARGET = $${BRAND}Service

win32 {
    CONFIG -= console
}

#android {
#    QT += core androidextras
#    TEMPLATE = lib
#    CONFIG += dll
#    TARGET = DashboardService
#}

SOURCES += \
    $$PWD/DapServiceController.cpp \
    $$PWD/main.cpp \
    DapNetSyncController.cpp \
    DapNotificationWatcher.cpp

HEADERS += \
    $$PWD/DapServiceController.h \
    DapNetSyncController.h \
    DapNotificationWatcher.h

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/ -ldap_core
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/libdap_core.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/

unix {
    INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/unix/
}

win32 {
    LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/core/src/win32/ -ldap_core_win32
    INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/include/ \
        $$PWD/../cellframe-node/cellframe-sdk/3rdparty/uthash/src/ \
	$$PWD/../cellframe-node/cellframe-sdk/dap-sdk/core/src/win32/ \
	$$PWD/../cellframe-node/cellframe-sdk/3rdparty/wepoll/
}

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/client/ -ldap_client \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/core/ -ldap_server_core \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/enc_server/ -ldap_enc_server \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/http_server/ -ldap_http_server \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/json_rpc/ -ldap_json_rpc \
    -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/notify_server/ -ldap_notify_srv

#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/client/libdap_client.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/core/libdap_server_core.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/enc_server/libdap_enc_server.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/http_server/libdap_http_server.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/json_rpc/libdap_json_rpc.a \
#    $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/net/server/notify_server/libdap_notify_srv.a


INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/core/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/enc_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/http_server/http_client/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/json_rpc/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/server/notify_server/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/ch/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/stream/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/net/stream/session/include/

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/modules/common/ -ldap_chain_common
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/modules/common/libdap_chain_common.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/modules/common/include/

LIBS += -L$$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/crypto/ -ldap_crypto
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/dap-sdk/crypto/libdap_crypto.a
INCLUDEPATH += $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/include/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/rand/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/ \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/Keccak/FIPS202 \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/high/common \
    $$PWD/../cellframe-node/cellframe-sdk/dap-sdk/crypto/src/XKCP/lib/common

include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)
include (../web3_api/web3_api.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../cellframe-node/ \
               $$_PRO_FILE_PWD_/../dapRPCProtocol/

INCLUDEPATH += $$NODE_BUILD_PATH/cellframe-sdk/deps/include/json-c/
LIBS += $$NODE_BUILD_PATH/cellframe-sdk/deps/lib/libdap_json-c.a
#PRE_TARGETDEPS += $$NODE_BUILD_PATH/cellframe-sdk/deps/lib/libdap_json-c.a

linux-* {
    BUILD_FLAG = static
    service_target.files = $$OUT_PWD/$$TARGET
    service_target.path = /opt/$${BRAND_LO}/bin/
    service_target.CONFIG += no_check_exist
    INSTALLS += service_target
    DEFINES += DAP_OS_LINUX
}

win32 {
    INCLUDEPATH += $$PWD/platforms/win32/service/
    HEADERS += platforms/win32/service/Service.h
    SOURCES += platforms/win32/service/Service.cpp
    LIBS += -lntdll -lpsapi -ljson-c -lmagic -lmqrt -lshlwapi -lregex -ltre -lintl -liconv -lbcrypt -lcrypt32 -lsecur32 -luser32 -lws2_32 -lole32

    CONFIG(debug, debug|release) {
        TARGET_PATH = $$OUT_PWD/debug/$${TARGET}.exe
    }
    CONFIG(release, debug|release) {
        TARGET_PATH = $$OUT_PWD/release/$${TARGET}.exe
    }

   service_target.files = $$TARGET_PATH
   service_target.path = /opt/$${BRAND_LO}/bin/
   #force qmake generate installs in makefiles for unbuilded targets
   service_target.CONFIG += no_check_exist
   INSTALLS += service_target
}

mac {
    QMAKE_LFLAGS += -F /System/Library/Frameworks/Security.framework/
    QMAKE_LFLAGS_SONAME  = -Wl,-install_name,@executable_path/../Frameworks/
    LIBS += -framework Security -framework Carbon -lobjc 
    QMAKE_LIBDIR += /usr/local/lib

    service_target.files = $${OUT_PWD}/$${TARGET}.app
    service_target.path = /
    service_target.CONFIG += no_check_exist

    INSTALLS += service_target
}

unix: !mac {
    LIBS += -lrt
}

RESOURCES += \
    $$PWD/CellFrameDashboardService.qrc

DISTFILES += \
    classdiagram.qmodel

win32: nsis_build {
    DESTDIR = $$shell_path($$_PRO_FILE_PWD_/../build_win32/)
}

#android {
#    TEMPLATE = lib
#    CONFIG += dll
#    QT += androidextras
#    TARGET = DashboardService
#}

linux-* {
    share_target.files = $$PWD/../os/debian/share/
    share_target.path = /opt/cellframe-dashboard/
    INSTALLS += share_target
}
