import QtQuick 2.0
import "qrc:/screen/controls/"

HeaderItem {
        id: headerItem
        //color: currTheme.backgroundPanel

        onFindHandler: {    //text
            models.certificatesFind.findString = text
            models.certificatesFind.accessKeyTypeIndex = models.accessKeyType.selectedIndex
            models.certificatesFind.update()
        }
    }
