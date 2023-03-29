QT += gui
QT += core
CONFIG += c++11
QMAKE_CFLAGS += -std=gnu11

include(../config.pri)

QT += core network

!win32 {
    CONFIG += console
}

LIBS += -ldl

TARGET = $${BRAND}Service

win32 {
    CONFIG -= console
    DEFINES += HAVE_STRNDUP
}

android: {
    QT += core androidextras
    TEMPLATE = lib
    CONFIG += dll
    TARGET = DashboardService
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
    $$PWD/DapServiceController.cpp \
    $$PWD/main.cpp \
    DapNetSyncController.cpp \
    DapNotificationWatcher.cpp \
    DapWeb3Api/DapProcessingNodeFunc.cpp \
    DapWeb3Api/DapWebControll.cpp

HEADERS += \
    $$PWD/DapServiceController.h \
    DapNetSyncController.h \
    DapNotificationWatcher.h \
    DapWeb3Api/DapWebControll.h

include (../dap-ui-sdk/core/libdap-qt.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/core/libdap.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/net/libdap-net.pri)
include (../cellframe-node/cellframe-sdk/dap-sdk/crypto/libdap-crypto.pri)

#include (../cellframe-node/cellframe-sdk/modules/service/stake_lock/stake_lock.pri)
#include (../cellframe-node/cellframe-sdk/modules/net/srv/srv.pri)
#include (../cellframe-node/cellframe-sdk/modules/channel/chain-net-srv/chain-net-srv.pri)
#include (../cellframe-node/cellframe-sdk/modules/wallet/wallet.pri)
#include (../cellframe-node/cellframe-sdk/modules/mempool/mempool.pri)
#include(../cellframe-node/cellframe-sdk/3rdparty/crc32c_adler/crc32c_adler.pri)

include (../cellframe-node/cellframe-sdk/modules/common/common.pri)

include (../cellframe-ui-sdk/chain/wallet/libdap-qt-chain-wallet.pri)

INCLUDEPATH += $$_PRO_FILE_PWD_/../cellframe-node/
               $$_PRO_FILE_PWD_/../dapRPCProtocol/

unix: !mac : !android {
    
    BUILD_FLAG = static

    service_target.files = $$OUT_PWD/$$TARGET
    service_target.path = /opt/$${BRAND_LO}/bin/
    service_target.CONFIG += no_check_exist
    
    INSTALLS += service_target
}

unix: !mac  {
    INCLUDEPATH += ../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += ../CellFrameNode/build_linux_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}

win32 {
    INCLUDEPATH += ../CellFrameNode/build_windows_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += ../CellFrameNode/build_windows_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}

mac {
    INCLUDEPATH += ../CellFrameNode/build_osx_release/build/cellframe-sdk/deps/include/json-c/
    LIBS += ../CellFrameNode/build_osx_release/build/cellframe-sdk/deps/lib/libdap_json-c.a
}


win32 {

    INCLUDEPATH += $$PWD/platforms/win32/service/
    HEADERS += platforms/win32/service/Service.h
    SOURCES += platforms/win32/service/Service.cpp

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
    
    service_target.files = $${OUT_PWD}/$${TARGET}.app
    service_target.path = /
    service_target.CONFIG += no_check_exist
    
    INSTALLS += service_target
}


RESOURCES += \
    $$PWD/CellFrameDashboardService.qrc

DISTFILES += \
    classdiagram.qmodel

win32: nsis_build {
    DESTDIR = $$shell_path($$_PRO_FILE_PWD_/../build_win32/)
}

android {
    TEMPLATE = lib
    CONFIG += dll
    QT += androidextras
    TARGET = DashboardService
}

unix: !mac : !android {

    share_target.files = $$PWD/../os/debian/share/
    share_target.path = /opt/cellframe-dashboard/
   
    INSTALLS += share_target
}
