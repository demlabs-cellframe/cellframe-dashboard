#ifndef DAPWALLETPATHDEFINES_H
#define DAPWALLETPATHDEFINES_H

#include "DapPathDefines.h"

namespace Dap
{

namespace WalletDefines
{

struct DApps
{
static const QString PLUGINS_CONFIG;
static const QString PLUGINS_PATH;
static const QString PLUGINS_DOWNLOAD_PATH;
};

struct WalletStorage
{
static const QString STORAGE_PATH;
static const QString DATA_PATH;
static const QString LOG_PATH;
static const QString DAPPS_PATH;
static const QString DAPPS_DOWNLOAD_PATH;
static const QString WALLET_PATH;
static const QString WALLET_NODE_PATH;
};

}

}

#endif // DAPWALLETPATHDEFINES_H
