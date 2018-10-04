#ifndef DAPSETTINGS_H
#define DAPSETTINGS_H

#include <QObject>

class DapSettings : public QObject
{
    Q_OBJECT
public:
    explicit DapSettings(QObject *parent = nullptr);
    
signals:
    
public slots:
};

#endif // DAPSETTINGS_H