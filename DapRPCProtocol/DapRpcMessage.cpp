#include "DapRpcMessage.h"

class DapRpcMessagePrivate : public QSharedData
{
public:
    DapRpcMessagePrivate();
    ~DapRpcMessagePrivate();
    DapRpcMessagePrivate(const DapRpcMessagePrivate &aDapRpcMessagePrivate);

    void initializeWithObject(const QJsonObject &aMessage);
    static DapRpcMessage createBasicRequest(const QString &asMethod, const QJsonArray &aParams);
    static DapRpcMessage createBasicRequest(const QString &asMethod,
                                              const QJsonObject &aNamedParameters);

    DapRpcMessage::Type m_type;
    QScopedPointer<QJsonObject> m_pObject;

    static int uniqueRequestCounter;
};

int DapRpcMessagePrivate::uniqueRequestCounter = 0;

DapRpcMessagePrivate::DapRpcMessagePrivate()
    : m_type(DapRpcMessage::Invalid),
      m_pObject(nullptr)
{
}

DapRpcMessagePrivate::DapRpcMessagePrivate(const DapRpcMessagePrivate &aDapRpcMessagePrivate)
    : QSharedData(aDapRpcMessagePrivate),
      m_type(aDapRpcMessagePrivate.m_type),
      m_pObject(aDapRpcMessagePrivate.m_pObject ? new QJsonObject(*aDapRpcMessagePrivate.m_pObject) : nullptr)
{
}

void DapRpcMessagePrivate::initializeWithObject(const QJsonObject &aMessage)
{
    m_pObject.reset(new QJsonObject(aMessage));
    if (aMessage.contains(QLatin1String("id"))) {
        if (aMessage.contains(QLatin1String("result")) ||
            aMessage.contains(QLatin1String("error"))) {
            if (aMessage.contains(QLatin1String("error")) &&
                !aMessage.value(QLatin1String("error")).isNull())
                m_type = DapRpcMessage::Error;
            else
                m_type = DapRpcMessage::Response;
        } else if (aMessage.contains(QLatin1String("method"))) {
            m_type = DapRpcMessage::Request;
        }
    } else {
        if (aMessage.contains(QLatin1String("method")))
            m_type = DapRpcMessage::Notification;
    }
}

DapRpcMessagePrivate::~DapRpcMessagePrivate()
{
}

DapRpcMessage::DapRpcMessage()
    : d(new DapRpcMessagePrivate)
{
    d->m_pObject.reset(new QJsonObject);
}

DapRpcMessage::DapRpcMessage(const DapRpcMessage &aDapRPCMessage)
    : d(aDapRPCMessage.d)
{
}

DapRpcMessage::~DapRpcMessage()
{
}

DapRpcMessage &DapRpcMessage::operator=(const DapRpcMessage &aDapRPCMessage)
{
    d = aDapRPCMessage.d;
    return *this;
}

bool DapRpcMessage::operator==(const DapRpcMessage &aDapRpcMessage) const
{
    if (aDapRpcMessage.d == d)
        return true;

    if (aDapRpcMessage.type() == type()) {
        if (aDapRpcMessage.type() == DapRpcMessage::Error) {
            return (aDapRpcMessage.errorCode() == errorCode() &&
                    aDapRpcMessage.errorMessage() == errorMessage() &&
                    aDapRpcMessage.errorData() == errorData());
        } else {
            if (aDapRpcMessage.type() == DapRpcMessage::Notification) {
                return (aDapRpcMessage.method() == method() &&
                        aDapRpcMessage.params() == params());
            } else {
                return (aDapRpcMessage.id() == id() &&
                        aDapRpcMessage.method() == method() &&
                        aDapRpcMessage.params() == params());
            }
        }
    }

    return false;
}

DapRpcMessage DapRpcMessage::fromJson(const QByteArray &aData)
{
    DapRpcMessage result;
    QJsonParseError error;
    QJsonDocument document = QJsonDocument::fromJson(aData, &error);
    if (error.error != QJsonParseError::NoError) {
        qJsonRpcDebug() << error.errorString();
        return result;
    }

    if (!document.isObject()) {
        qJsonRpcDebug() << "invalid message: " << aData;
        return result;
    }

    result.d->initializeWithObject(document.object());
    return result;
}

DapRpcMessage DapRpcMessage::fromObject(const QJsonObject &aObject)
{
    DapRpcMessage result;
    result.d->initializeWithObject(aObject);
    return result;
}

QJsonObject DapRpcMessage::toObject() const
{
    if (d->m_pObject)
        return QJsonObject(*d->m_pObject);
    return QJsonObject();
}

