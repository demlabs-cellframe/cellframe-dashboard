#ifndef DIAGNOSTICWORKER_H
#define DIAGNOSTICWORKER_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>
#include "../DapServiceController.h"

#ifdef Q_OS_LINUX
    #include <unistd.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include "linuxdiahnostic.h"
#elif defined Q_OS_WIN

#endif


class DiagnosticWorker : public QThread
{
    Q_OBJECT
public:
    explicit DiagnosticWorker(DapServiceController * service, QObject *parent = nullptr);
    ~DiagnosticWorker();

private:
    DapServiceController * m_service;
    QString m_node_version{""};

#ifdef Q_OS_LINUX
    LinuxDiahnostic* m_diagnostic;
#elif defined Q_OS_WIN

#endif

//public slots:
//    void diagnostic_data(QJsonDocument);

private slots:
    void slot_diagnostic_data(QJsonDocument);
    void slot_uptime();

public:

    QTimer *s_uptime_timer;
    QElapsedTimer *s_elapsed_timer;
    QString s_uptime{"00:00:00"};

signals:
    void signalDiagnosticData(QByteArray);
};

#endif // DIAGNOSTICWORKER_H
