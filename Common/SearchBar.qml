import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    id: searchBar

    property bool fuzzySearchEnabled: false
    property alias placeHolder: searchBarTextField.placeholderText
    signal searchActivated(string searchString)

    width: parent.width
    height: parent.height

    Image {
        id: searchIcon
        source: "qrc:/assets/icons/search.png"
        anchors.right: searchBarTextField.left
        anchors.rightMargin: 5
        anchors.verticalCenter: searchBarTextField.verticalCenter
    }
    TextField {
        id: searchBarTextField
        anchors.centerIn: parent
        selectByMouse: true
        onTextEdited: {
            if (fuzzySearchEnabled)
            {
                if (text.length > 2)
                    searchBar.searchActivated(text)
                else
                    searchBar.searchActivated("")
            }
        }
    }
    Button {
        id: searchButton
        anchors.left: searchBarTextField.right
        anchors.leftMargin: 15
        anchors.verticalCenter: searchBarTextField.verticalCenter
        text: "Search"
        enabled: !fuzzySearchEnabled
        onClicked: searchBar.searchActivated(searchBarTextField.text)
    }
}
