#ifndef DapRPCSERVICE_H
#define DapRPCSERVICE_H

#include <QObject>
#include <QVariant>
#include <QPointer>
#include <QVarLengthArray>
#include <QMetaMethod>
#include <QEventLoop>
#include <QDebug>


#include "DapRpcMessage.h"
#include "DapRpcServiceRequest.h"

struct ParameterInfo
{
    ParameterInfo(const QString &asName = QString(), int aType = 0, bool aOut = false);

    int type;
    int jsType;
    QString name;
    bool out;
};

struct MethodInfo
{
    MethodInfo();
    MethodInfo(const QMetaMethod &aMethod);

    QVarLengthArray<ParameterInfo> parameters;
    int returnType;
    bool valid;
    bool hasOut;
};

class DapRpcService : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcService)

    QHash<int, MethodInfo > m_methodInfoHash;
    QHash<QByteArray, QList<int> > m_invokableMethodHash;
    DapRpcServiceRequest m_currentRequest;
    bool m_delayedResponse {false};
    QString m_sName;

protected:
    DapRpcServiceRequest currentRequest() const;
    void beginDelayedResponse();

public:
    explicit DapRpcService(const QString &asName, QObject *apParent = nullptr);
    ~DapRpcService();

    void cacheInvokableInfo();
    static int qjsonRpcMessageType;
    static int convertVariantTypeToJSType(int aType);
    static QJsonValue convertReturnValue(QVariant &aReturnValue);

    void setCurrentRequest(const DapRpcServiceRequest &aCurrentRequest);

    QString getName() const;

signals:
    void result(const DapRpcMessage &aDapRpcMessage);
    void notifyConnectedClients(const DapRpcMessage &aDapRpcMessage);
    void notifyConnectedClients(const QString &asMethod, const QJsonArray &aParams = QJsonArray());

public slots:
    DapRpcMessage dispatch(const DapRpcMessage &aRequest);
};

#endif // DapRPCSERVICE_H

