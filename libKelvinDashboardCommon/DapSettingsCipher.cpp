#include "DapSettingsCipher.h"

DapSettingsCipher::DapSettingsCipher(const DapSettings& settings) 
    : DapSettings(), m_settings(settings)
{
    setFileName(settings.getFileName());
}

QByteArray DapSettingsCipher::encrypt(const QByteArray &byteArray) const
{
    return m_settings.encrypt(byteArray);
}

QByteArray DapSettingsCipher::decrypt(const QByteArray &byteArray) const
{
    return m_settings.decrypt(byteArray);
}

DapSettingsCipher &DapSettingsCipher::getInstance(const DapSettings& settings)
{
    static DapSettingsCipher instance(settings);
    return instance;
}
