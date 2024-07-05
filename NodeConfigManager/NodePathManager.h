#ifndef NODEPATHMANAGER_H
#define NODEPATHMANAGER_H

#include <QObject>
#include <QSharedMemory>
#include <QDataStream>
#include <QDebug>
#include <QBuffer>
#include <QFileInfo>

#include "NodeInstallManager.h"



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

    void init(QString target);

public:
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



private:
    NodeInstallManager *m_instMngr;

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

    void fillNodePath();

    void checkNodeDir(QString oldPath, QString newPath);

signals:
    Q_INVOKABLE void signalIsNeedInstallNode(bool isNeed, QString url);

public slots:
    void slotCheckUpdateNode(QString currentNodeVersion);
//    void slotBreakInstallNode();
};

#endif // NODEPATHMANAGER_H
