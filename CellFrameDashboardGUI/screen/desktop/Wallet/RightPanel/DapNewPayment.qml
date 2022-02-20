import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12

DapNewPaymentForm {
    property var testModel: ["network1", "network2", "network3"]

    networkComboBox.model: networksList
}
