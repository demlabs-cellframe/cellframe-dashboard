import QtQuick 2.4
import "qrc:/"
import "../../"

DapAbstractTab 
{
    id: exchangeTab

    dapTopPanel: DapExchangeTopPanel { }

    dapScreen: DapExchangeScreen { }

    dapRightPanel: DapExchangeRightPanel { }
}


/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
