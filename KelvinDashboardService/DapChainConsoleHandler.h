#ifndef DAPCHAINCONSOLEHANDLER_H
#define DAPCHAINCONSOLEHANDLER_H

#include <QObject>
#include <QProcess>
#include <QDebug>
#include <QFile>

class DapChainConsoleHandler : public QObject
{
    Q_OBJECT

private:
    QFile * m_File;

public:
    explicit DapChainConsoleHandler(QObject *parent = nullptr);

    QString getHistory() const;
    QString getResult(const QString& aQuery) const;
};

#endif // DAPCHAINCONSOLEHANDLER_H
