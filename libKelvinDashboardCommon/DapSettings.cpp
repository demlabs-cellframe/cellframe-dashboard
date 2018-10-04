#include "DapSettings.h"

/// Standart constructor.
DapSettings::DapSettings(QObject *parent) : QObject(parent)
{
    Q_UNUSED(parent)
    
    init();
}

/// Overloaded constructor.
/// @param fileName Settings file name.
/// @param parent Parent.
DapSettings::DapSettings(const QString &fileName, QObject *parent)
{
    Q_UNUSED(parent)
    
    init();
    
    setFileName(fileName);
}

/// Initialize the components.
void DapSettings::init()
{
    connect(this, &DapSettings::fileNameChanged, this, [=] (const QString &fileName)
    {
        m_file.setFileName(fileName);
    });
}

/// Read settings file.
QJsonDocument DapSettings::readFile()
{
    qDebug() << "File name " << m_file.fileName();
    m_file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString textFile = m_file.readAll();
    m_file.close();
    return QJsonDocument::fromJson(textFile.toUtf8());
}

/// Write settings to file.
/// @param json Virtual json file.
/// @return Returns true if the recording was successful, false if the recording failed.
bool DapSettings::writeFile(const QJsonDocument &json)
{
    if(!m_file.open(QIODevice::WriteOnly))
    {
        qDebug() << "Couldn't open write file." << m_file.errorString();
        return false;
    }
    else
    {
        m_file.open(QIODevice::WriteOnly);
        m_file.write(json.toJson());
        m_file.close();
        return true;
    }
}

/// Get an instance of a class.
/// @return Instance of a class.
DapSettings &DapSettings::getInstance()
{
    static DapSettings instance;
    return instance;
}

/// Get an instance of a class.
/// @return Instance of a class.
DapSettings &DapSettings::getInstance(const QString &fileName)
{
    static DapSettings instance(fileName);
    return instance;
}

/// Set property value in group by key property.
/// @details The search in the group is carried out according to the signs 
/// defining the object: the name of the key property and its value. 
/// To change the value of a property in an object, you must specify 
/// the property parameter and its value. For example, setGroupPropertyValue 
/// ("widgets", "name", "Services client", "visible", true); "name" 
/// is the key property, "Services client" is the value of the key 
/// property, "visible" is a modifiable property, true are the set value.
/// @param group Group name.
/// @param keyProperty Key property.
/// @param valueKeyProperty Key property value.
/// @param property Settable property.
/// @param valuePropery The value of the property being set.
void DapSettings::setGroupPropertyValue(const QString &group, const QString &keyProperty, 
                                        const QVariant &valueKeyProperty, const QString &property, const QVariant &valuePropery)
{
    if(group.isEmpty() || group.isNull())
        return;
    
    auto list = getGroupValue(group);
    
    for(QMap<QString, QVariant> &map : list)
        if(map.find(keyProperty) != map.end() && map.value(keyProperty) == valueKeyProperty)
            map.insert(property, valuePropery);
    
    setGroupValue(group, list);
}

/// Get property value from group by key property value.
/// @details The search in the group is carried out according to the signs 
/// defining the object: the name of the key property and its value. 
/// To change the value of a property in an object, you must specify 
/// the property parameter and its value. For example, setGroupPropertyValue 
/// ("widgets", "name", "Services client", "visible", true); "name" 
/// is the key property, "Services client" is the value of the key 
/// property, "visible" is a modifiable property, true are the set value.
/// See also setGroupPropertyValue.
/// @param group Group name.
/// @param keyProperty Key property.
/// @param valueKeyProperty Key property value.
/// @param property Settable property.
/// @param defaultValue The key value to be inserted in case the key is not found. 
/// The default is non-valid value.
QVariant DapSettings::getGroupPropertyValue(const QString &group, const QString &keyProperty, const QString &valueKeyProperty, const QString &property, const QVariant& defaultValue)
{
    for(QMap<QString, QVariant> &map : getGroupValue(group))
        if(map.find(keyProperty) != map.end() && map.value(keyProperty) == valueKeyProperty)
            return map.value(property);
    return defaultValue;
}

/// Get key value.
/// @details If the key does not exist, the function returns an invalid value.
/// @param key Key name.
/// @param defaultValue The key value to be inserted in case the key is not found. 
/// The default is non-valid value.
QVariant DapSettings::getKeyValue(const QString &key, const QVariant& defaultValue)
{
    QJsonObject root = readFile().object();
    
    QJsonValue jv = root.value(key);
    
    if(!jv.isArray())
    {
        return jv.toVariant();
    }
    
    return defaultValue;
}

/// Set key value.
/// @param key Key.
/// @param value Key value.
void DapSettings::setKeyValue(const QString &key, const QVariant &value)
{
    if(key.isEmpty() || key.isNull())
        return;
    
    QJsonDocument jsonDocument = readFile();
    QJsonObject jsonObject = jsonDocument.object();
    jsonObject.insert(key, value.toJsonValue());
    QJsonDocument jsonDocumentSave(jsonObject);
    writeFile(jsonDocumentSave);
}

/// Get a collection of values by name group.
/// @details If the group is not found, the function returns an empty list.
/// @param group Group name.
/// @return Group values collection.
QList<QMap<QString, QVariant>> DapSettings::getGroupValue(const QString &group)
{
    QJsonObject root = readFile().object();
    
    QJsonValue jv = root.value(group);
    
    QList<QMap<QString, QVariant>> arrayValue;
    
    if(jv.isArray())
    {
        QJsonArray ja = jv.toArray();
        for(QJsonValue jsonValue : ja)
        {
            QJsonObject jsonObject = jsonValue.toObject();
            QMap<QString, QVariant> object;
            for(QString key : jsonObject.keys())
            {
                object.insert(key, jsonObject.value(key).toVariant());
            }
            arrayValue.push_back(object);
        }
    }
        
    return arrayValue;
}

/// Set key values for group.
/// @param group Group name.
/// @param values Collection of group values.
void DapSettings::setGroupValue(const QString &group, const QList<QMap<QString, QVariant> > &values)
{
    if(group.isEmpty() || group.isNull())
        return;
    
    QJsonDocument jsonDocument = readFile();
    QJsonObject jsonObject = jsonDocument.object();
    
    QJsonArray groupValues;
    for(QMap<QString,QVariant> var : values) 
    {
        QJsonObject itemObject;
        for(auto key : var.keys()) 
        {
            itemObject.insert(key, var.value(key).toJsonValue());
        }
        groupValues.append(itemObject);
    }
    
    jsonObject.insert(group, groupValues);
    QJsonDocument jsonDocumentSave(jsonObject);
    writeFile(jsonDocumentSave);
}

/// Get the name of the settings file.
/// @return The name of the settings file.
QString DapSettings::getFileName() const
{
    return m_fileName;
}

/// Set the name of the settings file.
/// @param fileName The name of the settings file.
void DapSettings::setFileName(const QString &fileName)
{
    m_fileName = fileName;
    emit fileNameChanged(m_fileName);
}

/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapSettings::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    
    return &getInstance();
}
