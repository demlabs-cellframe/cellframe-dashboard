#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"
#include "DapAbstractModule.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    explicit DapModulesController(QObject *parent = nullptr);

public:
    DapServiceController  *s_serviceCtrl;
    QMap<QString, DapAbstractModule*> m_listModules;

    QString testData{"test data"};

public:
    static DapModulesController &getInstance();
    void setListModules(QMap<QString, DapAbstractModule*> &list);
    QMap<QString, DapAbstractModule*> getListModules();


};

#endif // DAPMODULESCONTROLLER_H
