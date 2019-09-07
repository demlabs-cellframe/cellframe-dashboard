#ifndef DAPCHAINCONSOLEHANDLER_H
#define DAPCHAINCONSOLEHANDLER_H

#include <QObject>
#include <QProcess>

class DapChainConsoleHandler : public QObject
{
    Q_OBJECT

public:
    explicit DapChainConsoleHandler(QObject *parent = nullptr);

    QString getResult(const QString& aQuery) const;
};

#endif // DAPCHAINCONSOLEHANDLER_H
