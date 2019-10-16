#ifndef DAPSETTINGSCIPHER_H
#define DAPSETTINGSCIPHER_H

#include <QObject>

#include "DapSettings.h"

class DapSettingsCipher : public DapSettings
{
    Q_OBJECT
    
protected:
    
    const DapSettings   &m_settings;
    
    DapSettingsCipher(const DapSettings& settings);
     
public:
    virtual QByteArray encrypt(const QByteArray &byteArray) const;
    
    virtual QByteArray decrypt(const QByteArray &byteArray) const;
    
    /// Removed as part of the implementation of the pattern sington.
    DapSettingsCipher(const DapSettingsCipher&) = delete;
    DapSettingsCipher& operator= (const DapSettingsCipher &) = delete;
    
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapSettingsCipher &getInstance(const DapSettings& settings);
};

#endif // DAPSETTINGSCIPHER_H
