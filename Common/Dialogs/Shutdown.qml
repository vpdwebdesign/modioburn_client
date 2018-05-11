import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    x: Math.round((parent.width - width) / 2)
    y: Math.round(parent.height / 6)
    width: 480
    modal: true
    focus: true
    title: "Shutdown Modio Burn"

    Label {
        text: qsTr("Are you sure you want to shutdown Modio Burn?\n\n")
            + qsTr("This will log you out and any clients currently logged in!")
    }

    standardButtons: Dialog.No | Dialog.Yes
}
