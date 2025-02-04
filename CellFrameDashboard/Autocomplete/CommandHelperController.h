#ifndef COMMANDHELPERCONTROLLER_H
#define COMMANDHELPERCONTROLLER_H

#include <QObject>
#include <QPointer>
#include "DapServiceController.h"
#include "../chain/wallet/autocomplete/HelpDictionaryController.h"
class DapApplication;

class CommandHelperController : public QObject
{
    Q_OBJECT
public:
    explicit CommandHelperController(DapServiceController *serviceController, DapApplication *parent);
    ~CommandHelperController();

    bool isDictionary();

    void loadNewDictionary();
    void loadDictionary();
    void loadData();

signals:
    void helpListGeted(const QStringList& list);

public slots:
    void tryListGetting(const QString& text, int cursorPosition);
    // void tryDataUpdate();
private:
    DapServiceController  *s_serviceCtrl;
    HelpDictionaryController* m_helpController = nullptr;
    DapApplication* m_appManager = nullptr;
};

#endif // COMMANDHELPERCONTROLLER_H
