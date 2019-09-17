#ifndef DAPCHAINNODECACHE_H
#define DAPCHAINNODECACHE_H

#include <QObject>

class DapChainNodeCache : public QObject
{
    Q_OBJECT
public:
    explicit DapChainNodeCache(QObject *parent = nullptr);
    
signals:
    
public slots:
};

#endif // DAPCHAINNODECACHE_H