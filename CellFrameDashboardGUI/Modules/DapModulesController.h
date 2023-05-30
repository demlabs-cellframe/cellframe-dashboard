#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "DapAbstractModule.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);

    ~DapModulesController();

    void initModules();

    void addModule(const QString &key, DapAbstractModule *p_module);

    DapAbstractModule* getModule(const QString &key);

private:
    QQmlApplicationEngine *s_appEngine;

    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
};

#endif // DAPMODULESCONTROLLER_H
