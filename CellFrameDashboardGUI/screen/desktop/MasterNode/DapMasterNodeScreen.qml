import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtGraphicalEffects 1.0
import "../controls"
import "../../"
import "qrc:/widgets"

Page {
    id: dapMasterNodeScreen

    background: Rectangle
    {
        color: currTheme.mainBackground
    }

    Component.onCompleted: {
        console.log("[KTT]", "onCompleted")
    }
}
