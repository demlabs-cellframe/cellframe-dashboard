#ifndef DAPLOGMESSAGE_H
#define DAPLOGMESSAGE_H

#include <QObject>

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

    Type m_type;
    QString m_sTimeStamp;
    QString m_sFile;
    QString m_sMessage;

public:
    explicit DapLogMessage(QObject *parent = nullptr) {}
    DapLogMessage(const Type &type, const QString &timestamp, const QString  &file, const QString &message, QObject *parent = nullptr);


    Q_PROPERTY(Type type READ getType WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString timestamp READ getTimeStamp WRITE setTimeStamp NOTIFY timeStampChanged)
    Q_PROPERTY(QString file READ getFile WRITE setFile NOTIFY fileChanged)
    Q_PROPERTY(QString message READ getMessage WRITE setMessage NOTIFY messageChanged)

    Type getType() const;
    void setType(const Type &type);

    QString getTimeStamp() const;
    void setTimeStamp(const QString &sTimeStamp);

    QString getFile() const;
    void setFile(const QString &sFile);

    QString getMessage() const;
    void setMessage(const QString &sMessage);

signals:
    void typeChanged(Type aType);
    void timeStampChanged(const QString& aTimeStamp);
    void fileChanged(const QString& aFile);
    void messageChanged(const QString& aMessage);

};

#endif // DAPLOGMESSAGE_H
