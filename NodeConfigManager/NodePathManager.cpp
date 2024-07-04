#include "NodePathManager.h"

NodePathManager::NodePathManager( QObject *parent)
    : QObject(parent)
    , m_sharedMemory(m_keyName)
    , m_instMngr(new NodeInstallManager(true))
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

    qDebug()<<"Init mem status: "   + QString(m_initMemFlag?"true":"false")
            <<"Node install type: " + QString::number(nodePaths.nodeInstallType);

    if(target == "GUI")
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

QString NodePathManager::getUrlForNodeDownload()
{
    return m_instMngr->getUrlForDownload();
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

#ifdef Q_OS_WIN
    QString slash = "\\";
    QString suffix = ".exe";
#else
    QString slash = "/";
    QString suffix = "";
#endif

    QFileInfo oldfileNode(newPath);
    QFileInfo newfileNode(oldPath);

    if(oldfileNode.exists())
    {
        QString dir = oldfileNode.absolutePath();
        nodePaths.nodeDirPath     = dir;
        nodePaths.nodePath        = dir + slash + "cellframe-node" + suffix;
        nodePaths.nodePath_cli    = dir + slash + "cellframe-node-cli" + suffix;
        nodePaths.nodePath_tool   = dir + slash + "cellframe-node-tool" + suffix;
        nodePaths.nodeInstallType = OldInstall;
    }
    else if(newfileNode.exists())
    {
        QString dir = newfileNode.absolutePath();
        nodePaths.nodeDirPath     = dir;
        nodePaths.nodePath        = dir + slash + "cellframe-node" + suffix;
        nodePaths.nodePath_cli    = dir + slash + "cellframe-node-cli" + suffix;
        nodePaths.nodePath_tool   = dir + slash + "cellframe-node-tool" + suffix;
        nodePaths.nodeInstallType = NewInstall;
    }
    else
    {
        nodePaths.reset(NoInstall);
    }
}

void NodePathManager::fillNodePath()
{

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)

    checkNodeDir("/opt/cellframe-node/bin/cellframe-node",
                 "/opt/cellframe-node/bin/cellframe-node");

#elif defined (Q_OS_MACOS)

    checkNodeDir("/Applications/CellframeDashboard.app/Contents/MacOS/cellframe-node",
                 "/Applications/CellframeNode.app/Contents/MacOS/cellframe-node");

#elif defined (Q_OS_WIN)

    checkNodeDir("./cellframe-node.exe",
                 "./../cellframe-node/cellframe-node.exe");

#elif defined Q_OS_ANDROID
    qDebug()<<"Unknown node path";
#else
    qDebug()<<"Unknown node path";
#endif
}
