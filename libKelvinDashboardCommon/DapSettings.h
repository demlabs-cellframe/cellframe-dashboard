/****************************************************************************
**
** This file is part of the KelvinDashboardGUI application.
** 
** The class provides an interface for managing application settings. 
** Record format - Json.
** 
** Implements a singleton pattern.
**
****************************************************************************/

#ifndef DAPSETTINGS_H
#define DAPSETTINGS_H

#include <QObject>
#include <QFile>
#include <QQmlEngine>
#include <QJSEngine>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QIODevice>
#include <QDebug>

class DapSettings : public QObject
{
    Q_OBJECT
    
protected:
    /// Standart constructor.
    explicit DapSettings(QObject *parent = nullptr);
    /// Overloaded constructor.
    /// @param fileName Settings file name.
    /// @param parent Parent.
    explicit DapSettings(const QString &fileName, QObject *parent = nullptr);
    
    /// Settings file.
    QFile       m_file;
    /// Settings file name.
    QString     m_fileName;
    
    /// Initialize the components.
    virtual void init();
    /// Read settings file.
    /// @return Virtual json file.
    virtual QJsonDocument readFile();
    /// Write settings to file.
    /// @param json Virtual json file.
    /// @return Returns true if the recording was successful, false if the recording failed.
    virtual bool writeFile(const QJsonDocument& json);
    
    
    
public:
    virtual QByteArray encrypt(const QByteArray &byteArray) const;
    
    virtual QByteArray decrypt(const QByteArray &byteArray) const;
    
    /// Removed as part of the implementation of the pattern sington.
    DapSettings(const DapSettings&) = delete;
    DapSettings& operator= (const DapSettings &) = delete;
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapSettings &getInstance();
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapSettings &getInstance(const QString &fileName);
    
    ///********************************************
    ///                 Property
    /// *******************************************
    
    /// Settings file name.
    Q_PROPERTY(QString FileName MEMBER m_fileName READ getFileName WRITE setFileName NOTIFY fileNameChanged)
    
    ///********************************************
    ///                 Interface
    /// *******************************************
    
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
    Q_INVOKABLE void setGroupPropertyValue(const QString &group, const QString &keyProperty, const QVariant &valueKeyProperty, const QString &property, const QVariant &valuePropery);
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
    Q_INVOKABLE QVariant getGroupPropertyValue(const QString &group, const QString &keyProperty, const QString &valueKeyProperty, const QString &property, const QVariant &defaultValue = QVariant());
    /// Get key value.
    /// @details If the key does not exist, the function returns an invalid value.
    /// @param key Key name.
    /// @param defaultValue The key value to be inserted in case the key is not found. 
    /// The default is non-valid value.
    Q_INVOKABLE QVariant getKeyValue(const QString &key, const QVariant &defaultValue = QVariant());
    /// Set key value.
    /// @param key Key.
    /// @param value Key value.
    Q_INVOKABLE void setKeyValue(const QString &key, const QVariant &value);
    /// Get a collection of values by name group.
    /// @details If the group is not found, the function returns an empty list.
    /// @param group Group name.
    /// @return Group values collection.
    Q_INVOKABLE QList<QMap<QString, QVariant> > getGroupValue(const QString &group);
    /// Set key values for group.
    /// @param group Group name.
    /// @param values Collection of group values.
    Q_INVOKABLE void setGroupValue(const QString &group, const QList<QMap<QString, QVariant>> &values);
    /// Get the name of the settings file.
    /// @return The name of the settings file.
    QString getFileName() const;
    /// Set the name of the settings file.
    /// @param fileName The name of the settings file.
    void setFileName(const QString &fileName);
    
signals:
    /// The signal is emitted when the FileName property changes.
    /// @param fileName The name of the settings file.
    void fileNameChanged(const QString &fileName);
    
public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPSETTINGS_H
