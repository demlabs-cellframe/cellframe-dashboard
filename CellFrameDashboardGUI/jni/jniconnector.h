#ifndef JNICONNECTOR_H
#define JNICONNECTOR_H

#include <QObject>

class JNIConnector : public QObject
{    
    Q_OBJECT
#ifdef Q_OS_ANDROID
public:
    explicit JNIConnector(QObject *parent = nullptr);
    static JNIConnector *instance() { return m_instance; }
    Q_INVOKABLE void printFromJava(const QString &message);

signals:
    void messageFromJava(const QString &message);

public slots:

private:
    static JNIConnector *m_instance;
#endif

};

#endif // JNICONNECTOR_H
