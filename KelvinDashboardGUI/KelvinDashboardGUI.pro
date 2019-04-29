QT += quick widgets quickwidgets

TEMPLATE = app
CONFIG += c++11


!defined(BRAND,var){
#  Default brand
    BRAND = KelvinDashboard
}

TARGET = $$BRAND

VER_MAJ = 1
VER_MIN = 0
VER_PAT = 0


win32 {
    VERSION = $${VER_MAJ}.$${VER_MIN}.$$VER_PAT
}
else {
    VERSION = $$VER_MAJ\.$$VER_MIN\-$$VER_PAT
}

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += DAP_BRAND=\\\"$$BRAND\\\"
DEFINES += DAP_VERSION=\\\"$$VERSION\\\"
ICON = Resources/Icons/icon.ico
# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
    DapUiQmlWidgetChainBallance.cpp \
    DapUiQmlWidgetChainBlockExplorer.cpp \
    DapUiQmlWidgetChainNodeLogs.cpp \
    DapUiQmlWidgetChainTransctions.cpp \
    DapUiQmlWidgetChainOperations.cpp \
    DapScreenLogin.cpp \
    DapClient.cpp \
    DapUiQmlWidgetModel.cpp \
    DapUiQmlWidget.cpp \
    DapScreenDialog.cpp \
    DapScreenDialogChangeWidget.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    DapUiQmlWidgetChainBallance.h \
    DapUiQmlWidgetChainBlockExplorer.h \
    DapUiQmlWidgetChainNodeLogs.h \
    DapUiQmlWidgetChainTransctions.h \
    DapUiQmlScreenDashboard.h \
    DapUiQmlWidgetChainOperations.h \
    DapScreenLogin.h \
    DapClient.h \
    DapUiQmlWidgetModel.h \
    DapUiQmlWidget.h \
    DapScreenDialog.h \
    DapScreenDialogChangeWidget.h


include (../libKelvinDashboardCommon/libKelvinDashboardCommon.pri)
INCLUDEPATH += $$_PRO_FILE_PWD_/../libKelvinDashboardCommon/
	       $$_PRO_FILE_PWD_/../libdap/

DISTFILES +=
