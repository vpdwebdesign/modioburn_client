import QtQuick 2.9
import QtQuick.Controls 2.2

Dialog {
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 380
    modal: true
    title: "Functionality Not Yet Available"

    Label {
        width: parent.width
        text: "This functionality has not yet been built. Click anywhere outside this dialog box to continue."
        wrapMode: Label.Wrap
    }

    standardButtons: Dialog.Close
}
