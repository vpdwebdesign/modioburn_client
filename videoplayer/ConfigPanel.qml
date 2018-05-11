import QtQuick 2.10

import "utils.js" as Utils

Rectangle {
    id: root
    layer.enabled: true
    property string selected: ""
    property string selectedUrl
    property int selectedX: 0
    property int selectedY: 0
    color: "#80101010"

    signal clicked

    Menu {
        id: menu
        anchors.fill: parent
        anchors.topMargin: Utils.scaled(40)
        itemWidth: root.width - Utils.scaled(2)
        spacing: Utils.scaled(1)
        model: ListModel {
            id: contentModel
        }
        onClicked: {
            selectedX = x
            selectedY = y
            selectedUrl = model.get(index).url
            root.clicked()
        }
    }
    Component.onCompleted: {
        contentModel.append({name: qsTr("Effect"), url: "EffectPage.qml" })
        contentModel.append({name: qsTr("Subtitle"), url: "SubtitlePage.qml" })
    }

    states: [
        State {
            name: "show"
            PropertyChanges {
                target: root
                opacity: 0.9
                anchors.rightMargin: 0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: root
                opacity: 0
                anchors.rightMargin: -root.width
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"; to: "*"
            PropertyAnimation {
                properties: "opacity,anchors.rightMargin"
                easing.type: Easing.OutQuart
                duration: 500
            }
        }
    ]
}
