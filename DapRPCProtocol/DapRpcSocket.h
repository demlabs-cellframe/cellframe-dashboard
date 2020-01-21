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

/**
 * @brief The DapRpcSocket class
 * Realization socket interface:
 *  - Store information about device and data
 *  - Sending/receiving messages
 *  - Control sending request by timeout
 */
class DapRpcSocket : public QObject, public DapRpcServiceProvider
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcSocket)

    /// Pointer to IO device
    QPointer<QIODevice> m_pDevice;
    /// Buffer
    QByteArray m_aBuffer;
    /// Storage to replies by id
    QHash<int, QPointer<DapRpcServiceReply>> m_replies;
    /// Default request timeout
    int m_defaultRequestTimeout;

protected:
    /// TODO: not implement
    /// @param asMessage Request message
    virtual void processRequestMessage(const DapRpcMessage &asMessage);

public:
    /// Standard constructor
    explicit DapRpcSocket(QObject *apParent = nullptr);
    /// Overloaded constructor
    /// @param apDevice Device whick provides both a common implementation and
    /// an abstract interface for devices that support reading and writing of blocks of data
    explicit DapRpcSocket(QIODevice *apDevice, QObject *apParent = nullptr);
    /// Virtual destructor
    virtual ~DapRpcSocket();

    /// Validation initialization and open device
    /// @return True if device initilized and opened. Otherwise return false
    virtual bool isValid() const;
    /// Set default request timeout
    /// @param aiMsecs Miliseconds
    void setDefaultRequestTimeout(int aiMsecs);
    /// Get default request timeout
    /// @return Default request timeout
    int getDefaultRequestTimeout() const;
    /// Set IO Device
    /// @param Pointer to IO device
    void setIODevice(QIODevice *pDevice);

signals:
    /// The signal emitted when message was received
    /// @param asMessage Request message
    void messageReceived(const DapRpcMessage &asMessage);

private slots:
    /// Read data from device and prepare reply
    virtual void processIncomingData();
    /// Find end of Json document
    /// @param aJsonData Json data where need to find end
    /// @return Index of end json document. If file empty return -1
    int findJsonDocumentEnd(const QByteArray &aJsonData);
    /// Write data from message to device
    /// @param asMessage Request message
    void writeData(const DapRpcMessage &asMessage);

public slots:
    /// Notify to new request message and try to send to device
    /// @param asMessage Request message
    virtual void notify(const DapRpcMessage &asMessage);
    /// Send message with delay for sending message
    /// @param asMessage Request message
    /// @param aMsecs Delay request timeout. If not pass parameter uses default value
    /// @return Response from reply
    virtual DapRpcMessage sendMessageBlocking(const DapRpcMessage &asMessage, int aMsecs = DEFAULT_MSECS_REQUEST_TIMEOUT);
    /// Send request message to device
    /// @param asMessage Request message
    /// @return Pointer of service reply
    virtual DapRpcServiceReply *sendMessage(const DapRpcMessage &asMessage);
    /// Invoke remote method and create response to send to IO device with delay
    /// @param asMethod Method's name
    /// @param aMsecs Delay time for send
    /// @param arg1 First argument
    /// @param arg2 Second argument
    /// @param arg3 Third argument
    /// @param arg4 Fourth argument
    /// @param arg5 Fifth argument
    /// @param arg6 Six argument
    /// @param arg7 Seven argument
    /// @param arg8 Eight argument
    /// @param arg9 Nine argument
    /// @param arg10 Ten argument
    /// @return Response from reply
    DapRpcMessage invokeRemoteMethodBlocking(const QString &asMethod, int aMsecs, const QVariant &arg1 = QVariant(),
                                               const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                               const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                               const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                               const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                               const QVariant &arg10 = QVariant());
    /// Invoke remote method and create response to send to IO device with default delay time
    /// @param asMethod Method's name
    /// @param arg1 First argument
    /// @param arg2 Second argument
    /// @param arg3 Third argument
    /// @param arg4 Fourth argument
    /// @param arg5 Fifth argument
    /// @param arg6 Six argument
    /// @param arg7 Seven argument
    /// @param arg8 Eight argument
    /// @param arg9 Nine argument
    /// @param arg10 Ten argument
    /// @return Response from reply
    DapRpcMessage invokeRemoteMethodBlocking(const QString &asMethod, const QVariant &arg1 = QVariant(),
                                               const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                               const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                               const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                               const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                               const QVariant &arg10 = QVariant());
    /// Invoke remote method and create response to send to IO device
    /// @param asMethod Method's name
    /// @param arg1 First argument
    /// @param arg2 Second argument
    /// @param arg3 Third argument
    /// @param arg4 Fourth argument
    /// @param arg5 Fifth argument
    /// @param arg6 Six argument
    /// @param arg7 Seven argument
    /// @param arg8 Eight argument
    /// @param arg9 Nine argument
    /// @param arg10 Ten argument
    /// @return Pointer to service reply
    DapRpcServiceReply *invokeRemoteMethod(const QString &asMethod, const QVariant &arg1 = QVariant(),
                                             const QVariant &arg2 = QVariant(), const QVariant &arg3 = QVariant(),
                                             const QVariant &arg4 = QVariant(), const QVariant &arg5 = QVariant(),
                                             const QVariant &arg6 = QVariant(), const QVariant &arg7 = QVariant(),
                                             const QVariant &arg8 = QVariant(), const QVariant &arg9 = QVariant(),
                                             const QVariant &arg10 = QVariant());
    DapRpcServiceReply *invokeRemoteMethod(const DapRpcMessage &message);
};

#endif // DapRPCSOCKET_H
