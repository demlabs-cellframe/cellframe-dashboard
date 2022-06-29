#include "autocompletevalues.h"
#include <QDir>
#include <QFile>

#ifdef Q_OS_WIN
#include "registry.h"
#define PUB_CERT_PATH QString("%1/cellframe-node/var/lib/ca").arg(regGetUsrPath())
#define PRIV_CERT_PATH QString("%1/cellframe-node/share/ca").arg(regGetUsrPath())
#endif

#ifdef Q_OS_MAC
#define PUB_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/share/ca/").arg(getenv("USER"))
#define PRIV_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/lib/ca/").arg(getenv("USER"))
#endif

#ifdef Q_OS_LINUX
#define PUB_CERT_PATH QString("/opt/cellframe-node/share/ca")
#define PRIV_CERT_PATH QString("/opt/cellframe-node/var/lib/ca")
#endif

void AutocompleteValues::_getCerts()
{
   /* QDir pubDir(PUB_CERT_PATH);
    QStringList files = pubDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            certs.append(s);
    }*/

    QDir privDir(PRIV_CERT_PATH);
    QStringList files = privDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            certs.append(s);
    }
}

AutocompleteValues::AutocompleteValues(QObject *parent)
    : QObject{parent}
{
    _getCerts();
}

QStringList AutocompleteValues::getCerts()
{
    return certs;
}
