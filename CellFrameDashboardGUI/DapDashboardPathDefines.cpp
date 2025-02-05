#include "DapDashboardPathDefines.h"

namespace Dap
{

#if defined(Q_OS_ANDROID)

const QString DashboardDefines::CellframeNode::CONFIGWORKER_PATH = QString("/sdcard/%1-node/etc").arg(DAP_BRAND_BASE_LO);
const QString DashboardDefines::CellframeNode::DAPMODULE_LOG = QString("/sdcard/cellframe-node/var/log");
const QString DashboardDefines::CellframeNode::DAPMODULE_BRAND_LOG = QString("/sdcard/cellframe-node/var/log");

static QAndroidJniObject l_pathObj = QtAndroid::androidContext().callObjectMethod(
    "getExternalFilesDir"
    , "(Ljava/lang/String;)Ljava/io/File;"
    , QAndroidJniObject::fromString(QString("")).object());
const QString DashboardDefines::DapUiSdk::STORAGE_PATH = QString(l_pathObj.toString());

#elif defined(Q_OS_LINUX)

const QString DashboardDefines::CellframeNode::CONFIGWORKER_PATH = QString("/opt/%1-node/etc").arg(DAP_BRAND_BASE_LO);
const QString DashboardDefines::CellframeNode::DAPMODULE_LOG = QString("/opt/%1-node/var/log").arg(DAP_BRAND_BASE_LO);
const QString DashboardDefines::CellframeNode::DAPMODULE_BRAND_LOG = QString("/var/log/%1-dashboard").arg(DAP_BRAND_BASE_LO);

const QString DashboardDefines::DApps::PLUGINS_CONFIG = QString("/opt/%1/dapps/config_dApps.ini").arg(DAP_BRAND_LO);
const QString DashboardDefines::DApps::PLUGINS_PATH = QString("/opt/%1/dapps").arg(DAP_BRAND_LO);

const QString DashboardDefines::DapUiSdk::STORAGE_PATH = QString("/opt/%1").arg(DAP_BRAND).toLower();

#elif defined (Q_OS_MACOS)

const QString DashboardDefines::CellframeNode::CONFIGWORKER_PATH = getPathOnMACOS("var/log", "", true, true);
const QString DashboardDefines::CellframeNode::DAPMODULE_LOG = getPathOnMACOS("etc", "", true, true);
const QString DashboardDefines::CellframeNode::DAPMODULE_BRAND_LOG = getPathOnMACOS(QString("/var/log/%1-dashboard").arg(DAP_BRAND_BASE_LO));

const QString DashboardDefines::DApps::PLUGINS_CONFIG = QString("/tmp/Cellframe-Dashboard_dapps/config_dApps.ini");
const QString DashboardDefines::DApps::PLUGINS_PATH = QString("/tmp/Cellframe-Dashboard_dapps");

const QString DashboardDefines::DapUiSdk::STORAGE_PATH = QString("/tmp/%1").arg(DAP_BRAND);

#elif defined (Q_OS_WIN)

const QString DashboardDefines::CellframeNode::CONFIGWORKER_PATH = QDir::toNativeSeparators(QString("%1/cellframe-node/etc").arg(regWGetUsrPath()));
const QString DashboardDefines::CellframeNode::DAPMODULE_LOG = QDir::toNativeSeparators(QString("%1/cellframe-node/var/log").arg(regWGetUsrPath()));
const QString DashboardDefines::CellframeNode::DAPMODULE_BRAND_LOG = QDir::toNativeSeparators(QString("%1/%2/log").arg(regWGetUsrPath()).arg(DAP_BRAND));

const QString DashboardDefines::DApps::PLUGINS_CONFIG = QDir::toNativeSeparators(QString("%1/%2/dapps/config_dApps.ini").arg(regGetUsrPath()).arg(DAP_BRAND));
const QString DashboardDefines::DApps::PLUGINS_PATH = QDir::toNativeSeparators(QString("%1/%2/dapps").arg(regGetUsrPath()).arg(DAP_BRAND));

const QString DashboardDefines::DapUiSdk::STORAGE_PATH = QDir::toNativeSeparators(QString("%1/%2").arg(regWGetUsrPath()).arg(DAP_BRAND));

#else

const QString DashboardDefines::DapUiSdk::STORAGE_PATH = QString();

#endif

}
