#ifndef DAPCHAINCONSOLEHANDLER_H
#define DAPCHAINCONSOLEHANDLER_H

#include <QObject>
#include <QProcess>
#include <QDebug>
#include <QFile>
#include <QDir>

/// Class of recipient history commands
class DapChainConsoleHandler : public QObject
{
    Q_OBJECT

private:
    /// System file
    QFile * m_File;

public:
    /// Standard constructor
    explicit DapChainConsoleHandler(QObject *parent = nullptr);

    /// Get history of commands
    /// @return history
    QString getHistory() const;
    /// Get result of command
    /// @param command
    /// @return command result
    QString getResult(const QString& aQuery) const;
};

#endif // DAPCHAINCONSOLEHANDLER_H
