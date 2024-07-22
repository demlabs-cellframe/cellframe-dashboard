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
    NodeConfigToolController(QObject *parent = nullptr);
public:
    static NodeConfigToolController &getInstance();

    Q_PROPERTY(bool statusProcessNode READ statusProcessNode NOTIFY statusProcessNodeChanged)
    Q_PROPERTY(bool statusServiceNode READ statusServiceNode NOTIFY statusServiceNodeChanged)
    Q_INVOKABLE bool statusServiceNode(){return m_statusServiceNode;}
    Q_INVOKABLE bool statusProcessNode(){return m_statusProcessNode;}

    bool m_statusServiceNode{false};
    bool m_statusProcessNode{false};
    bool m_statusInitConfTool{false};
    QString m_nodeConfToolPath{""};
    bool m_flagUserStopAutostart{false};

    enum TypeServiceCommands{
        Status = 0,
        EnableAutostart = 1,
        DisableAutostart,
        Stop,
        Start,
        Restart
    };


public:
    QJsonObject serviceCommand(TypeServiceCommands type);

    bool runNode();

    Q_INVOKABLE void stopNode();
    Q_INVOKABLE void startNode();
    Q_INVOKABLE void getStatusNode();
    Q_INVOKABLE void swithServiceEnabled(bool flag);

#ifdef WIN32
    LONG GetDWORDRegKey(HKEY hKey, const std::wstring &strValueName, DWORD &nValue, DWORD nDefaultValue);
    LONG GetBoolRegKey(HKEY hKey, const std::wstring &strValueName, bool &bValue, bool bDefaultValue);
    LONG GetStringRegKey(HKEY hKey, const std::wstring &strValueName, std::wstring &strValue, const std::wstring &strDefaultValue);
#endif

private:

    bool initConfTool();
    QString sendRequest(QString req);
    QString getResult(QString find, QStringList list);


signals:
    void statusProcessNodeChanged();
    void statusServiceNodeChanged();
};

#endif // NODECONFIGTOOLCONTROLLER_H
