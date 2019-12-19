import QtQuick 2.4
import "qrc:/"
import "../../"

DapTabForm {
    id: dapExchangeTab

    anchors.fill: parent

    topPanelForm: DapExchangeTopPanelForm { }

    screenForm: DapExchangeScreenForm { }

    rightPanelForm: DapExchangeRightPanelForm { }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
