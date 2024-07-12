#ifndef NODEPATHMANAGER_H
#define NODEPATHMANAGER_H

#include <QObject>
#include <QSharedMemory>
#include <QDataStream>
#include <QDebug>
#include <QBuffer>
#include <QFileInfo>
#include <QDir>

#include "NodeInstallManager.h"
#include "NodeConfigToolController.h"

#ifdef WIN32
#include <windows.h>
#endif

class NodePathManager: public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(NodePathManager)

    explicit NodePathManager(QObject *parent = nullptr);

    QString m_keyName = "NodePathInit";
    QString m_target{""};

public:
    static NodePathManager &getInstance();

    bool getInitFlag(){return m_initMemFlag;}
    QString getTarget(){return m_target;}
    QString getUrlForNodeDownload();
    void checkNeedDownload();

    void init(QString target);

    struct NodePaths{
        QString nodeDirPath = "";
        QString nodePath = "";
        QString nodePath_cli = "";
        QString nodePath_tool = "";
        int nodeInstallType = Unknown;

        void reset(int type){
            nodeDirPath = "";
            nodePath = "";
            nodePath_cli = "";
            nodePath_tool = "";
            nodeInstallType = type;
        }

    }nodePaths;


    NodeInstallManager *m_instMngr;
    NodeConfigToolController *m_cfgToolCtrl;

private:
    QSharedMemory m_sharedMemory;
    bool m_initMemFlag{false};

    enum NodeInstallTypes{
        Unknown = -1,
        NoInstall = 0,
        OldInstall,
        NewInstall
    };

private:

    bool initMem();
    bool readMem();
    bool writeMem();


    void checkNodeDir(QString oldPath, QString newPath);

    QString getNodeConfigPath();
    QString getNodeNewBinaryPath();

    void fillNodePath();


signals:
    Q_INVOKABLE void signalIsNeedInstallNode(bool isNeed, QString url);

public slots:
    void slotCheckUpdateNode(QString currentNodeVersion);
//    void slotBreakInstallNode();
};

#endif // NODEPATHMANAGER_H
