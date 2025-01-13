HEADERS += $$PWD/DapDataManagerController.h \
    $$PWD/DapAbstractDataManager.h \
    $$PWD/NetworkManager/DapNetworksManager.h \
    $$PWD/NetworkManager/DapNetworksManagerBase.h \
    $$PWD/NetworkManager/DapNetworksManagerRemote.h \
    $$PWD/NetworkManager/DapNetworksTypes.h

 SOURCES += $$PWD/DapDataManagerController.cpp \
    $$PWD/DapAbstractDataManager.cpp \
    $$PWD/NetworkManager/DapNetworksManager.cpp \
    $$PWD/NetworkManager/DapNetworksManagerBase.cpp \
    $$PWD/NetworkManager/DapNetworksManagerRemote.cpp

INCLUDEPATH += $$PWD
INCLUDEPATH += $$PWD/NetworkManager
