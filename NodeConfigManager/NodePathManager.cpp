#include "NodePathManager.h"

NodePathManager::NodePathManager( QObject *parent)
    : QObject(parent)
    , m_sharedMemory(m_keyName)
    , m_instMngr(new NodeInstallManager(true))
    , m_cfgToolCtrl(new NodeConfigToolController())
{

}

NodePathManager &NodePathManager::getInstance()
{
    static NodePathManager instance;
    return instance;
}

void NodePathManager::init(QString target)
{
    m_target = target;

    fillNodePath();

    m_initMemFlag = initMem();

    qDebug()<<"--------------------------- Init QShareMemory ---------------------------"
            <<"Mem target: "        + m_target
            <<"Mem status: "        + QString(m_initMemFlag?"true":"false")
            <<"Node install type: " + QString::number(nodePaths.nodeInstallType)
            <<"Mem cli path: "      + nodePaths.nodePath_cli
            <<"Mem tool path: "     + nodePaths.nodePath_tool
            <<"Mem dir path: "      + nodePaths.nodeDirPath
            <<"Mem node path: "     + nodePaths.nodePath;

    checkNeedDownload();

}

QString NodePathManager::getUrlForNodeDownload()
{
    return m_instMngr->getUrlForDownload();
}

void NodePathManager::checkNeedDownload()
{
    if(m_target == "GUI")
    {
        switch (nodePaths.nodeInstallType) {
        case Unknown:
            emit signalIsNeedInstallNode(false, "");
            qDebug()<<"Unknown type node install";
            break;
        case NoInstall:
            emit signalIsNeedInstallNode(true, getUrlForNodeDownload());
            break;
        default:
            emit signalIsNeedInstallNode(false, "");
            break;
        }
    }
}

void NodePathManager::slotCheckUpdateNode(QString currentNodeVersion)
{
    m_instMngr->checkUpdateNode(currentNodeVersion);
}

bool NodePathManager::initMem()
{
    if (m_sharedMemory.isAttached())
        m_sharedMemory.detach();

    return readMem();
}

bool NodePathManager::readMem()
{
    if (!m_sharedMemory.attach()) {
        qDebug()<<"Unable to attach to shared memory segment. " << m_sharedMemory.errorString() << ". Write attempt mem";
        return writeMem();
    }

    QBuffer buffer;
    QDataStream in(&buffer);

    m_sharedMemory.lock();
    buffer.setData((char*)m_sharedMemory.constData(), m_sharedMemory.size());
    buffer.open(QBuffer::ReadOnly);
    in >> nodePaths.nodePath
       >> nodePaths.nodeDirPath
       >> nodePaths.nodePath_cli
       >> nodePaths.nodePath_tool
       >> nodePaths.nodeInstallType;
    m_sharedMemory.unlock();

    m_sharedMemory.detach();

    return true;
}

bool NodePathManager::writeMem()
{
    // load into shared memory
    QBuffer buffer;
    buffer.open(QBuffer::ReadWrite);
    QDataStream out(&buffer);
    out << nodePaths.nodePath
        << nodePaths.nodeDirPath
        << nodePaths.nodePath_cli
        << nodePaths.nodePath_tool
        << nodePaths.nodeInstallType;
    int size = buffer.size();

    if (!m_sharedMemory.create(size)) {
        qDebug()<<"Unable to create shared memory segment." << m_sharedMemory.errorString();
        return false;
    }

    m_sharedMemory.lock();
    char *to = (char*)m_sharedMemory.data();
    const char *from = buffer.data().data();
    memcpy(to, from, qMin(m_sharedMemory.size(), size));
    m_sharedMemory.unlock();

    return true;
}

void NodePathManager::checkNodeDir(QString oldPath, QString newPath)
{
//    QString separator = QDir::separator();

#ifdef Q_OS_WIN
    QString separator = "\\";
    QString suffix = ".exe";
#else
    QString suffix = "";
    QString separator = "/";
#endif

    separator = "/";

    QFileInfo oldfileNode(oldPath);
    QFileInfo newfileNode(newPath);

    if(oldfileNode.exists())
    {
        QString dir = oldfileNode.absolutePath();
        nodePaths.nodeDirPath     = dir;
        nodePaths.nodePath        = dir + separator + "cellframe-node" + suffix;
        nodePaths.nodePath_cli    = dir + separator + "cellframe-node-cli" + suffix;
        nodePaths.nodePath_tool   = dir + separator + "cellframe-node-tool" + suffix;
        nodePaths.nodeInstallType = OldInstall;
    }
    else
    {

        QString dir = newfileNode.absolutePath();
        nodePaths.nodeDirPath     = dir;
        nodePaths.nodePath        = dir + separator + "cellframe-node" + suffix;
        nodePaths.nodePath_cli    = dir + separator + "cellframe-node-cli" + suffix;
        nodePaths.nodePath_tool   = dir + separator + "cellframe-node-tool" + suffix;

        if(newfileNode.exists())
            nodePaths.nodeInstallType = NewInstall;
        else
            nodePaths.nodeInstallType = NoInstall;
    }
}

void NodePathManager::fillNodePath()
{

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)

    checkNodeDir("/opt/cellframe-node/bin/cellframe-node",
                 getNodeNewBinaryPath());

#elif defined (Q_OS_MACOS)

    checkNodeDir("/Applications/CellframeDashboard.app/Contents/MacOS/cellframe-node",
                 getNodeNewBinaryPath());

#elif defined (Q_OS_WIN)

    checkNodeDir("./cellframe-node.exe",
                 getNodeNewBinaryPath());

#elif defined Q_OS_ANDROID
    qDebug()<<"Unknown node path";
#else
    qDebug()<<"Unknown node path";
#endif
}

QString NodePathManager::getNodeConfigPath(){
#ifdef __linux__
    return "/opt/cellframe-node/";
#endif

#ifdef __APPLE__
    return  "/Applications/CellframeNode.app/Contents/Resources/";
#endif

#ifdef WIN32
    HKEY hKey;
    LONG lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Shell Folders", 0, KEY_READ, &hKey);
    bool bExistsAndSuccess (lRes == ERROR_SUCCESS);
    bool bDoesNotExistsSpecifically (lRes == ERROR_FILE_NOT_FOUND);
    std::wstring path;
    m_cfgToolCtrl->GetStringRegKey(hKey, L"Common Documents", path, L"");
    std::string stdpath(path.begin(),path.end());
    return QString::fromWCharArray(path.c_str());
#endif
}

QString NodePathManager::getNodeNewBinaryPath(){
#ifdef __linux__
    return "/opt/cellframe-node/bin/cellframe-node";
#endif

#ifdef __APPLE__
    return  "/Applications/CellframeNode.app/Contents/MacOS/cellframe-node";
#endif

#ifdef WIN32
    //HKLM "Software\${APP_NAME}" "Path"
    HKEY hKey;
    LONG lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\cellframe-node\\", 0, KEY_READ, &hKey);
    bool bExistsAndSuccess (lRes == ERROR_SUCCESS);
    bool bDoesNotExistsSpecifically (lRes == ERROR_FILE_NOT_FOUND);
    std::wstring path;
    m_cfgToolCtrl->GetStringRegKey(hKey, L"Path", path, L"");
    std::string stdpath(path.begin(),path.end());

    if(QString::fromWCharArray(path.c_str()).isEmpty())
    {
        return "./cellframe-node.exe";
    }
    else
    {
        return QString(QString::fromWCharArray(path.c_str()) + "/cellframe-node.exe");
    }

#endif
}
