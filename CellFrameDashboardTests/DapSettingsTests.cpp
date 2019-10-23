#include "gtest/gtest.h"

#include "DapSettings.h"

#include <QJsonDocument>
#include <QJsonObject>

TEST(DapSettingsTest, settingFileName)
{
    // set filename to setting file
    // 1. set filename to settings
    // 2. check what filename in DapSettings equal

    // 1. set filename to settings
    const QString filename = "settings.json";
    DapSettings::getInstance().setFileName(filename);

    // 2. check what filename in DapSettings equal
    EXPECT_EQ(DapSettings::getInstance().getFileName(), filename);
}

TEST(DapSettingsTest, writeFile)
{
    // test for check write and read data in file
    // 1. Write to file data
    // 2. Read from file data
    // 3. Compare data

    // 1. Write to file data
    QJsonObject object;
    const QString networkName = "test";
    object["network"] = networkName;
    const QString filename = "settings.json";
    DapSettings::getInstance(filename).writeFile(QJsonDocument(object));

    // 2. Read from file data
    const QJsonDocument dataFromFile = DapSettings::getInstance(filename).readFile();

    // 3. Compare data
    EXPECT_EQ(dataFromFile.object(), object);
    
}

TEST(DapSettingsTest, FailedReadFromNotExistingFile)
{
    // test for check failed reading when file doesn't exist
    // 1. Read from empty file. Example: "notexist.json"
    // 2. Check what readed jsonDocument is null

    // 1. Read from empty file. Example: "notexist.json"
    const QString filename = "notexist.json";
    DapSettings::getInstance(filename).setFileName(filename);
    const QJsonDocument notExistingDocument = DapSettings::getInstance(filename).readFile();

    // 2. Check what readed jsonDocument is empty
    EXPECT_TRUE(notExistingDocument.isNull());
}

TEST(DapSettingsTest, FailedReadFromEmptyFile)
{
    // test for check failed reading when file is empty
    // 1. Creating empty file
    // 2. Read from empty file. Example: "empty.json". Create this file
    // 3. Check what readed jsonDocument is empty

    // 1. Creating empty file
    const QString filename = "empty.json";
    DapSettings::getInstance(filename).writeFile(QJsonDocument());

    // 2. Read from empty file. Example: "empty.json"
    QJsonDocument emptyDocument = DapSettings::getInstance(filename).readFile();

    // 3. Check what readed jsonDocument is empty
    EXPECT_TRUE(emptyDocument.isEmpty());
}

TEST(DapSettingsTest, FailedWriteEmptyData)
{
    // test for check failed write empty data
    // 1. Check what Failed write empty data to file. Example: "emptyData.json"

    // 1. Check what Failed write empty data to file. Example: "emptyData.json"
    EXPECT_FALSE(DapSettings::getInstance("emptyData.json").writeFile(QJsonDocument()));
}

TEST(DapSettingsTest, SetKeyValue)
{
    // test for check set key value to file
    // 1. Set key value to file. Example: "keys.json"
    // 2. Get value from file
    // 3. Comparing values are equal

    // 1. Set key value to file. Example: "keys.json"
    const QString filename = "keys.json";
    DapSettings::getInstance(filename).setFileName(filename);
    const QString key = "key";
    const QString value = "value";
    DapSettings::getInstance(filename).setKeyValue(key, value);

    // 2. Get value from file
    const QVariant gettingValue = DapSettings::getInstance(filename).getKeyValue(key);

    // 3. Comparing values are equal
    EXPECT_EQ(value, gettingValue.toString());
}

TEST(DapSettingsTest, FailedSetKeyValueByEmptyKey)
{
    // test for check failed set key value by empty key
    // 1. Check what value doesn't write to file by empty key. Example: "keys.json"

    // 1. Check what value doesn't write to file by empty key. Example: "keys.json"
    EXPECT_FALSE(DapSettings::getInstance("keys.json").setKeyValue("", "value"));
}

TEST(DapSettingsTest, FailedSetEmptyKeyValue)
{
    // test for check failed set empty key value
    // 1. Check what empty value doesn't write to file. Example: "keys.json"

    // 1. Check what empty value doesn't write to file. Example: "keys.json"
    EXPECT_FALSE(DapSettings::getInstance("keys.json").setKeyValue("key", QVariant()));
}

TEST(DapSettingsTest, SetGroupValue)
{
    // test check for setting group value in file
    // 1. Set group value in file. Example: "group.json"
    // 2. Get group value from file
    // 3. Compare two values

    // 1. Set group value in file. Example: "group.json"
    const QVariantMap map { {"1", "A"}, {"2", "B"} };
    QList<QVariantMap> list;
    list.append(map);
    const QString filename = "group.json";
    const QString key = "group";
    DapSettings::getInstance(filename).setGroupValue(key, list);

    // 2. Get group value from file
    auto gettingList = DapSettings::getInstance(filename).getGroupValue(key);

    // 3. Compare two values
    EXPECT_EQ(list, gettingList);
}

TEST(DapSettingsTest, FailedSetGroupValueByEmptyGroupName)
{
    // test check for failed set group value because group name is empty
    // 1. Check failed set group value by empty group name

    // 1. Check failed set group value by empty group name
    const QVariantMap map { {"1", "A"}, {"2", "B"} };
    QList<QVariantMap> list;
    list.append(map);
    const QString filename = "group.json";
    EXPECT_FALSE(DapSettings::getInstance("group.json").setGroupValue(QString(), list));
}
