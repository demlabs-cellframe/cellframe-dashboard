#ifndef NODECONFIGTOOLCONTROLLER_H
#define NODECONFIGTOOLCONTROLLER_H

#include <QObject>
#include <QProcess>
#include <QFileInfo>
#include <QJsonObject>
#include <QDebug>

#ifdef WIN32
#include <windows.h>
#endif


class NodeConfigToolController : public QObject
{
    Q_OBJECT
public:
    explicit NodeConfigToolController(QObject *parent = nullptr);

    bool runNode();

    bool m_statusInitConfTool{false};
    QString m_nodeConfToolPath{""};

    enum TypeServiceCommands{
        Status = 0,
        EnableAutostart = 1,
        DisableAutostart,
        Stop,
        Start,
        Restart
    };


    QJsonObject serviceCommand(TypeServiceCommands type);

#ifdef WIN32
    LONG GetDWORDRegKey(HKEY hKey, const std::wstring &strValueName, DWORD &nValue, DWORD nDefaultValue);
    LONG GetBoolRegKey(HKEY hKey, const std::wstring &strValueName, bool &bValue, bool bDefaultValue);
    LONG GetStringRegKey(HKEY hKey, const std::wstring &strValueName, std::wstring &strValue, const std::wstring &strDefaultValue);
#endif

private:

    bool initConfTool();
    QString sendRequest(QString req);


signals:

};

#endif // NODECONFIGTOOLCONTROLLER_H
