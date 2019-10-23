/****************************************************************************
**
** This file is part of the CellFrameDashboardGUI application.
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
#include <QDebug>

class DapSettings : public QObject
{
    Q_OBJECT
protected:
    /// Standart constructor.
    explicit DapSettings(QObject *parent = nullptr);
    /// Overloaded constructor.
    /// @param asFileName Settings file name.
    /// @param parent Parent.
    explicit DapSettings(const QString &asFileName, QObject *parent = nullptr);
    
    /// Settings file.
    QFile       m_file;
    /// Settings file name.
    QString     m_fileName;
    
    /// Initialize the components.
    virtual void init();

public:
    /// Read settings file.
    /// @return Virtual json file. If failed read return default json document
    virtual QJsonDocument readFile();
    /// Write settings to file.
    /// @param json Virtual json file.
    /// @return Returns true if the recording was successful, false if the recording failed.
    virtual bool writeFile(const QJsonDocument& json);
    
public:
    /// Removed as part of the implementation of the pattern sington.
    DapSettings(const DapSettings&) = delete;
    DapSettings& operator= (const DapSettings &) = delete;
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapSettings &getInstance();
    /// Get an instance of a class.
    /// @param  asFileName Settings file name
    /// @return Instance of a class.
    Q_INVOKABLE static DapSettings &getInstance(const QString &asFileName);
    
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
    /// @return true if successfull set group value. False is group empty or null
    Q_INVOKABLE bool setGroupPropertyValue(const QString &asGroup, const QString &asKeyProperty,
                                           const QVariant &aValueKeyProperty, const QString &asProperty,
                                           const QVariant &aValuePropery);
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
    /// The default is non-valid value.
    Q_INVOKABLE QVariant getGroupPropertyValue(const QString &asGroup, const QString &asKeyProperty,
                                               const QString &aValueKeyProperty, const QString &asProperty);
    /// Get key value.
    /// @details If the key does not exist, the function returns an invalid value.
    /// @param key Key name.
    Q_INVOKABLE QVariant getKeyValue(const QString &asKey);
    /// Set key value.
    /// @param key Key.
    /// @param value Key value.
    /// @return true if successfull set value. False is key empty or null
    Q_INVOKABLE bool setKeyValue(const QString &asKey, const QVariant &aValue);
    /// Get a collection of values by name group.
    /// @details If the group is not found, the function returns an empty list.
    /// @param group Group name.
    /// @return Group values collection.
    Q_INVOKABLE QList<QVariantMap> getGroupValue(const QString &asGroup);
    /// Set key values for group.
    /// @param group Group name.
    /// @param values Collection of group values.
    /// @return true if successfull set group value. False is group empty or null
    Q_INVOKABLE bool setGroupValue(const QString &asGroup, const QList<QVariantMap> &aValues);
    /// Get the name of the settings file.
    /// @return The name of the settings file.
    const QString &getFileName() const;
    /// Set the name of the settings file.
    /// @param fileName The name of the settings file.
    /// @return Reference of changed object DapSettings
    DapSettings &setFileName(const QString &asFileName);
    
signals:
    /// The signal is emitted when the FileName property changes.
    /// @param asFileName The name of the settings file.
    void fileNameChanged(const QString &asFileName);
    /// The signal is emitted when file needs to close;
    void fileNeedClosed();
    
public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);
};

#endif // DAPSETTINGS_H
