#include "NodeBroadcast.h"

#ifdef ANDROID
#include <QtAndroid>
#include <QAndroidIntent>
#include <QAndroidJniEnvironment>
#endif

bool requestStoragePermission() {
    #ifdef ANDROID
    using namespace QtAndroid;

    QString permission = QStringLiteral("android.permission.WRITE_EXTERNAL_STORAGE");
    const QHash<QString, PermissionResult> results = requestPermissionsSync(QStringList({permission}));
    if (!results.contains(permission) || results[permission] == PermissionResult::Denied) {
        qWarning() << "Couldn't get permission: " << permission;
        return false;
    }
    #endif
    return true;
}

NodeBroadcast::NodeBroadcast(QObject *parent) : QObject(parent)
{
    #ifdef ANDROID
    if (!requestStoragePermission())
        qDebug() << "Storage permissions denied";

    QAndroidJniObject request = QAndroidJniObject::callStaticObjectMethod(
        "com/Cellframe/Dashboard/TCPClient",
        "sendRequest",
        "(Landroid/content/Context;)Ljava/util/ArrayList;",
        QtAndroid::androidContext().object());// ??
    QAndroidJniObject reply = request.callObjectMethod("get", "(I)Ljava/lang/Object;");
    #endif
}

void NodeBroadcast::nodeRequest(const QString &request)
{

}
