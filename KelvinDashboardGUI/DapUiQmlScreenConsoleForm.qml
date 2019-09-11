import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {

    TextEdit {
        id: txtCommands
        property int positionLine: 2
        anchors.fill: parent

        text: "> "
        wrapMode: TextEdit.WordWrap


//        onTextChanged: {
//            if(txtCommands.cursorPosition > txtCommands.positionLine)
//            {
//                txtCommands.text += " ";
//                txtCommands.cursorPosition = txtCommands.text.length
//            }
//        }

        Keys.onPressed: {

            switch(event.key)
            {
//            case Qt.Key_Up:
//                console.debug("UP");
////                txtCommands.remove(positionLine, txtCommands.text.length);
////                txtCommands.text += dapConsoleController.getCommandUp();
//                txtCommands.cursorPosition = txtCommands.text.length;
//                break;
//            case Qt.Key_Down: console.debug("Down"); break;
//            case Qt.Key_Left:
//                if(txtCommands.cursorPosition <= txtCommands.positionLine)
//                {
//                    console.debug(txtCommands.cursorPosition + ":" + txtCommands.positionLine + ":" + txtCommands.text.length);
//                    txtCommands.cursorPosition = txtCommands.text.length;
//                }
//                break;
            case Qt.Key_Backspace:
                console.debug("Remove");
                if(txtCommands.cursorPosition <= txtCommands.positionLine)
                {
                    txtCommands.text += " ";
                    txtCommands.cursorPosition = txtCommands.text.length
                }

                break;
            default: break;
            }
        }

        Keys.onLeftPressed: {

        }

        Keys.onUpPressed: {

        }

        Keys.onDownPressed: {

        }

        Keys.onDeletePressed: {
            console.debug("delete");
        }

        Keys.onBackPressed: {
            console.debug("back");
        }

        Keys.onReturnPressed: {
            txtCommands.readOnly = true;
            dapConsoleController.receiveRequest(txtCommands.text.slice(positionLine, txtCommands.text.length));
        }

        Connections {
            target: dapConsoleController
            onSendResponse: {
                txtCommands.readOnly = false;
                txtCommands.append(response);
                txtCommands.append("> ");
                txtCommands.positionLine = txtCommands.cursorPosition;
            }
        }
    }
}
