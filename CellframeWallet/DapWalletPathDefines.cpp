#include "DapWalletPathDefines.h"
#include <QDir>

namespace Dap
{

#if defined(Q_OS_ANDROID)
static QAndroidJniObject l_pathObj = QtAndroid::androidContext().callObjectMethod(
    "getExternalFilesDir"
    , "(Ljava/lang/String;)Ljava/io/File;"
    , QAndroidJniObject::fromString(QString("")).object());
const QString WalletDefines::WalletStorage::STORAGE_PATH = QString(l_pathObj.toString());

#elif defined(Q_OS_LINUX)
const QString WalletDefines::WalletStorage::STORAGE_PATH = QString("/opt/%1").arg(DAP_BRAND_LO);

#elif defined (Q_OS_MACOS)

auto username = []() -> char*
{
    char * l_username = NULL;
    exec_with_ret(&l_username,"whoami|tr -d '\n'");
    if (!l_username)
    {
        qWarning() << "Fatal Error: Can't obtain username";
    }

    return l_username;
};

char * homeUser = username();


const QString WalletDefines::WalletStorage::STORAGE_PATH     = QString("/Users/%1/Library/Application\ Support/%2").arg(homeUser).arg(DAP_BRAND);

#elif defined (Q_OS_WIN)

const QString WalletDefines::WalletStorage::STORAGE_PATH = QDir::toNativeSeparators(QString("%1/%2").arg(regWGetUsrPath()).arg(DAP_BRAND));

#else

const QString WalletDefines::WalletStorage::STORAGE_PATH = QString();

#endif

const QString WalletDefines::WalletStorage::LOG_PATH            = QString(STORAGE_PATH + QDir::separator() + "log");
const QString WalletDefines::WalletStorage::DAPPS_PATH          = QString(STORAGE_PATH + QDir::separator() + "dapps");
const QString WalletDefines::WalletStorage::DAPPS_DOWNLOAD_PATH = QString(DAPPS_PATH   + QDir::separator() + "download");
const QString WalletDefines::WalletStorage::DATA_PATH           = QString(STORAGE_PATH + QDir::separator() + "data");
const QString WalletDefines::WalletStorage::WALLET_PATH         = QString(DATA_PATH    + QDir::separator() + "wallet");
const QString WalletDefines::WalletStorage::WALLET_NODE_PATH    = QString(WALLET_PATH  + QDir::separator() + "node");

const QString WalletDefines::DApps::PLUGINS_PATH = QString(WalletStorage::DAPPS_PATH);
const QString WalletDefines::DApps::PLUGINS_DOWNLOAD_PATH = QString(WalletStorage::DAPPS_DOWNLOAD_PATH + QDir::separator());
const QString WalletDefines::DApps::PLUGINS_CONFIG = QString(PLUGINS_PATH + QDir::separator() + "config_dApps.ini");

}
