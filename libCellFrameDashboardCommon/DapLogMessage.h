#ifndef DAPLOGMESSAGE_H
#define DAPLOGMESSAGE_H

#include <QObject>

// TODO: I think it's useless enum
enum Type
{
    Info,
    Warning,
    Debug,
    Error
};

class DapLogMessage : public QObject
{
    Q_OBJECT

    /// type of log message
    QString m_type;
    /// timestamp
    QString m_sTimeStamp;
    /// name of file where log message was occur
    QString m_sFile;
    /// text of log message
    QString m_sMessage;

public:
    /// standard constructor
    explicit DapLogMessage(QObject *parent = nullptr) { Q_UNUSED(parent) }
    /// overloaded constructor
    /// @param asType Еype of log message
    /// @param asTimestamp Timestamp of log message
    /// @param asFile Name if file where log message was occur
    /// @param asMessage Text of log message
    DapLogMessage(const QString &asType, const QString &asTimestamp,
                  const QString &asFile, const QString &asMessage, QObject *parent = nullptr);


    Q_PROPERTY(QString type READ getType WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString timestamp READ getTimeStamp WRITE setTimeStamp NOTIFY timeStampChanged)
    Q_PROPERTY(QString file READ getFile WRITE setFile NOTIFY fileChanged)
    Q_PROPERTY(QString message READ getMessage WRITE setMessage NOTIFY messageChanged)

    /// Get type
    /// @return Type of log message
    QString getType() const;
    /// Set type to message
    /// @param asType Type of log message
    void setType(const QString &asType);

    /// Get timestamp
    /// @return Timestamp of log message
    QString getTimeStamp() const;
    /// Set timestamp to log message
    /// @param asTimeStamp Timestamp of log message
    void setTimeStamp(const QString &asTimeStamp);

    /// Get name of file
    /// @return Name of file where log message was occur
    QString getFile() const;
    /// Set name of file
    /// @param asFile Name of file
    void setFile(const QString &asFile);

    /// Get text of log message
    /// @return Text of log message
    QString getMessage() const;
    /// Set text to log message
    /// @param asMessage Text of log message
    void setMessage(const QString &asMessage);

signals:
    /// The signal emitted in case when type of log message was changed
    /// @param asType type of log message
    void typeChanged(const QString& asType);
    /// The signal emitted in case when timestamp of log message was changed
    /// @param asTimeStamp Timestamp of log message
    void timeStampChanged(const QString& asTimeStamp);
    /// The signal emitted in case when file og log message was changed
    /// @param asFile Name of log message was changed
    void fileChanged(const QString& asFile);
    /// The signal emitted in case when message was changed
    /// @param asMessage Text of log message
    void messageChanged(const QString& asMessage);

};

#endif // DAPLOGMESSAGE_H
