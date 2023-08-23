#include "DapModuleLogs.h"

#include <QDebug>
#include <QRegularExpression>
#include "loginfo.h"
#include "qqmlcontext.h"

#if defined (Q_OS_MACOS)
#include "dap_common.h"
#endif

#ifdef Q_OS_WIN
#include "registry.h"
#endif

static LogModel *s_logModel = LogModel::global();

DapModuleLog::DapModuleLog(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_logReader(new DapLogsReader(this))
//    , nodeLog(getNodeLogPath(), "cellframe-node", false)
//    , guiLog(getBrandLogPath(), "Cellframe-DashboardGUI", true)
//    , serviceLog(getBrandLogPath(), "Cellframe-DashboardService", true)
//    , currentLog(&nodeLog)
{
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("logModel", s_logModel);

    connect(m_logReader, &DapLogsReader::sigLogUpdated, [=] {
        updateModel();
    });

    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        m_configLog.first = LogType::NodeLog;
        m_configLog.second = getLogFileName(getNodeLogPath(), m_configLog.first);
        m_logReader->setLogType(m_configLog.second);
        setStatusInit(true);
    });

    connect(s_serviceCtrl, &DapServiceController::exportLogs, [=] (const QVariant& rcvData)
    {
        emit logsExported(rcvData.toBool());
    });


//    nodeLog.updateLog();
//    guiLog.updateLog();
//    serviceLog.updateLog();

//    guiLog.updateLines(3027, bufferSize);

//    nodeLog.updateLines(0, bufferSize);
//    guiLog.updateLines(0, bufferSize);
//    serviceLog.updateLines(0, bufferSize);

//    selectLog("Node");

//    parseLine("[04/19/23-11:07:42] [DAP] [main] *** CellFrame Node version: 5-1.381 ***");
//    parseLine("[04/24/23-13:48:22] [ERR] [dap_client_pvt] [cl:00000000329070f0] ENC: Can't init ecnryption session, err code 138\n");

//    qDebug() << "DapModuleLog::DapModuleLog"
//             << DAP_BRAND
//             << DAP_BRAND_BASE_LO
    //             << DAP_BRAND_LO;
}

bool DapModuleLog::flagLogUpdate()
{
    return m_flagLogUpdate;
}

void DapModuleLog::setFlagLogUpdate(bool flag)
{
    if(m_flagLogUpdate == flag)
        return;

    m_flagLogUpdate = flag;
    m_logReader->setStatusUpdate(flag);
    emit flagLogUpdateChanged();
}

void DapModuleLog::exportLog(QString newPath, int type, QString period)
{
#ifdef Q_OS_WIN
    if(newPath[0] == "/" || newPath[0] == "\\" )
            newPath.remove(0,1);
#endif
//    qDebug()<< newPath << type << period;
    QString originPath = getLogPath(LogType(type));
    s_serviceCtrl->requestToService("DapExportLogCommand",QStringList()
                                    <<QString(originPath)
                                    <<QString(newPath)
                                    <<QString(period));
}

void DapModuleLog::fullUpdate()
{
//    nodeLog.updateAll();
//    guiLog.updateAll();
//    serviceLog.updateAll();
}

void DapModuleLog::selectLog(const QString &name)
{
    s_logModel->clear();

    if (name == "Node")
        m_configLog.first = LogType::NodeLog;
    if (name == "Service")
        m_configLog.first = LogType::ServiceLog;
    if (name == "GUI")
        m_configLog.first = LogType::GuiLog;

    m_configLog.second = getLogPath(m_configLog.first);

    m_logReader->setLogType(m_configLog.second);

    emit currentTypeChanged();

//    currentIndex = 0;

//    currentLog->updateLines(currentIndex, bufferSize);

//    updateModel();
}

QString DapModuleLog::getLogPath(LogType type)
{
    QString path;
    switch (type) {
    case LogType::NodeLog:
        path = getLogFileName(getNodeLogPath(), type);
        break;
    case LogType::ServiceLog:
        path = getLogFileName(getBrandLogPath(), type);
        break;
    case LogType::GuiLog:
        path = getLogFileName(getBrandLogPath(), type);
        break;
    default:
        break;
    }

    return path;
}

QString DapModuleLog::getLogFileName(QString folder, LogType type)
{
    QDir currentFolder(folder);

    currentFolder.setFilter(QDir::Files | QDir::NoSymLinks );
    currentFolder.setSorting( QDir::Name );

    QFileInfoList folderitems(currentFolder.entryInfoList());

    QString fileName = type == LogType::NodeLog    ? "cellframe-node"
                     : type == LogType::ServiceLog ? "Cellframe-DashboardService"
                                                   : "Cellframe-DashboardGUI";

    QStringList filesList;

    foreach ( QFileInfo i, folderitems ) {
        QString iname( i.fileName() );
        if ( iname == "." || iname == ".." || iname.isEmpty() )
            continue;
        if(i.suffix() == "log" && i.completeBaseName().contains(fileName))
        {
            filesList.append(i.absoluteFilePath());
        }
    }
    if(filesList.isEmpty())
        return "";

    if(filesList.count() == 1)
        return filesList.first();
    else if(filesList.count() > 1)
    {
        quint64 dates[filesList.count()];

        for(int i = 0; i < filesList.count(); i++)
        {
            QRegularExpression regex(
                "("+fileName+"_(.+).log)");
            QRegularExpressionMatch match = regex.match(filesList[i]);

            if(!match.captured(2).isEmpty())
                dates[i] = QDateTime::fromString(match.captured(2),"dd-MM-yyyy").toSecsSinceEpoch();
        }

        int maxIdx = 0;
        for(int i = 1; i < filesList.count(); i++)
            maxIdx = dates[i] > dates[maxIdx] ? i : maxIdx;

        return filesList.at(maxIdx);
    }
    else
        return QString();
}

