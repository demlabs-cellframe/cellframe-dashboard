#include "LoadPlugin.h"
namespace cellframe{

LoadPlugin::LoadPlugin(QString pathZipORFolder, QString pathPlug)
{
qDebug()<<"load construct";
QString verification=pathZipORFolder.mid(pathZipORFolder.count()-4,pathZipORFolder.count());
if(verification == ".zip")
{
    _isZip = true;
    _pathPlugin = pathPlug;
    _pathZipPlugin = pathZipORFolder;
    qDebug()<<"[LoadPlugin] from zip archiv"<<_pathZipPlugin;
    QStringList listZip;
    QuaZip file(_pathZipPlugin);
    if(file.open(QuaZip::mdUnzip))
    {
        listZip = file.getFileNameList ();
    }
    file.close();
    unzipPlugin();
    _pathPlugin+=listZip.at(0);
}
else
{
    _isZip = false;
    _pathPlugin = pathZipORFolder;
    _pathZipPlugin = pathZipORFolder;
    qDebug()<<"[LoadPlugin] from folder (the path remains unchanged)"<<_pathPlugin;
}
}

//void LoadPlugin::setFileOrDirectory(QString pathZipORFolder, QString pathPlug)
//{
//    qDebug()<<"Set Date";
//    QString verification=pathZipORFolder.mid(pathZipORFolder.count()-4,pathZipORFolder.count());
//    if(verification == ".zip")
//    {
//        _isZip = true;
//        _pathPlugin = pathPlug;
//        _pathZipPlugin = pathZipORFolder;
//        qDebug()<<"[LoadPlugin] from zip archiv"<<_pathZipPlugin;
//        QStringList listZip;
//        QuaZip file(_pathZipPlugin);
//        if(file.open(QuaZip::mdUnzip))
//        {
//            listZip = file.getFileNameList ();
//        }
//        file.close();
//        unzipPlugin();
//        _pathPlugin+=listZip.at(0);
//    }
//    else
//    {
//        _isZip = false;
//        _pathPlugin = pathZipORFolder;
//        _pathZipPlugin = pathZipORFolder;
//        qDebug()<<"[LoadPlugin] from folder (the path remains unchanged)"<<_pathPlugin;
//    }
//}

LoadPlugin::~LoadPlugin()
{
    qDebug()<<"Load distruct";
if(_isZip)
{
    _deleteFolderPlagin(_pathPlugin);
}
}

bool LoadPlugin::_deleteFolderPlagin(const QString & dirName)
{
    bool result = true;
    QDir dir(dirName);

    if (dir.exists(dirName)) {
        Q_FOREACH(QFileInfo info, dir.entryInfoList(QDir::NoDotAndDotDot | QDir::System | QDir::Hidden
                                                    | QDir::AllDirs | QDir::Files, QDir::DirsFirst)) {
            if (info.isDir()) {
                result = _deleteFolderPlagin(info.absoluteFilePath());
            }
            else {
                result = QFile::remove(info.absoluteFilePath());
            }

            if (!result) {
                return result;
            }
        }
        result = dir.rmdir(dirName);
    }
    return result;
}

bool LoadPlugin::unzipPlugin()
{
    if(_isZip)
    {
        qDebug()<<"[LoadPlugin] zip unpacking";
        JlCompress::extractDir(_pathZipPlugin,_pathPlugin);
    }
}

QString LoadPlugin::getPathPlugin()
{
    return _pathPlugin;
}

QString LoadPlugin::getPathZip()
{
    return _pathZipPlugin;
}
}
