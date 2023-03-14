#include "diagnosticworker.h"

namespace sendFlagsData
{

bool flagSendData;

bool flagSendSysTime;
bool flagSendDahsTime;
bool flagSendMemory;
bool flagSendMemoryFree;

};

DiagnosticWorker::DiagnosticWorker(DapServiceController * service, QObject * parent)
    : QThread{parent},
      m_service(service)
{

    sendFlagsData::flagSendData       = m_settings.value("SendData").toBool();
    sendFlagsData::flagSendSysTime    = m_settings.value("SendSysTime").toBool();
    sendFlagsData::flagSendDahsTime   = m_settings.value("SendDahsTime").toBool();
    sendFlagsData::flagSendMemory     = m_settings.value("SendMemory").toBool();
    sendFlagsData::flagSendMemoryFree = m_settings.value("SendMemoryFree").toBool();

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
#elif defined Q_OS_WIN
    m_diagnostic = new WinDiahnostic(this);

    connect(m_diagnostic, &WinDiahnostic::data_updated,
            this, &DiagnosticWorker::slot_diagnostic_data,
            Qt::QueuedConnection);

#elif defined Q_OS_MAC
    m_diagnostic = new MacDiahnostic(this);

    connect(m_diagnostic, &MacDiahnostic::data_updated,
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
    QJsonObject proc = data["process"].toObject();

    system.insert("uptime_dashboard", s_uptime);
    obj.insert("system",system);

    if(proc["status"].toString() == "Offline") //if node offline - clear version
        m_node_version = "";
    else
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

    proc.insert("version", m_node_version);
    obj.insert("process",proc);
    data.setObject(obj);

    if(!m_flag_stop_send_data)
        emit signalDiagnosticData(data.toJson());
}

void DiagnosticWorker::slot_uptime()
{
    s_uptime = m_diagnostic->get_uptime_string(s_elapsed_timer->elapsed()/1000);
}

bool DiagnosticWorker::flagSendData() const
{
    return sendFlagsData::flagSendData;
}

void DiagnosticWorker::setflagSendData (const bool &flagSendData)
{
    sendFlagsData::flagSendData = flagSendData;
    m_settings.setValue("SendData", flagSendData);
    emit flagSendDataChanged();
}


bool DiagnosticWorker::flagSendSysTime() const
{
    return sendFlagsData::flagSendSysTime;
}

void DiagnosticWorker::setFlagSendSysTime (const bool &flagSendSysTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendSysTime = flagSendSysTime;
    m_settings.setValue("SendSysTime", flagSendSysTime);
    emit flagSendSysTimeChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendDahsTime() const
{
    return sendFlagsData::flagSendDahsTime;
}

void DiagnosticWorker::setFlagSendDahsTime (const bool &flagSendDahsTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendDahsTime = flagSendDahsTime;
    m_settings.setValue("SendDahsTime", flagSendDahsTime);
    emit flagSendDahsTimeChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendMemory() const
{
    return sendFlagsData::flagSendMemory;
}

void DiagnosticWorker::setFlagSendMemory (const bool &flagSendMemory)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemory = flagSendMemory;
    m_settings.setValue("SendMemory", flagSendMemory);
    emit flagSendMemoryChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendMemoryFree() const
{
    return sendFlagsData::flagSendMemoryFree;
}

void DiagnosticWorker::setFlagSendMemoryFree (const bool &flagSendMemoryFree)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemoryFree = flagSendMemoryFree;
    m_settings.setValue("SendMemoryFree", flagSendMemoryFree);
    emit flagSendMemoryFreeChanged();
    m_flag_stop_send_data = false;
}
