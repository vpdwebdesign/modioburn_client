import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    x: Math.round((parent.width - width) / 2)
    y: Math.round(parent.height / 6)
    width: 480
    modal: true
    focus: true
    title: "Modio Burn Logout"

    Label {
        text: qsTr("Are you sure you want to logout?")
    }

    standardButtons: Dialog.No | Dialog.Yes
}
