#include "diagnosticworker.h"

DiagnosticWorker::DiagnosticWorker(QObject * parent)
    : QThread{parent}
{

    s_uptime_timer = new QTimer(this);
    connect(s_uptime_timer, &QTimer::timeout,
            this, &DiagnosticWorker::slot_uptime,
            Qt::QueuedConnection);

    s_uptime_timer->start(1000);

    s_elapsed_timer = new QElapsedTimer();
    s_elapsed_timer->start();

#ifdef Q_OS_LINUX
    m_diagnostic = new LinuxDiahnostic(this);

    connect(m_diagnostic, &LinuxDiahnostic::data_updated,
            this, &DiagnosticWorker::slot_diagnostic_data,
            Qt::QueuedConnection);
#endif

    m_diagnostic->start_diagnostic();
}
DiagnosticWorker::~DiagnosticWorker()
{
    delete s_uptime_timer;
    delete s_elapsed_timer;
    delete m_diagnostic;

    quit();
    wait();
}

void DiagnosticWorker::slot_diagnostic_data(QJsonDocument data)
{
    //insert uptime dashboard into system info
    QJsonObject obj = data.object();
    QJsonObject system = data["system"].toObject();
    system.insert("uptime_dashboard", s_uptime);
    obj.insert("system",system);

    data.setObject(obj);

    emit signalDiagnosticData(data.toJson());
    qDebug()<<data.toJson();
}

void DiagnosticWorker::slot_uptime()
{
    QTime time(0, 0);
    time = time.addMSecs(s_elapsed_timer->elapsed());
    s_uptime = time.toString("hh:mm:ss");
}