QByteArray DapRpcMessage::toJson() const
{
    if (d->m_pObject) {
        QJsonDocument doc(*d->m_pObject);
        return doc.toJson();
    }

    return QByteArray();
}

bool DapRpcMessage::isValid() const
{
    return d->m_type != DapRpcMessage::Invalid;
}

DapRpcMessage::Type DapRpcMessage::type() const
{
    return d->m_type;
}

DapRpcMessage DapRpcMessagePrivate::createBasicRequest(const QString &asMethod, const QJsonArray &aParams)
{
    DapRpcMessage request;
    request.d->m_pObject->insert(QLatin1String("jsonrpc"), QLatin1String("2.0"));
    request.d->m_pObject->insert(QLatin1String("method"), asMethod);
    if (!aParams.isEmpty())
        request.d->m_pObject->insert(QLatin1String("params"), aParams);
    return request;
}

DapRpcMessage DapRpcMessagePrivate::createBasicRequest(const QString &asMethod,
                                                           const QJsonObject &aNamedParameters)
{
    DapRpcMessage request;
    request.d->m_pObject->insert(QLatin1String("jsonrpc"), QLatin1String("2.0"));
    request.d->m_pObject->insert(QLatin1String("method"), asMethod);
    if (!aNamedParameters.isEmpty())
        request.d->m_pObject->insert(QLatin1String("params"), aNamedParameters);
    return request;
}

DapRpcMessage DapRpcMessage::createRequest(const QString &asMethod, const QJsonArray &aParams)
{
    DapRpcMessage request = DapRpcMessagePrivate::createBasicRequest(asMethod, aParams);
    request.d->m_type = DapRpcMessage::Request;
    DapRpcMessagePrivate::uniqueRequestCounter++;
    request.d->m_pObject->insert(QLatin1String("id"), DapRpcMessagePrivate::uniqueRequestCounter);
    return request;
}

DapRpcMessage DapRpcMessage::createRequest(const QString &asMethod, const QJsonValue &aParam)
{
    QJsonArray params;
    params.append(aParam);
    return createRequest(asMethod, params);
}

DapRpcMessage DapRpcMessage::createRequest(const QString &asMethod,
                                               const QJsonObject &aNamedParameters)
{
    DapRpcMessage request =
        DapRpcMessagePrivate::createBasicRequest(asMethod, aNamedParameters);
    request.d->m_type = DapRpcMessage::Request;
    DapRpcMessagePrivate::uniqueRequestCounter++;
    request.d->m_pObject->insert(QLatin1String("id"), DapRpcMessagePrivate::uniqueRequestCounter);
    return request;
}

DapRpcMessage DapRpcMessage::createRequest(const QString& asMethod, const QByteArray& aStream)
{
    DapRpcMessage request = createRequest(asMethod, QJsonValue::fromVariant(aStream));
    return request;
}

DapRpcMessage DapRpcMessage::createNotification(const QString &asMethod, const QJsonArray &aParams)
{
    DapRpcMessage notification = DapRpcMessagePrivate::createBasicRequest(asMethod, aParams);
    notification.d->m_type = DapRpcMessage::Notification;
    return notification;
}

DapRpcMessage DapRpcMessage::createNotification(const QString &asMethod, const QJsonValue &aParam)
{
    QJsonArray params;
    params.append(aParam);
    return createNotification(asMethod, params);
}

DapRpcMessage DapRpcMessage::createNotification(const QString &asMethod,
                                                    const QJsonObject &aNamedParameters)
{
    DapRpcMessage notification =
        DapRpcMessagePrivate::createBasicRequest(asMethod, aNamedParameters);
    notification.d->m_type = DapRpcMessage::Notification;
    return notification;
}

DapRpcMessage DapRpcMessage::createNotification(const QString& asMethod, const QByteArray& aStream)
{
    DapRpcMessage notification = createNotification(asMethod, QJsonValue::fromVariant(aStream));
    return notification;
}

DapRpcMessage DapRpcMessage::createResponse(const QJsonValue &aResult) const
{
    DapRpcMessage response;
    if (d->m_pObject->contains(QLatin1String("id"))) {
        QJsonObject *object = response.d->m_pObject.data();
        object->insert(QLatin1String("jsonrpc"), QLatin1String("2.0"));
        object->insert(QLatin1String("id"), d->m_pObject->value(QLatin1String("id")));
        object->insert(QLatin1String("result"), aResult);
        response.d->m_type = DapRpcMessage::Response;
    }

    return response;
}

