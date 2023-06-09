#include "DapModuleLogs.h"

#include <QDebug>
#include <QRegularExpression>
#include "loginfo.h"

#if defined (Q_OS_MACOS)
#include "dap_common.h"
#endif

#ifdef Q_OS_WIN
#include "registry.h"
#endif

static LogModel *s_logModel = LogModel::global();

DapModuleLog::DapModuleLog(QQmlContext *context, QObject *parent)
    : DapAbstractModule(parent)
    , s_context(context)
    , nodeLog(getNodeLogPath(), "cellframe-node", false)
    , guiLog(getBrandLogPath(), "Cellframe-DashboardGUI", true)
    , serviceLog(getBrandLogPath(), "Cellframe-DashboardService", true)
    , currentLog(&nodeLog)
{
    context->setContextProperty("logModel", s_logModel);

//    nodeLog.updateLog();
//    guiLog.updateLog();
//    serviceLog.updateLog();

//    guiLog.updateLines(3027, bufferSize);

    nodeLog.updateLines(0, bufferSize);
    guiLog.updateLines(0, bufferSize);
    serviceLog.updateLines(0, bufferSize);

    selectLog("Node");

//    parseLine("[04/19/23-11:07:42] [DAP] [main] *** CellFrame Node version: 5-1.381 ***");
//    parseLine("[04/24/23-13:48:22] [ERR] [dap_client_pvt] [cl:00000000329070f0] ENC: Can't init ecnryption session, err code 138\n");

//    qDebug() << "DapModuleLog::DapModuleLog"
//             << DAP_BRAND
//             << DAP_BRAND_BASE_LO
    //             << DAP_BRAND_LO;
}

void DapModuleLog::fullUpdate()
{
    nodeLog.updateAll();
    guiLog.updateAll();
    serviceLog.updateAll();
}

void DapModuleLog::selectLog(const QString &name)
{
    if (name == "Node")
        currentLog = &nodeLog;
    if (name == "Service")
        currentLog = &serviceLog;
    if (name == "GUI")
        currentLog = &guiLog;

    currentIndex = 0;

    currentLog->updateLines(currentIndex, bufferSize);

    updateModel();
}

void DapModuleLog::setPosition(double pos)
{
    currentIndex = currentLog->getLength() * pos;

    if (currentIndex < 0)
        currentIndex = 0;
    if (currentIndex >= currentLog->getLength())
        currentIndex = currentLog->getLength()-1;

//    qDebug() << "DapModuleLog::setPosition" << pos
//             << "currentIndex" << currentIndex
//             << "currentLog->getLength()" << currentLog->getLength();

    currentLog->updateLines(currentIndex, bufferSize);

    updateModel();
}

void DapModuleLog::changePosition(double step)
{
    currentIndex += step * bufferSize;

    if (currentIndex < 0)
        currentIndex = 0;
    if (currentIndex >= currentLog->getLength())
        currentIndex = currentLog->getLength()-1;

//    qDebug() << "DapModuleLog::changePosition" << step
//             << "currentIndex" << currentIndex
//             << "currentLog->getLength()" << currentLog->getLength();

    currentLog->updateLines(currentIndex, bufferSize);

    updateModel();
}

double DapModuleLog::getPosition()
{
    double pos = static_cast<double>(currentIndex)/currentLog->getLength();
    return pos;
}

double DapModuleLog::getScrollSize()
{
    double pos = static_cast<double>(bufferSize)/currentLog->getLength();
    return pos;
}

QString DapModuleLog::getLineText(qint64 index)
{
    const QStringList &lines = currentLog->getLines();
    if (index < 0 || index >= lines.size())
        return QString();
    else
        return lines.at(index);
}

void DapModuleLog::updateLog()
{
    currentLog->updateLog();
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
    return QString("%1/%2/log").arg(regWGetUsrPath()).arg(DAP_BRAND);
#elif defined Q_OS_ANDROID
    return QString("/sdcard/cellframe-node/var/log");
#else
    return QString();
#endif
}

LogModel::Item DapModuleLog::parseLine(const QString &line)
{
    QRegularExpression regex(
        R"(\[(\S+)-(\S+)\] \[\s*(\S+)\s*\] \[(\S*)\] (.*)\n?)");
    QRegularExpressionMatch match = regex.match(line);

    LogModel::Item item;
    item.type = match.captured(3);
    item.info = match.captured(5);
    item.file = match.captured(4);
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
    s_logModel->clear();

    const QStringList &lines = currentLog->getLines();

//    qDebug() << "DapModuleLog::outModel";

    for (auto line: lines)
    {
        s_logModel->add(parseLine(line));
    }
}
