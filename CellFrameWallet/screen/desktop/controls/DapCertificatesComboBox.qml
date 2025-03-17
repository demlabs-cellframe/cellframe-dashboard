import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapCustomComboBox
{
    id: sigComboBox

    property string selectedSignature: ""
    property bool isRestoreMode: false
    property alias filteredModel: sigModel

    ListModel {id: sigModel }

    property var certList: [
        {name: "Dilithium", sign: "sig_dil",    secondName: "Recommended"},
        {name: "Falcon",    sign: "sig_falcon", secondName: ""},
        {name: "Bliss",     sign: "sig_bliss",  secondName: "Deprecated"},
        {name: "Picnic",    sign: "sig_picnic", secondName: "Deprecated"}
    ]
    height: 42
    model: sigModel

    backgroundColorShow: currTheme.secondaryBackground
    font: mainFont.dapFont.regular16
    defaultText: qsTr("all signature")

    onCurrentIndexChanged:
    {
        selectedSignature = currentIndex < 0 ? "" : model.get(currentIndex).sign
    }

    Component.onCompleted:
    {
        for(var i = 0; i < certList.length; ++i)
        {
            if(!isRestoreMode && i>1) break;
            sigModel.append({
                       "name": certList[i].name,
                       "sign": certList[i].sign,
                       "secondname": certList[i].secondName
                   })
        }

        setCurrentIndex(0)
    }
}
