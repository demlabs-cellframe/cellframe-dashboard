import QtQuick 2.0

HeaderItem {
        id: headerItem
        color: currTheme.backgroundPanel

        onFindHandler: {    //text
            models.certificatesFind.findString = text
            models.certificatesFind.accessKeyTypeIndex = models.accessKeyType.selectedIndex
            models.certificatesFind.update()
        }
    }
