#ifndef DAPCHAINNODE_H
#define DAPCHAINNODE_H

#include <QObject>

class DapChainNode : public QObject
{
    Q_OBJECT
public:
    explicit DapChainNode(QObject *parent = nullptr);
    
signals:
    
public slots:
};

#endif // DAPCHAINNODE_H