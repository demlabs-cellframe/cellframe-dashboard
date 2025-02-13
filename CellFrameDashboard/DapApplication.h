#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <iostream>

#include <QQmlApplicationEngine>

#include "DapGuiApplication.h"
#include "quickcontrols/qrcodequickitem.h"
#include "dapvpnorderscontroller.h"

#include "Modules/DapModulesController.h"
#include "DapServiceController.h"
#include "mobile/QMLClipboard.h"
#include "Autocomplete/CommandHelperController.h"

#include "CellframeNodeQmlWrapper.h"
#include "NotifyController/DapNotifyController.h"

#include "node_globals/NodeGlobals.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

class DapApplication : public QObject
{
    Q_OBJECT

public:
    DapApplication(QObject *parent = nullptr);
    ~DapApplication();

    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);
    Q_INVOKABLE void startService();
    Q_INVOKABLE void requestToService(QVariant sName, QVariantList sArgs);

    Q_INVOKABLE void setRPCAddress(QString address);
    Q_INVOKABLE QString getRPCAddress(){return QString::fromStdString(DapNodeMode::getRPCAddress());}
    Q_INVOKABLE void resetRPCAddress();
    Q_INVOKABLE void setNodeMode(int mode);
    Q_INVOKABLE int getNodeMode(){return (int)DapNodeMode::getNodeMode();}
    Q_INVOKABLE void setDontShowNodeModeFlag(bool isDontShow);
    Q_INVOKABLE bool getDontShowNodeModeFlag(){return m_dontShowNodeModeFlag;}

    void setGuiApp(DapGuiApplication *guiApp);
    void clearData();
    void setCountRestart(int count) { m_countRestart = count; }
private:
    void initMigrateWallets();
private:
    void setContextProperties();
    void registerQmlTypes();

    void createPaths();

    bool m_dontShowNodeModeFlag{false};

    DapModulesController     *m_modulesController    = nullptr;
    CommandHelperController  *m_commandHelper        = nullptr;

    QQmlApplicationEngine    *m_engine               = nullptr;
    DapServiceController     *m_serviceController    = nullptr;
    CellframeNodeQmlWrapper  *m_nodeWrapper          = nullptr;
    DapNotifyController      *s_dapNotifyController  = nullptr;
    DateWorker               *dateWorker             = nullptr;

    DapGuiApplication *m_guiApp = nullptr;

    int m_countRestart = 0;
};

#endif // DAPAPPLICATION_H
