#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QClipboard>
#include <iostream>

#include "quickcontrols/qrcodequickitem.h"
#include "dapvpnorderscontroller.h"

#include "Modules/DapModulesController.h"
#include "DapServiceController.h"
#include "mobile/QMLClipboard.h"
#include "Autocomplete/CommandHelperController.h"

#include "Translator/qmltranslator.h"

#include "CellframeNodeQmlWrapper.h"
#include "DapNodePathManager.h"
#include "NotifyController/DapNotifyController.h"

#include "node_globals/NodeGlobals.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

class DapApplication : public QApplication
{
    Q_OBJECT

public:
    DapApplication(int &argc, char **argv);
    ~DapApplication();

    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);
    Q_INVOKABLE void startService();
    Q_INVOKABLE void requestToService(QVariant sName, QVariantList sArgs);

    Q_INVOKABLE void setNodeMode(int mode);
    Q_INVOKABLE int getNodeMode(){return (int)DapNodeMode::getNodeMode();}
    Q_INVOKABLE void setDontShowNodeModeFlag(bool isDontShow);
    Q_INVOKABLE bool getDontShowNodeModeFlag(){return m_dontShowNodeModeFlag;}

    DapModulesController *s_modulesInit;

private:
    void setContextProperties();
    void registerQmlTypes();

    bool m_dontShowNodeModeFlag{false};

    DapModulesController *m_modulesController;
    CommandHelperController* m_commandHelper = nullptr;

    QQmlApplicationEngine m_engine;
    DapServiceController* m_serviceController = nullptr;
    CellframeNodeQmlWrapper* m_nodeWrapper;
    DapNotifyController * s_dapNotifyController;
    DateWorker   *dateWorker;
    QMLTranslator * translator;
};

#endif // DAPAPPLICATION_H
