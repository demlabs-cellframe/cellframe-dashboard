#ifndef LOADPLUGINZIP_H
#define LOADPLUGINZIP_H
#include "quazip.h"
#include "quazipfile.h"
#include <QDir>
#include "JlCompress.h"
#include <QString>
#include <QDebug>
namespace cellframe{
class LoadPlugin
{
public:
    LoadPlugin(QString pathZipORFolder, QString pathPlug);
    ~LoadPlugin();
    bool unzipPlugin();

    QString getPathPlugin();
    QString getPathZip();
    //void setFileOrDirectory(QString pathZipORFolder, QString pathPlug);
private:
    bool _deleteFolderPlagin(const QString &dirName);
    bool _isZip;
    QString _pathPlugin;
    QString _pathZipPlugin;
};
}
#endif // LOADPLUGINZIP_H
