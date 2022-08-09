#ifndef COMMANDCMDCONTROLLER_H
#define COMMANDCMDCONTROLLER_H

#include <QObject>
#include "DapServiceController.h"
#include "autocompletevalues.h"

class CommandCmdController : public QObject
{
    Q_OBJECT

    Q_PROPERTY(DapServiceController *dapServiceController MEMBER dapServiceController)

    QStringList commands;
    QStringList parsedCommands;
    QVariantMap commandsParams;
    AutocompleteValues *values;

    bool isCertsList = false;


    struct commandTree
    {
        QString data;
        QList<commandTree*> children;

        commandTree append(QStringList command);
        void debugTree(commandTree *tree);
    };

    QMap<QString, commandTree> words;


    bool isDisconnect = false;
    bool isFirstInit = true;
    void parseTree(QString command);
    QVariantList getTreeWords(QString value);

    QStringList certNames;

    DapServiceController *dapServiceController;
public:
    explicit CommandCmdController(QObject *parent = nullptr);

public slots:
    void dapServiceControllerInit(DapServiceController *_dapServiceController);
    void parseAllCommands(const QVariant& asAnswer);
    void parseAllCommandsParams(const QVariant& asAnswer);

    QVariantList getWords(QString value);

    void endCertsList();

    int maxLengthText(QVariantList list);

signals:

};

#endif // COMMANDCMDCONTROLLER_H
