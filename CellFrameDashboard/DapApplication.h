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
#include "DapNodePathManager.h"
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
    // Q_INVOKABLE void requestToService(QVariant sName, QVariantList sArgs);

    Q_INVOKABLE void setNodeMode(int mode);
    Q_INVOKABLE int getNodeMode(){return (int)DapNodeMode::getNodeMode();}
    Q_INVOKABLE void setDontShowNodeModeFlag(bool isDontShow);
    Q_INVOKABLE bool getDontShowNodeModeFlag(){return m_dontShowNodeModeFlag;}

    void setGuiApp(DapGuiApplication *guiApp);
    void clearData();

    DapServiceController* getServiceController() const { return m_serviceController; }

    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &args = QVariant());
    Q_INVOKABLE void tryRemoveTransactions(const QVariant& transactions);
signals:
    void requestToServiceSignal(const QString& asServiceName, const QVariant &args = QVariant());
private:
    void setContextProperties();
    void registerQmlTypes();

    bool m_dontShowNodeModeFlag{false};

    DapModulesController     *m_modulesController    = nullptr;
    CommandHelperController  *m_commandHelper        = nullptr;

    QQmlApplicationEngine    *m_engine               = nullptr;
    // QThread* m_threadService                         = nullptr;
    DapServiceController     *m_serviceController    = nullptr;
    CellframeNodeQmlWrapper  *m_nodeWrapper          = nullptr;
    DapNotifyController      *s_dapNotifyController  = nullptr;
    DateWorker               *dateWorker             = nullptr;

    DapGuiApplication *m_guiApp = nullptr;
};

#endif // DAPAPPLICATION_H
