TEMPLATE = subdirs

SUBDIRS = cellframe-sdk \
          CellFrameDashboard \

CellFrameDashboard.depends=cellframe-sdk

include(config.pri)

TRANSLATIONS += \
    Resources/Translations/Translation_ru.ts \
    Resources/Translations/Translation_zh.ts \
    Resources/Translations/Translation_cs.ts \
    Resources/Translations/Translation_pt.ts \
    Resources/Translations/Translation_nl.ts
