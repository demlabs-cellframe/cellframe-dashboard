#include "jniconnector.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif

#ifdef Q_OS_ANDROID

JNIConnector *JNIConnector::m_instance = nullptr;

static void callFromJava(JNIEnv *env, jobject /*thiz*/, jstring value)
{
    emit JNIConnector::instance()->messageFromJava(env->GetStringUTFChars(value, nullptr));
}

JNIConnector::JNIConnector(QObject *parent)
    : QObject(parent)
{
    m_instance = this;

    JNINativeMethod methods[] {{"callFromJava", "(Ljava/lang/String;)V", reinterpret_cast<void *>(callFromJava)}};
    QAndroidJniObject javaClass("com/Cellframe/Dashboard/JNIConnector");

    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
    env->RegisterNatives(objectClass,
                         methods,
                         sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);
}

void JNIConnector::printFromJava(const QString &message)
{
    QAndroidJniObject javaMessage = QAndroidJniObject::fromString(message);
    QAndroidJniObject::callStaticMethod<void>("com/Cellframe/Dashboard/JNIConnector",
                                       "printFromJava",
                                       "(Ljava/lang/String;)V",
                                        javaMessage.object<jstring>());
}
#endif
