import QtQuick 2.13
import QtQuick.Controls 2.5

TextArea {
    property int positionLine: 2

    id: txtCommands
    anchors.fill: parent

    text: "> "
    wrapMode: TextArea.Wrap
    color: "#707070"
    font.family: "Roboto"
    font.pixelSize: 20 * pt

    Keys.onPressed: {

        switch(event.key)
        {
        case Qt.Key_Backspace:
            event.accepted = (txtCommands.cursorPosition <= txtCommands.positionLine);
            return;
        default: break;
        }
    }

    Keys.onUpPressed: {
        if(txtCommands.positionLine != txtCommands.text.length)
            txtCommands.remove(txtCommands.positionLine, txtCommands.text.length);
        txtCommands.text += dapConsoleModel.getCommandUp();
    }

    Keys.onDownPressed: {
        if(txtCommands.positionLine != txtCommands.text.length)
            txtCommands.remove(txtCommands.positionLine, txtCommands.text.length);
        txtCommands.text += dapConsoleModel.getCommandDown();
    }

    Keys.onReturnPressed: {
        txtCommands.readOnly = true;
        dapConsoleModel.receiveRequest(txtCommands.text.slice(positionLine, txtCommands.text.length));
    }

    onCursorPositionChanged: {
        if(txtCommands.cursorPosition <= txtCommands.positionLine) {
            txtCommands.cursorPosition = txtCommands.positionLine;
        }
    }

    Connections {
        target: dapConsoleModel
        onSendResponse: {
            txtCommands.readOnly = false;
            txtCommands.append(response);
            txtCommands.append("> ");
            txtCommands.positionLine = txtCommands.cursorPosition;
        }
    }
}