DapRpcMessage DapRpcMessage::createErrorResponse(DapErrorCode aCode,
                                                     const QString &asMessage,
                                                     const QJsonValue &aData) const
{
    DapRpcMessage response;
    QJsonObject error;
    error.insert(QLatin1String("code"), aCode);
    if (!asMessage.isEmpty())
        error.insert(QLatin1String("message"), asMessage);
    if (!aData.isUndefined())
        error.insert(QLatin1String("data"), aData);

    response.d->m_type = DapRpcMessage::Error;
    QJsonObject *object = response.d->m_pObject.data();
    object->insert(QLatin1String("jsonrpc"), QLatin1String("2.0"));
    if (d->m_pObject->contains(QLatin1String("id")))
        object->insert(QLatin1String("id"), d->m_pObject->value(QLatin1String("id")));
    else
        object->insert(QLatin1String("id"), 0);
    object->insert(QLatin1String("error"), error);
    return response;
}

int DapRpcMessage::id() const
{
    if (d->m_type == DapRpcMessage::Notification || !d->m_pObject)
        return -1;

    const QJsonValue &value = d->m_pObject->value(QLatin1String("id"));
    if (value.isString())
        return value.toString().toInt();
    return value.toInt();
}

QString DapRpcMessage::method() const
{
    if (d->m_type == DapRpcMessage::Response || !d->m_pObject)
        return QString();

    return d->m_pObject->value(QLatin1String("method")).toString();
}

QJsonValue DapRpcMessage::params() const
{
    if (d->m_type == DapRpcMessage::Response || d->m_type == DapRpcMessage::Error)
        return QJsonValue(QJsonValue::Undefined);
    if (!d->m_pObject)
        return QJsonValue(QJsonValue::Undefined);

    return d->m_pObject->value(QLatin1String("params"));
}

QJsonValue DapRpcMessage::toJsonValue() const
{
    if (d->m_type != DapRpcMessage::Response || !d->m_pObject)
        return QJsonValue(QJsonValue::Undefined);

    return d->m_pObject->value(QLatin1String("result"));
}

QByteArray DapRpcMessage::toByteArray() const
{
    QJsonValue value = toJsonValue();
    return QByteArray::fromHex(value.toVariant().toByteArray());
}

int DapRpcMessage::errorCode() const
{
    if (d->m_type != DapRpcMessage::Error || !d->m_pObject)
        return 0;

    QJsonObject error =
        d->m_pObject->value(QLatin1String("error")).toObject();
    const QJsonValue &value = error.value(QLatin1String("code"));
    if (value.isString())
        return value.toString().toInt();
    return value.toInt();
}

QString DapRpcMessage::errorMessage() const
{
    if (d->m_type != DapRpcMessage::Error || !d->m_pObject)
        return QString();

    QJsonObject error =
        d->m_pObject->value(QLatin1String("error")).toObject();
    return error.value(QLatin1String("message")).toString();
}

QJsonValue DapRpcMessage::errorData() const
{
    if (d->m_type != DapRpcMessage::Error || !d->m_pObject)
        return QJsonValue(QJsonValue::Undefined);

    QJsonObject error =
        d->m_pObject->value(QLatin1String("error")).toObject();
    return error.value(QLatin1String("data"));
}

static QDebug operator<<(QDebug dbg, DapRpcMessage::Type type)
{
    switch (type) {
    case DapRpcMessage::Request:
        return dbg << "DapRpcMessage::Request";
    case DapRpcMessage::Response:
        return dbg << "DapRpcMessage::Response";
    case DapRpcMessage::Notification:
        return dbg << "DapRpcMessage::Notification";
    case DapRpcMessage::Error:
        return dbg << "DapRpcMessage::Error";
    default:
        return dbg << "DapRpcMessage::Invalid";
    }
}

QDebug operator<<(QDebug dbg, const DapRpcMessage &msg)
{
    dbg.nospace() << "DapRpcMessage(type=" << msg.type();
    if (msg.type() != DapRpcMessage::Notification) {
        dbg.nospace() << ", id=" << msg.id();
    }

    if (msg.type() == DapRpcMessage::Request ||
        msg.type() == DapRpcMessage::Notification) {
        dbg.nospace() << ", method=" << msg.method()
                      << ", params=" << msg.params();
    } else if (msg.type() == DapRpcMessage::Response) {
        dbg.nospace() << ", result=" << msg.toJsonValue();
    } else if (msg.type() == DapRpcMessage::Error) {
        dbg.nospace() << ", code=" << msg.errorCode()
                      << ", message=" << msg.errorMessage()
                      << ", data=" << msg.errorData();
    }
    dbg.nospace() << ")";
    return dbg.space();
}
