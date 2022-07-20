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
    QStringList chains;
    QMap<QString, QStringList> netChains;
    QMap<QString, QStringList> chainNets;

    void _getCerts();
    void _getNetworks();
    void _getChains();

public:
    explicit AutocompleteValues(DapServiceController *_serviceController, QObject *parent = nullptr);
    QStringList getPubCerts();
    QStringList getPrivCerts();
    QStringList getNetworks();
    QStringList getWallets();
    QStringList getTokens();
    QStringList getAllChains();
    QStringList getChainsByNetwork(const QString &netName);
    QStringList getNetworkByChain(const QString &chainName);

signals:

};

#endif // AUTOCOMPLETEVALUES_H