void DapModuleLog::setPosition(double pos)
{
//    currentIndex = currentLog->getLength() * pos;

//    if (currentIndex < 0)
//        currentIndex = 0;
//    if (currentIndex >= currentLog->getLength())
//        currentIndex = currentLog->getLength()-1;

////    qDebug() << "DapModuleLog::setPosition" << pos
////             << "currentIndex" << currentIndex
////             << "currentLog->getLength()" << currentLog->getLength();

//    currentLog->updateLines(currentIndex, bufferSize);

//    updateModel();
}

void DapModuleLog::changePosition(double step)
{
//    currentIndex += step * bufferSize;

//    if (currentIndex < 0)
//        currentIndex = 0;
//    if (currentIndex >= currentLog->getLength())
//        currentIndex = currentLog->getLength()-1;

////    qDebug() << "DapModuleLog::changePosition" << step
////             << "currentIndex" << currentIndex
////             << "currentLog->getLength()" << currentLog->getLength();

//    currentLog->updateLines(currentIndex, bufferSize);

//    updateModel();
}

double DapModuleLog::getPosition()
{
//    double pos = static_cast<double>(currentIndex)/currentLog->getLength();
//    return pos;
}

double DapModuleLog::getScrollSize()
{
//    double pos = static_cast<double>(bufferSize)/currentLog->getLength();
//    return pos;
}

QString DapModuleLog::getLineText(qint64 index)
{

//    const QStringList &lines = currentLog->getLines();

    if (index < 0 || index >= s_logModel->size())
        return QString();
    else
    {
        LogModel::Item itm = s_logModel->at(index);
        QString res = QString(itm.date + " " + itm.time + " " +
                              itm.type + " " + itm.file + " " + itm.info);
        return res;
    }
}

void DapModuleLog::updateLog()
{
//    currentLog->updateLog();
}

QString DapModuleLog::getNodeLogPath()
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    return QString("/opt/%1-node/var/log").arg(DAP_BRAND_BASE_LO);
#elif defined (Q_OS_MACOS)
    char * l_username = NULL;
    exec_with_ret(&l_username,"whoami|tr -d '\n'");
    if (!l_username)
    {
        qWarning() << "Fatal Error: Can't obtain username";
        return QString();
    }
    return QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/log").arg(l_username);
#elif defined (Q_OS_WIN)
    return QString("%1/cellframe-node/var/log").arg(regWGetUsrPath());
#elif defined Q_OS_ANDROID
    return QString("/sdcard/cellframe-node/var/log");
#else
    return QString();
#endif
}

QString DapModuleLog::getBrandLogPath()
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    return QString("/var/log/%1-dashboard").arg(DAP_BRAND_BASE_LO);
#elif defined (Q_OS_MACOS)
    char * l_username = NULL;
    exec_with_ret(&l_username,"whoami|tr -d '\n'");
    if (!l_username)
    {
        qWarning() << "Fatal Error: Can't obtain username";
        return QString();
    }
    return QString("/var/log/%1-dashboard").arg(DAP_BRAND_BASE_LO);
#elif defined (Q_OS_WIN)
    return QString("%1/%2/log").arg(regWGetUsrPath()).arg(DAP_BRAND);
#elif defined Q_OS_ANDROID
    return QString("/sdcard/cellframe-node/var/log");
#else
    return QString();
#endif
}

LogModel::Item DapModuleLog::parseLine(const QString &line)
{
    bool apTimeFormat = false;
    QRegularExpression regex(
        R"(\[(\S+)-(\S+)\] \[\s*(\S+)\s*\] \[(\S*)\] (.*)\n?)");
    QRegularExpressionMatch match = regex.match(line);

    if(!match.hasMatch())
    {
        QRegularExpression regex2(
            R"(\[(\S+)-(\S+)\ (.+)] \[\s*(\S+)\s*\] \[(\S*)\] (.*)\n?)");
        match = regex2.match(line);

        apTimeFormat = match.hasMatch();
    }

    int idx = apTimeFormat ? 1 : 0;

    LogModel::Item item;
    item.type = match.captured(idx+3);
    item.info = match.captured(idx+5);
    item.file = match.captured(idx+4);
    item.time = match.captured(2);
//    item.date = match.captured(1);

//    qDebug() << "DapModuleLog::parseLine"
//             << line
//             << "\nOUT"
//             << match.captured(1)
//             << match.captured(2)
//             << match.captured(3)
//             << match.captured(4)
//             << match.captured(5);

    QString date = match.captured(1);

    QRegularExpression regexDate(R"((\S+)/(\S+)/(\S+))");
    match = regexDate.match(date);
    item.date = "20"+match.captured(3)+
            "-"+match.captured(1)+
            "-"+match.captured(2);

    return item;
}

void DapModuleLog::updateModel()
{
    const QStringList &lines = m_logReader->getLogList();

//    qDebug() << "DapModuleLog::outModel";
    if(s_logModel->size() > lines.count())
        s_logModel->clear();

    if(s_logModel->isEmpty())
    {
        for (int i = 0; i < lines.count(); i++)
            s_logModel->add(parseLine(lines[i]));
    }
    else
    {
        for (int i = 0; i < lines.count(); i++)
        {
            if(lines.count() > s_logModel->size() && i >= s_logModel->size())
                s_logModel->add(parseLine(lines[i]));
            else
                s_logModel->set(i,parseLine(lines[i]));
        }
    }

    if(m_logReader->m_path.isEmpty())
        m_logReader->m_path = getLogPath(m_configLog.first);
}
