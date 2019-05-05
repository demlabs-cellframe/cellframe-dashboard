#ifndef MAINPROCESS_H
#define MAINPROCESS_H

#include <QObject>
#include <QTimer>
#include <QObject>
#include <QThread>
#include <QApplication>

#include "Config.h"
#include "DapChainDashboardService.h"

class MainProcess : public QObject
{
    sConfig* volatile                   config;
    DapChainDashboardService service;
    Q_OBJECT
public:
    explicit MainProcess(sConfig*conf, QObject *parent = nullptr);
    ~MainProcess();
    
    bool        init();

signals:
    
public slots:
    void initTray();
};

#endif // MAINPROCESS_H
