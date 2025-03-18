HEADERS += $$PWD/DapDataManagerController.h \
    $$PWD/DapAbstractDataManager.h \
    $$PWD/FeeManager/DapFeeManager.h \
    $$PWD/FeeManager/DapFeeManagerBase.h \
    $$PWD/NetworkManager/DapNetworksManagerBase.h \
    $$PWD/NetworkManager/DapNetworksManagerLocal.h \
    $$PWD/NetworkManager/DapNetworksManagerRemote.h \
    $$PWD/NetworkManager/DapNetworksTypes.h \
    $$PWD/TransactionManager/DapTransactionManager.h \
    $$PWD/WalletsManager/DapWalletsManager.h \
    $$PWD/WalletsManager/DapWalletsManagerBase.h \
    $$PWD/WalletsManager/DapWalletsManagerNode.h

 SOURCES += $$PWD/DapDataManagerController.cpp \
    $$PWD/DapAbstractDataManager.cpp \
    $$PWD/FeeManager/DapFeeManager.cpp \
    $$PWD/FeeManager/DapFeeManagerBase.cpp \
    $$PWD/NetworkManager/DapNetworksManagerBase.cpp \
    $$PWD/NetworkManager/DapNetworksManagerLocal.cpp \
    $$PWD/NetworkManager/DapNetworksManagerRemote.cpp \
    $$PWD/TransactionManager/DapTransactionManager.cpp \
    $$PWD/WalletsManager/DapWalletsManager.cpp \
    $$PWD/WalletsManager/DapWalletsManagerBase.cpp \
    $$PWD/WalletsManager/DapWalletsManagerNode.cpp

INCLUDEPATH += $$PWD
INCLUDEPATH += $$PWD/NetworkManager
INCLUDEPATH += $$PWD/WalletsManager
INCLUDEPATH += $$PWD/FeeManager
INCLUDEPATH += $$PWD/TransactionManager
