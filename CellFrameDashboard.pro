TEMPLATE = subdirs

SUBDIRS = cellframe-sdk \
          CellFrameDashboardGUI \
          CellFrameDashboardService \

CellFrameDashboardGUI.depends=cellframe-sdk
CellFrameDashboardService.depends=cellframe-sdk

include(config.pri)


TRANSLATIONS += \
    Resources/Translations/Translation_ru.ts \
    Resources/Translations/Translation_zh.ts \
    Resources/Translations/Translation_cs.ts \
    Resources/Translations/Translation_pt.ts \
    Resources/Translations/Translation_nl.ts
