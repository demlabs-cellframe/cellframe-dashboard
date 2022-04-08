import QtQuick 2.0
import "../../controls/"

HeaderItem {
        id: headerItem

        onFindHandler: {    //text
            models.certificatesFind.findString = text
            models.certificatesFind.accessKeyTypeIndex = models.accessKeyType.selectedIndex
            models.certificatesFind.update()
        }
    }
