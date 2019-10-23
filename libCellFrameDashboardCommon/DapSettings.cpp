#include "DapSettings.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QIODevice>

/// Standart constructor.
DapSettings::DapSettings(QObject *parent) : QObject(parent)
{
    Q_UNUSED(parent)
    
    init();
}

/// Overloaded constructor.
/// @param fileName Settings file name.
/// @param parent Parent.
DapSettings::DapSettings(const QString &asFileName, QObject *parent)
{
    Q_UNUSED(parent)
    
    init();
    
    setFileName(asFileName);
}

/// Initialize the components.
void DapSettings::init()
{
    connect(this, &DapSettings::fileNameChanged, this, [=] (const QString &asFileName)
    {
        m_file.setFileName(asFileName);
    });

    connect(this, &DapSettings::fileNeedClosed, [=] () { m_file.close(); });
}

/// Read settings file.
/// @return Virtual json file. If failed read return default json document
QJsonDocument DapSettings::readFile()
{
    if(!m_file.exists()) {
        qWarning() << "File  doesn't exist." << "Creating file with name " << m_fileName;
        m_file.open(QIODevice::ReadOnly | QIODevice::Text);
        emit fileNeedClosed();
        return QJsonDocument();
    }

    if(!m_file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Failed to read file " << m_file.errorString();
        emit fileNeedClosed();
        return QJsonDocument();
    }

    const QByteArray data = m_file.readAll();
    if(data.isEmpty()) {
        qWarning() << "Failed to read data. File " << m_fileName << " is empty";
        return QJsonDocument();
    }

    emit fileNeedClosed();

    return QJsonDocument::fromJson(data);
}

/// Write settings to file.
/// @param json Virtual json file.
/// @return Returns true if the recording was successful, false if the recording failed.
bool DapSettings::writeFile(const QJsonDocument &json)
{
    if(!m_file.open(QIODevice::WriteOnly)) {
        qWarning() << "Couldn't open write file." << m_file.errorString();
        return false;
    }

    const qint64 bytes = m_file.write(json.toJson());
    if(bytes <= 0) {
        qWarning() << "Failed to write file with error: " << m_file.errorString();
        return false;
    }

    qDebug() << "write bytes " << bytes << " to file " << m_fileName;
    emit fileNeedClosed();

    return true;
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
DapSettings &DapSettings::getInstance(const QString &asFileName)
{
    static DapSettings instance(asFileName);
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
bool DapSettings::setGroupPropertyValue(const QString &asGroup, const QString &asKeyProperty,
                                        const QVariant &aValueKeyProperty, const QString &asProperty,
                                        const QVariant &aValueProperty)
{
    if(asGroup.isEmpty() || asGroup.isNull())
        return false;
    
    auto list = getGroupValue(asGroup);
    if(list.empty()) {
        QVariantMap map { {asProperty, aValueProperty} };
        list.append(map);
    } else {
        for(auto &map : list)
            if(map.find(asKeyProperty) != map.end() && map.value(asKeyProperty) == aValueKeyProperty)
                map.insert(asProperty, aValueProperty);
    }

    return setGroupValue(asGroup, list);
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
QVariant DapSettings::getGroupPropertyValue(const QString &asGroup, const QString &aKeyProperty,
                                            const QString &aValueKeyProperty, const QString &asProperty)
{
    for(const QMap<QString, QVariant> &map : getGroupValue(asGroup))
        if(map.find(aKeyProperty) != map.end() && map.value(aKeyProperty) == aValueKeyProperty)
            return map.value(asProperty);
    return QVariant();
}

/// Get key value.
/// @details If the key does not exist, the function returns an invalid value.
/// @param key Key name.
QVariant DapSettings::getKeyValue(const QString &asKey)
{
    const QJsonValue value = readFile().object().value(asKey);
    if(value.isNull() || value.isUndefined())
        return QVariant();

    return value.toVariant();
}

/// Set key value.
/// @param key Key.
/// @param value Key value.
bool DapSettings::setKeyValue(const QString &asKey, const QVariant &aValue)
{
    if(asKey.isEmpty() || asKey.isNull())
        return false;
    
    if(aValue.isNull() || !aValue.isValid())
        return false;

    QJsonObject jsonObject = readFile().object();
    jsonObject.insert(asKey, aValue.toJsonValue());
    return writeFile(QJsonDocument(jsonObject));
}

/// Get a collection of values by name group.
/// @details If the group is not found, the function returns an empty list.
/// @param group Group name.
/// @return Group values collection.
QList<QVariantMap> DapSettings::getGroupValue(const QString &asGroup)
{
    if(asGroup.isEmpty() || asGroup.isNull()) {
        qWarning() << "Failed get group value because group's name is undefined";
        return QList<QVariantMap>();
    }

    const QJsonValue jsonGroupValue = readFile().object().value(asGroup);
    if(jsonGroupValue.isNull() || jsonGroupValue.isUndefined()) {
        qWarning() << "Failed get group value because group " << asGroup << " doesn't exist";
        return QList<QVariantMap>();
    }

    if(!jsonGroupValue.isArray()) {
        qWarning() << "Failed get group value because group " << asGroup << " isn't array of values";
        return QList<QVariantMap>();
    }

    QList<QVariantMap> collection;
    const QJsonArray jsonGroupArray = jsonGroupValue.toArray();
    for(const QJsonValue &jsonValue : jsonGroupArray)
    {
        const QJsonObject jsonObject = jsonValue.toObject();
        if(!jsonValue.isObject()) {
            qDebug() << jsonObject << " isn't object. Read next field...";
            continue;
        }

        QVariantMap map;
        for(const QString &key : jsonObject.keys())
            map.insert(key, jsonObject.value(key).toVariant());

        collection.push_back(map);
    }

    return collection;
}

/// Set key values for group.
/// @param group Group name.
/// @param values Collection of group values.
bool DapSettings::setGroupValue(const QString &asGroup, const QList<QVariantMap> &aValues)
{
    if(asGroup.isEmpty() || asGroup.isNull())
        return false;
    
    QJsonArray groupValues;
    for(const auto & map : aValues)
    {
        QJsonObject itemObject;
        for(const auto &key : map.keys())
            itemObject.insert(key, map.value(key).toJsonValue());

        groupValues.append(itemObject);
    }
    
    return setKeyValue(asGroup, groupValues);
}

/// Get the name of the settings file.
/// @return The name of the settings file.
const QString &DapSettings::getFileName() const
{
    return m_fileName;
}

/// Set the name of the settings file.
/// @param fileName The name of the settings file.
/// @return Reference of changed object DapSettings
DapSettings &DapSettings::setFileName(const QString &asFileName)
{
    m_fileName = asFileName;
    emit fileNameChanged(asFileName);
    return *this;
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
