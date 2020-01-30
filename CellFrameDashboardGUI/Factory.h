#ifndef FACTORY_H
#define FACTORY_H

#include <QObject>

#include "DapWallet.h"

class Factory : public QObject
{
    Q_OBJECT
public:
    explicit Factory(QObject *parent = nullptr);

    Q_INVOKABLE QObject* createStructure(); // Для создания структур

};

#endif // FACTORY_H
