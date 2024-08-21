#include "NodeConfigToolController.h"

NodeConfigToolController::NodeConfigToolController(QObject *parent)
    : QObject{parent}
{
    initConfTool();
}

NodeConfigToolController &NodeConfigToolController::getInstance()
{
    static NodeConfigToolController instance;
    return instance;
}

bool NodeConfigToolController::runNode()
{
    if(m_flagUserStopAutostart)
        return false;

    if(m_statusInitConfTool)
    {
        if(!serviceCommand(Status)["result"].toString().contains("enabled"));
            serviceCommand(EnableAutostart);
        return serviceCommand(Start)["result"].toString().contains("started");
    }
    else
    {
#ifdef Q_OS_WIN
        HANDLE hEvent = OpenEventA(EVENT_MODIFY_STATE, 0, "Local\\" DAP_BRAND_BASE_LO "-node");
        if (!hEvent) {
            bool status = QProcess::startDetached("schtasks.exe", QStringList({"/run", "/I", "/TN", DAP_BRAND_BASE_LO "-node"}));
            qInfo() << "Restarting the node, old method: "
                    << status;
            return status;
        } else {
            CloseHandle(hEvent);
            return false;
        }
#endif
    }
    return false;
}

void NodeConfigToolController::stopNode()
{
    serviceCommand(Stop);
}

void NodeConfigToolController::startNode()
{
    serviceCommand(Start);
}

void NodeConfigToolController::getStatusNode()
{
    serviceCommand(Status);
}

void NodeConfigToolController::swithServiceEnabled(bool flag)
{
    m_flagUserStopAutostart = !flag;
    serviceCommand(flag ? EnableAutostart : DisableAutostart);
}

bool NodeConfigToolController::initConfTool()
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    m_nodeConfToolPath = "/opt/cellframe-node/bin/cellframe-node-config";
#elif defined (Q_OS_MACOS)
    m_nodeConfToolPath = "/Applications/CellframeNode.app/Contents/MacOS/cellframe-node-config";
#elif defined (Q_OS_WIN)
    //HKLM "Software\${APP_NAME}" "Path"
    HKEY hKey;
    LONG lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\cellframe-node\\", 0, KEY_READ, &hKey);
    bool bExistsAndSuccess (lRes == ERROR_SUCCESS);
    bool bDoesNotExistsSpecifically (lRes == ERROR_FILE_NOT_FOUND);
    std::wstring path;
    GetStringRegKey(hKey, L"Path", path, L"");
    std::string stdpath(path.begin(),path.end());

    m_nodeConfToolPath = QString(QString::fromWCharArray(path.c_str()) + "/cellframe-node-config.exe");
#endif

    QFileInfo confTool(m_nodeConfToolPath);
    if(!confTool.exists())
    {
        qWarning()<<"Could not find cellframe-node-config";
        return false;
    }
    m_statusInitConfTool = true;
    serviceCommand(Status);
    return true;
}

QString NodeConfigToolController::getResult(QString find, QStringList list)
{
    for(int i = 0; i < list.length(); i++)
    {
        if(list[i].contains(find))
            return list[i].remove(find);
    }
    return "";
}

QStringList NodeConfigToolController::getConfigNetworkList(const QString& status)
{
    QStringList netList;

    QString result = sendRequest("-e net_list " + status);
    auto list = result.split('\n');
    const QRegularExpression regName = QRegularExpression(R"(name: (\S+))");

    for(auto& str: list)
    {
        str = str.trimmed();
        if(str.isEmpty())continue;

        auto nameMatch = regName.match(str);
        if(!nameMatch.hasMatch())
        {
            qWarning() << "[NodeConfigToolController] Problems getting a list of networks. >> " << result;
            continue;
        }

        netList.append(nameMatch.captured(1));
    }

    return netList;
}

QJsonObject NodeConfigToolController::serviceCommand(TypeServiceCommands type)
{
    if(!m_statusInitConfTool)
        initConfTool();

    QString result;
    bool status;

    switch (type) {
    case Status:
    {
        result = sendRequest("-e service status");

        QStringList resList = result.split("\n");
        m_statusProcessNode = getResult("process: ", resList).contains("running");
        m_statusServiceNode = getResult("service: ", resList).contains("enabled");

        emit statusProcessNodeChanged();
        emit statusServiceNodeChanged();
        break;
    }
    case EnableAutostart:
    {
        result = sendRequest("-e service enable");
        serviceCommand(Status);
        break;
    }
    case DisableAutostart:
    {
        result = sendRequest("-e service disable");
        serviceCommand(Status);
        break;
    }
    case Stop:
    {
        result = sendRequest("-e service stop");
        serviceCommand(Status);
        break;
    }
    case Start:
    {
        result = sendRequest("-e service start");
        serviceCommand(Status);
        break;
    }
    case Restart:
    {
        result = sendRequest("-e service restart");
        serviceCommand(Status);
        break;
    }
    default:
        break;
    }

    qDebug()<< result;

    status = !result.isEmpty();
    return QJsonObject{{"status", status},
                       {"result", result}};
}

QString NodeConfigToolController::sendRequest(QString req)
{
    QProcess proc;
    proc.setProgram(m_nodeConfToolPath);
    proc.setArguments(req.split(" "));

    proc.start();

    if(proc.waitForFinished())
    {
        return proc.readAll();
    }

    qDebug()<< "Timeout request";
    return QString();
}

#ifdef WIN32
LONG NodeConfigToolController::GetDWORDRegKey(HKEY hKey, const std::wstring &strValueName, DWORD &nValue, DWORD nDefaultValue)
{
    nValue = nDefaultValue;
    DWORD dwBufferSize(sizeof(DWORD));
    DWORD nResult(0);
    LONG nError = ::RegQueryValueExW(hKey,
                                     strValueName.c_str(),
                                     0,
                                     NULL,
                                     reinterpret_cast<LPBYTE>(&nResult),
                                     &dwBufferSize);
    if (ERROR_SUCCESS == nError)
    {
        nValue = nResult;
    }
    return nError;
}


LONG NodeConfigToolController::GetBoolRegKey(HKEY hKey, const std::wstring &strValueName, bool &bValue, bool bDefaultValue)
{
    DWORD nDefValue((bDefaultValue) ? 1 : 0);
    DWORD nResult(nDefValue);
    LONG nError = GetDWORDRegKey(hKey, strValueName.c_str(), nResult, nDefValue);
    if (ERROR_SUCCESS == nError)
    {
        bValue = (nResult != 0) ? true : false;
    }
    return nError;
}


LONG NodeConfigToolController::GetStringRegKey(HKEY hKey, const std::wstring &strValueName, std::wstring &strValue, const std::wstring &strDefaultValue)
{
    strValue = strDefaultValue;
    WCHAR szBuffer[512];
    DWORD dwBufferSize = sizeof(szBuffer);
    ULONG nError;
    nError = RegQueryValueExW(hKey, strValueName.c_str(), 0, NULL, (LPBYTE)szBuffer, &dwBufferSize);
    if (ERROR_SUCCESS == nError)
    {
        strValue = szBuffer;
    }
    return nError;
}
#endif


