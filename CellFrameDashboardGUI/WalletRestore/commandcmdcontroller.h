#ifndef COMMANDCMDCONTROLLER_H
#define COMMANDCMDCONTROLLER_H

#include <QObject>
#include "DapServiceController.h"

class CommandCmdController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(DapServiceController *dapServiceController MEMBER dapServiceController)

    QStringList commands;
    QVariantMap commandsParams;

    DapServiceController *dapServiceController;
public:
    explicit CommandCmdController(QObject *parent = nullptr);

public slots:
    void dapServiceControllerInit(DapServiceController *_dapServiceController);
    void parseAllCommands(const QVariant& asAnswer);
    void parseAllCommandsParams(const QVariant& asAnswer);

    QString getCommandByValue(const QString &value);
    QString getCommandParams(const QString &value, int count);

signals:

};

#endif // COMMANDCMDCONTROLLER_H
