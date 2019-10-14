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

/**
 * @brief The DapErrorCode enum
 * This enum values are used to mark code of error
 */
enum DapErrorCode {
    NoError         = 0,                ///< No error
    ParseError      = -32700,           /*!< Invalid JSON was received by the server.
                                             An error occurred on the server while parsing the JSON text. */
    InvalidRequest  = -32600,           ///< The JSON sent is not a valid Request object.
    MethodNotFound  = -32601,           ///< The method does not exist / is not available.
    InvalidParams   = -32602,           ///< Invalid method parameter(s).
    InternalError   = -32603,           ///< Internal JSON-RPC error.
    ServerErrorBase = -32000,           ///< Reserved for implementation-defined server-errors.
    UserError       = -32099,           ///< Anything after this is user defined
    TimeoutError    = -32100            ///< Timeout
};
Q_DECLARE_METATYPE(DapErrorCode)

class DapRpcMessagePrivate;
/// Class of message type by RPC protocol
class DapRpcMessage
{
    friend class DapRpcMessagePrivate;
    QSharedDataPointer<DapRpcMessagePrivate> d;

public:
    /// Standard constructor
    DapRpcMessage();
    /// Copy constructor
    /// @param aDapRPCMessage Other message
    DapRpcMessage(const DapRpcMessage &aDapRPCMessage);
    /// Assignment operator
    /// @param aDapRPCMessage Other message
    /// @return RPC message
    DapRpcMessage &operator=(const DapRpcMessage &aDapRPCMessage);
    /// Standard destructor
    ~DapRpcMessage();

    /// Swap message
    /// @param aDapRPCMessage Swaped message
    inline void swap(DapRpcMessage &aDapRPCMessage) { qSwap(d, aDapRPCMessage.d); }

    /**
     * @brief The Type enum
     * Type of message
     */
    enum Type {
        Invalid,        ///< Invalid
        Request,        ///< Request
        Response,       ///< Responce
        Notification,   ///< Notification
        Error           ///< Error
    };

    /// Create new request message
    /// @param asMethod Remote method
    /// @param aParams Params message in format JsonArray
    /// @return aParams New RPC message
    static DapRpcMessage createRequest(const QString &asMethod, const QJsonArray &aParams = QJsonArray());
    /// Create new request message
    /// @param asMethod Remote method
    /// @param aParams Params message in format JsonValue
    /// @return aParam New RPC message
    static DapRpcMessage createRequest(const QString &asMethod, const QJsonValue &aParam);
    /// Create new request message
    /// @param asMethod Remote method
    /// @param aNamedParameters Named params message in format JsonObject
    /// @return New RPC message
    static DapRpcMessage createRequest(const QString &asMethod, const QJsonObject &aNamedParameters);
    /// Create new request message
    /// @param asMethod Remote method
    /// @param aStream Message stream
    /// @return New RPC message
    static DapRpcMessage createRequest(const QString &asMethod, const QByteArray& aStream);
    /// Create new notification message
    /// @param asMethod Remote method
    /// @param aParams Params message in format JsonArray.
    /// @return aParams New RPC message
    static DapRpcMessage createNotification(const QString &asMethod, const QJsonArray &aParams = QJsonArray());
    /// Create new notification message
    /// @param asMethod Remote method
    /// @param aParams Params message in format JsonValue
    /// @return aParam New RPC message
    static DapRpcMessage createNotification(const QString &asMethod, const QJsonValue &aParam);
    /// Create new notification message
    /// @param asMethod Remote method
    /// @param aNamedParameters Named params message in format JsonObject
    /// @return New RPC message
    static DapRpcMessage createNotification(const QString &asMethod, const QJsonObject &aNamedParameters);
    /// Create new notification message
    /// @param asMethod Remote method
    /// @param aStream Message stream
    /// @return New RPC message
    static DapRpcMessage createNotification(const QString &asMethod, const QByteArray& aStream);

    /// Create new response message
    /// @param aResult Result of operation
    /// @return aParams Response RPC message
    DapRpcMessage createResponse(const QJsonValue &aResult) const;
    /// Create new error responce
    /// @param aCode Code of error
    /// @see DapErrorCode
    /// @param asMessage Message
    /// @param aData Data of message
    /// @return Rpc message
    DapRpcMessage createErrorResponse(DapErrorCode aCode,
                                      const QString &asMessage = QString(),
                                      const QJsonValue &aData = QJsonValue()) const;
    /// Get type of message
    /// @return Type of message
    DapRpcMessage::Type type() const;
    /// Validation of message
    /// @return True if message is valid. False otherwise
    bool isValid() const;
    /// Get id message
    /// @return id message
    int id() const;
    /// Remote method from request message
    /// @return Remote method
    QString method() const;
    /// Params from request message
    /// @return Params of message as JsonValue
    QJsonValue params() const;
    /// Get result of response message
    /// @return Result of response message as JsonValue
    QJsonValue toJsonValue() const;
    /// Get result of response message
    /// @return Result of response message as yteArray
    QByteArray toByteArray() const;
    /// Get error code. @see DapErrorCode
    /// @return Error code
    int errorCode() const;
    /// Get text of error message
    /// @return Text of error message. If message isn't error type return default string;
    QString errorMessage() const;
    /// Get data of error message
    /// @return Data of error. If message isn't error type return default JsonValue
    QJsonValue errorData() const;

    /// Convert message to JsonObject
    /// @return Message as JsonObject
    QJsonObject toObject() const;
    /// Static method to convert JsonObject to Rpc message
    /// @param aObject Message as JsonObject
    /// @return Converted message
    static DapRpcMessage fromObject(const QJsonObject &aObject);

    /// Serilize message
    /// @return Message as byte array
    QByteArray toJson() const;
    /// Static method to convert serilisation message to Rpc message
    /// @param aData Data of message
    /// @return Converted message
    static DapRpcMessage fromJson(const QByteArray &aData);

    /// Overloaded relational operator (equal)
    /// @param aDapRpcMessage Other message
    /// @return True if equal and false when not
    bool operator==(const DapRpcMessage &aDapRpcMessage) const;
    /// Overloaded relational operator (not equal)
    /// @param aDapRpcMessage Other message
    /// @return True if not equal and false when yes
    inline bool operator!=(const DapRpcMessage &aDapRpcMessage) const { return !(operator==(aDapRpcMessage)); }
};

QDebug operator<<(QDebug, const DapRpcMessage &);
Q_DECLARE_METATYPE(DapRpcMessage)
Q_DECLARE_SHARED(DapRpcMessage)

#endif // DapRPCMESSAGE_H
