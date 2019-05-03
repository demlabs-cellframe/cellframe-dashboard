#ifndef DapRPCMESSAGE_H
#define DapRPCMESSAGE_H

#include <QSharedDataPointer>
#include <QMetaType>
#include <QJsonDocument>
#include <QJsonValue>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

#define qJsonRpcDebug if (qgetenv("QJSONRPC_DEBUG").isEmpty()); else qDebug

enum DapErrorCode {
    NoError         = 0,
    ParseError      = -32700,           // Invalid JSON was received by the server.
                                        // An error occurred on the server while parsing the JSON text.
    InvalidRequest  = -32600,           // The JSON sent is not a valid Request object.
    MethodNotFound  = -32601,           // The method does not exist / is not available.
    InvalidParams   = -32602,           // Invalid method parameter(s).
    InternalError   = -32603,           // Internal JSON-RPC error.
    ServerErrorBase = -32000,           // Reserved for implementation-defined server-errors.
    UserError       = -32099,           // Anything after this is user defined
    TimeoutError    = -32100
};
Q_DECLARE_METATYPE(DapErrorCode)

class DapRpcMessagePrivate;
class DapRpcMessage
{
    friend class DapRpcMessagePrivate;
    QSharedDataPointer<DapRpcMessagePrivate> d;

public:
    DapRpcMessage();
    DapRpcMessage(const DapRpcMessage &aDapRPCMessage);
    DapRpcMessage &operator=(const DapRpcMessage &aDapRPCMessage);
    ~DapRpcMessage();

    inline void swap(DapRpcMessage &aDapRPCMessage) { qSwap(d, aDapRPCMessage.d); }

    enum Type {
        Invalid,
        Request,
        Response,
        Notification,
        Error
    };

    static DapRpcMessage createRequest(const QString &asMethod,
                                         const QJsonArray &aParams = QJsonArray());
    static DapRpcMessage createRequest(const QString &asMethod, const QJsonValue &aParam);
    static DapRpcMessage createRequest(const QString &asMethod, const QJsonObject &aNamedParameters);

    static DapRpcMessage createNotification(const QString &asMethod,
                                              const QJsonArray &aParams = QJsonArray());
    static DapRpcMessage createNotification(const QString &asMethod, const QJsonValue &aParam);
    static DapRpcMessage createNotification(const QString &asMethod,
                                              const QJsonObject &aNamedParameters);

    DapRpcMessage createResponse(const QJsonValue &aResult) const;
    DapRpcMessage createErrorResponse(DapErrorCode aCode,
                                        const QString &asMessage = QString(),
                                        const QJsonValue &aData = QJsonValue()) const;

    DapRpcMessage::Type type() const;
    bool isValid() const;
    int id() const;

    // request
    QString method() const;
    QJsonValue params() const;

    // response
    QJsonValue result() const;

    // error
    int errorCode() const;
    QString errorMessage() const;
    QJsonValue errorData() const;

    QJsonObject toObject() const;
    static DapRpcMessage fromObject(const QJsonObject &aObject);

    QByteArray toJson() const;
    static DapRpcMessage fromJson(const QByteArray &aData);

    bool operator==(const DapRpcMessage &aDapRpcMessage) const;
    inline bool operator!=(const DapRpcMessage &aDapRpcMessage) const { return !(operator==(aDapRpcMessage)); }
};

QDebug operator<<(QDebug, const DapRpcMessage &);
Q_DECLARE_METATYPE(DapRpcMessage)
Q_DECLARE_SHARED(DapRpcMessage)

#endif // DapRPCMESSAGE_H
