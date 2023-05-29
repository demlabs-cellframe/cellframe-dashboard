#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    explicit DapModulesController(QObject *parent = nullptr);

    DapServiceController  *s_serviceCtrl;

    static DapModulesController &getInstance();

    QString testData{"test data"};


};

#endif // DAPMODULESCONTROLLER_H
