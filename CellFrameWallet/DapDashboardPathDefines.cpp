#include "DapDashboardPathDefines.h"
#include <QDir>

namespace Dap
{

#if defined(Q_OS_ANDROID)
static QAndroidJniObject l_pathObj = QtAndroid::androidContext().callObjectMethod(
    "getExternalFilesDir"
    , "(Ljava/lang/String;)Ljava/io/File;"
    , QAndroidJniObject::fromString(QString("")).object());
const QString DashboardDefines::DashboardStorage::STORAGE_PATH = QString(l_pathObj.toString());

#elif defined(Q_OS_LINUX)
const QString DashboardDefines::DashboardStorage::STORAGE_PATH = QString("/opt/%1").arg(DAP_BRAND_LO);

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


const QString DashboardDefines::DashboardStorage::STORAGE_PATH     = QString("/Users/%1/Library/Application\ Support/%2").arg(homeUser).arg(DAP_BRAND);

#elif defined (Q_OS_WIN)

const QString DashboardDefines::DashboardStorage::STORAGE_PATH = QDir::toNativeSeparators(QString("%1/%2").arg(regWGetUsrPath()).arg(DAP_BRAND));

#else

const QString DashboardDefines::DashboardStorage::STORAGE_PATH = QString();

#endif

const QString DashboardDefines::DashboardStorage::LOG_PATH            = QString(STORAGE_PATH + QDir::separator() + "log");
const QString DashboardDefines::DashboardStorage::DAPPS_PATH          = QString(STORAGE_PATH + QDir::separator() + "dapps");
const QString DashboardDefines::DashboardStorage::DAPPS_DOWNLOAD_PATH = QString(DAPPS_PATH   + QDir::separator() + "download");
const QString DashboardDefines::DashboardStorage::DATA_PATH           = QString(STORAGE_PATH + QDir::separator() + "data");
const QString DashboardDefines::DashboardStorage::WALLET_PATH         = QString(DATA_PATH    + QDir::separator() + "wallet");
const QString DashboardDefines::DashboardStorage::WALLET_NODE_PATH    = QString(WALLET_PATH  + QDir::separator() + "node");

const QString DashboardDefines::DApps::PLUGINS_PATH = QString(DashboardStorage::DAPPS_PATH);
const QString DashboardDefines::DApps::PLUGINS_DOWNLOAD_PATH = QString(DashboardStorage::DAPPS_DOWNLOAD_PATH + QDir::separator());
const QString DashboardDefines::DApps::PLUGINS_CONFIG = QString(PLUGINS_PATH + QDir::separator() + "config_dApps.ini");

}
