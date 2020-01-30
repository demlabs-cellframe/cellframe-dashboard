#include "Factory.h"

Factory::Factory(QObject *parent) : QObject(parent)
{

}

QObject *Factory::createStructure()
{
    DapWallet * wallet = new DapWallet();
    wallet->setName("MyWallet5");
    wallet->setBalance(1548745354574);
    wallet->addNetwork("Kelvin-testnet");
    wallet->addNetwork("Private");
    wallet->addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Kelvin-testnet");
    wallet->addAddress("ar4th4t4j6tyj7utjk45u654kuj4kl6ui4l54k5lu5u4il5i34l35", "Private");
    DapWalletToken * token1 = new DapWalletToken("KLV", wallet);
    token1->setBalance(5.5);
    token1->setNetwork("Kelvin-testnet");
    token1->setEmission(464645646546);
    DapWalletToken * token2 = new DapWalletToken("CELL", wallet);
    token2->setBalance(100);
    token2->setNetwork("Private");
    token2->setEmission(121212121);
    wallet->addToken(token1);
    wallet->addToken(token2);
        return wallet;
}
