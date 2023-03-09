#include "diagnosticworker.h"

DiagnosticWorker::DiagnosticWorker(DapServiceController * service, QObject * parent)
    : QThread{parent},
      m_service(service)
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

    if(m_node_version.isEmpty())
    {
        m_service->requestToService("DapVersionController", "version node");
        connect(m_service, &DapServiceController::versionControllerResult, [=] (const QVariant& versionResult)
        {
            QJsonObject obj_result = versionResult.toJsonObject();
            if(obj_result["message"] == "Reply node version")
                m_node_version = obj_result["lastVersion"].toString();
        });
    }

    QJsonObject proc = data["process"].toObject();
    proc.insert("version", m_node_version);
    obj.insert("process",proc);
    data.setObject(obj);

    emit signalDiagnosticData(data.toJson());
    qDebug()<<data.toJson();
}

void DiagnosticWorker::slot_uptime()
{
    s_uptime = m_diagnostic->get_uptime_string(s_elapsed_timer->elapsed()/1000);
//    QTime time(0, 0);
//    time = time.addMSecs(s_elapsed_timer->elapsed());
//    s_uptime = time.toString("hh:mm:ss");
}
