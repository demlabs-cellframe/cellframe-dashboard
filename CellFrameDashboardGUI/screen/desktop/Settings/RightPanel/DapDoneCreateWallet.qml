import QtQuick 2.4
import "../../../"
import "../"

DapDoneCreateWalletForm
{
    dapButtonDone.onClicked:
    {
        navigator.popPage()
    }
}
