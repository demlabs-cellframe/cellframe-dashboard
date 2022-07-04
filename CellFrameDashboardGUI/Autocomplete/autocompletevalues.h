#ifndef AUTOCOMPLETEVALUES_H
#define AUTOCOMPLETEVALUES_H

#include <QObject>
#include "DapServiceController.h"

class AutocompleteValues : public QObject
{
    Q_OBJECT

    DapServiceController *serviceController;

    QStringList pubCerts;
    QStringList privCerts;
    QStringList networks;
    QStringList wallets;
    QStringList tokens;
    void _getCerts();
    void _getNetworks();

public:
    explicit AutocompleteValues(DapServiceController *_serviceController, QObject *parent = nullptr);
    QStringList getPubCerts();
    QStringList getPrivCerts();
    QStringList getNetworks();
    QStringList getWallets();
    QStringList getTokens();

signals:

};

#endif // AUTOCOMPLETEVALUES_H
