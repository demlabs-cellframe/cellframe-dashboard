#ifndef COMMANDHELPERCONTROLLER_H
#define COMMANDHELPERCONTROLLER_H

#include <QObject>
#include <QPointer>
#include "DapServiceController.h"
#include "../chain/wallet/autocomplete/HelpDictionaryController.h"

class CommandHelperController : public QObject
{
    Q_OBJECT
public:
    explicit CommandHelperController(QObject *parent = nullptr);
    ~CommandHelperController();

    bool isDictionary();

    void loadNewDictionary();
    void loadDictionary();

public slots:
    QStringList getHelpList(const QString& text, int cursorPosition);

private:
    DapServiceController  *s_serviceCtrl;
    HelpDictionaryController* m_helpController = nullptr;
};

#endif // COMMANDHELPERCONTROLLER_H
