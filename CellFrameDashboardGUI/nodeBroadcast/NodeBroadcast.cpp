#include "NodeBroadcast.h"

#include <QtAndroid>
#include <QAndroidIntent>
#include <QAndroidJniEnvironment>

bool requestStoragePermission() {
    using namespace QtAndroid;

    QString permission = QStringLiteral("android.permission.WRITE_EXTERNAL_STORAGE");
    const QHash<QString, PermissionResult> results = requestPermissionsSync(QStringList({permission}));
    if (!results.contains(permission) || results[permission] == PermissionResult::Denied) {
        qWarning() << "Couldn't get permission: " << permission;
        return false;
    }
    return true;
}

NodeBroadcast::NodeBroadcast(QObject *parent) : QObject(parent)
{
    if (!requestStoragePermission())
        qDebug() << "Storage permissions denied";

    QAndroidJniObject request = QAndroidJniObject::callStaticObjectMethod(
        "com/Cellframe/Dashboard/TCPClient",
        "sendRequest",
        "(Landroid/content/Context;)Ljava/util/ArrayList;",
        QtAndroid::androidContext().object());// ??
    QAndroidJniObject reply = request.callObjectMethod("get", "(I)Ljava/lang/Object;");
}

void NodeBroadcast::nodeRequest(const QString &request)
{

}
