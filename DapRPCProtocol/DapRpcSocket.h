#ifndef DapRPCSOCKET_H
#define DapRPCSOCKET_H

#include <QObject>
#include <QIODevice>
#include <QPointer>
#include <QTimer>
#include <QEventLoop>
#include <QDebug>
#include <QJsonDocument>

#include "DapRpcServiceProvider.h"
#include "DapRpcMessage.h"
#include "DapRpcServiceReply.h"

#define DEFAULT_MSECS_REQUEST_TIMEOUT (30000)

class DapRpcSocket : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcSocket)

    QPointer<QIODevice> m_pDevice;
    QByteArray m_aBuffer;
    QHash<int, QPointer<DapRpcServiceReply>> m_replies;
    int m_defaultRequestTimeout;

protected:
    virtual void processRequestMessage(const DapRpcMessage &asMessage);

public:
    explicit DapRpcSocket(QObject *apParent = nullptr);
    explicit DapRpcSocket(QIODevice *apDevice, QObject *apParent = nullptr);
    virtual ~DapRpcSocket();

    virtual bool isValid() const;
    void setDefaultRequestTimeout(int aiMsecs);
    int getDefaultRequestTimeout() const;

    void setIODevice(QIODevice *pDevice);

signals:
    void messageReceived(const DapRpcMessage &asMessage);

private slots:
    virtual void processIncomingData();
    int findJsonDocumentEnd(const QByteArray &aJsonData);
    void writeData(const DapRpcMessage &asMessage);

public slots:
    virtual void notify(const DapRpcMessage &asMessage);
    virtual DapRpcMessage sendMessageBlocking(const DapRpcMessage &asMessage, int aMsecs = DEFAULT_MSECS_REQUEST_TIMEOUT);
    virtual DapRpcServiceReply *sendMessage(const DapRpcMessage &asMessage);
    DapRpcMessage invokeRemoteMethodBlocking(const QString &asMethod, int aMsecs, const QVariant &arg1 = QVariant(),
                                               const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                               const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                               const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                               const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                               const QVariant &arg10 = QVariant());
    DapRpcMessage invokeRemoteMethodBlocking(const QString &asMethod, const QVariant &arg1 = QVariant(),
                                               const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                               const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                               const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                               const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                               const QVariant &arg10 = QVariant());
    DapRpcServiceReply *invokeRemoteMethod(const QString &asMethod, const QVariant &arg1 = QVariant(),
                                             const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                             const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                             const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                             const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                             const QVariant &arg10 = QVariant());
};

#endif // DapRPCSOCKET_H
