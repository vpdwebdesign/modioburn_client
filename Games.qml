import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

import "Common"

Pane {

    property string pageTitle: qsTr("Games")

    property int delegateHeight: 220
    property int gameRectangleWidth: 160
    property int gameRectangleHeight: delegateHeight - 20
    property string gameRectangleColor: "transparent"
    property real gameRectangleOpacity: 1.0
    property int gameYearRectangleWidth: Math.round(gameRectangleWidth / 1.5)
    property int gameFontSize: 16

    property string currentlySelectedGame_thumb
    property string currentlySelectedGame_title

    // prices
    property real gamePrice: itemPriceManager.itemPrice("game")
    property real dvdPrice: itemPriceManager.itemPrice("dvd")
    property real usbDiskPrice: 0.00 // free to copy to customer's own usb disk

    property real ppu: 120.00 // pricePerUnit
    property real totalCost: 120.00

    ParentModel {
        id: parentModelGames
    }

    RowLayout {
        id: searchBarRow
        width: parent.width
        height: 80
        SearchBar {
            id: search
            Layout.alignment: Qt.AlignHCenter
            placeHolder: qsTr("Game title, developer, category, release year")
            fuzzySearchEnabled: true
            onSearchActivated: {
                parentModelGames.filter(ParentModel.Games, searchString)
            }

        }

    }

    Item {
        id: sortBarRow
        width: parent.width
        height: 30
        anchors.top: searchBarRow.bottom
        SortBarGames {
            onSortActivated: {
                parentModelGames.sort(ParentModel.Games, col, sortOrder)
            }
        }

    }

    ListView {
        id:gamesView
        clip: true
        anchors.top: sortBarRow.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        model: parentModelGames.gamesModel
        delegate: gamesDelegate
        ScrollBar.vertical: ScrollBar {
            id: gamesScrollbar
            active: true
            contentItem: Rectangle {
                implicitWidth: 10
                radius: width / 2
                color:gamesScrollbar.pressed ? "#607d8b" : "#a5b7c0"
            }
        }
    }

    Component {
        id: gamesDelegate
        Item {
            width: parent.width
            height: delegateHeight

            Image {
                id: gameThumb
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "file:" + thumb
            }

            MouseArea {
                anchors.fill: gameThumb
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: notYet.open()
            }

            RowLayout {
                height: parent.height
                anchors.left: gameThumb.right
                anchors.leftMargin: 30
                spacing: 20

                Rectangle {
                    id: titleRectangle
                    width: gameRectangleWidth
                    height: gameRectangleHeight
                    color: gameRectangleColor
                    opacity: gameRectangleOpacity

                    Text {
                        id: titleText
                        anchors.centerIn: parent
                        color: "#595959"
                        text: title
                        font.pixelSize: gameFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }

                }

                Rectangle {
                    id: developerRectangle
                    width: gameRectangleWidth
                    height: gameRectangleHeight
                    color: gameRectangleColor
                    opacity: gameRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: developer
                        font.pixelSize: gameFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: publisherRectangle
                    width: gameRectangleWidth
                    height: gameRectangleHeight
                    color: gameRectangleColor
                    opacity: gameRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: publisher
                        font.pixelSize: gameFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: categoryRectangle
                    width: gameRectangleWidth
                    height: gameRectangleHeight
                    color: gameRectangleColor
                    opacity: gameRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: category
                        font.pixelSize: gameFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: yearRectangle
                    width: gameYearRectangleWidth
                    height: gameRectangleHeight
                    color: gameRectangleColor
                    opacity: gameRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: year
                        font.pixelSize: gameFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }
            }


            RowLayout {
                id: buttons
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 40
                spacing: 10
                  Button {
                      text: "Trailer"
                      onClicked: {

                          // test if file can be accessed before opening player window
                          if (fileManager.fileExists(trailer_url))
                          {
                              var videoPlayerComponent = Qt.createComponent("qrc:/Player.qml");
                              if (videoPlayerComponent.status === Component.Ready) {
                                  vpWin = videoPlayerComponent.createObject(mainAppWindow, {
                                                                                "videoUrl": "file:" + trailer_url,
                                                                                "videoTitle": "ModioBurn Video Player - " + title + " trailer"
                                                                            })
                                  vpWin.show()
                                  mainToolBar.videoPlayingIconVisible = true
                                  mainToolBar.videoItemsCountVisible = false
                              }
                          }
                          else
                          {
                              errorDialog.title = "File Not Found"
                              errorMessage.text = "Cannot access the specified file. Please ask the attendant for assistance."
                              errorDialog.open()
                          }
                      }
                  }
                  Button {
                      text: "Buy"
                      onClicked: {
                          currentlySelectedGame_thumb = gameThumb.source
                          currentlySelectedGame_title = titleText.text
                          gameTransactionPopup.open()
                      }
                  }
              }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                height: 1
                color: "#bfbfbf"
                opacity: 0.5
            }
        }
    }
    Popup {
        id: gameTransactionPopup
        modal: true
        focus: true
        x: Math.round((mainAppWindow.width / 2) - (width / 2))
        y: Math.round((mainAppWindow.height / 2) - (height / 2))

        closePolicy: "NoAutoClose"

        ColumnLayout {
            spacing: 10

            RowLayout {
                id: gameDataLayout
                spacing: 20
                height: thumbImage.height + 20

                Image {
                    id: thumbImage
                    source: currentlySelectedGame_thumb
                    fillMode: Image.PreserveAspectFit
                }

                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    Layout.fillWidth: true
                    spacing: 20

                    Label {
                        font.pixelSize: 20
                        font.bold: true
                        text: currentlySelectedGame_title
                    }

                    Label {
                        id: ppuText
                        font.pixelSize: 14
                        font.italic: true
                        text: "Price Per Unit = Ksh" + String(ppu) + ".00"
                    }

                    Label {
                        id: totalCostText
                        font.pixelSize: 14
                        font.italic: true
                        text: "Total Cost = Ksh" + String(totalCost) + ".00"
                    }

                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Label {
                    text: "Where to copy?"
                }

                ComboBox {
                    id: transferOptionSelector
                    implicitWidth: 200
                    model: parentModelGames.copyMediaModel
                    onActivated: {
                        var copyMediumCost = 0.0

                        switch (transferOptionSelector.currentText.toLowerCase()) {
                        case "dvd":
                            copyMediumCost = dvdPrice
                            break
                        case "usb disk":
                            copyMediumCost = usbDiskPrice
                            break
                        }

                        ppu = gamePrice + copyMediumCost
                        totalCost = ppu * numberOfCopiesSelector.value
                    }
                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Label {
                    text: "Copies"
                }

                SpinBox {
                    id: numberOfCopiesSelector
                    from: 1
                    value: 1
                    editable: true
                    onValueChanged: {
                        var copyMediumCost = 0.0

                        switch (transferOptionSelector.currentText.toLowerCase()) {
                        case "dvd":
                            copyMediumCost = dvdPrice
                            break
                        case "usb disk":
                            copyMediumCost = usbDiskPrice
                            break
                        }

                        ppu = gamePrice + copyMediumCost
                        totalCost = ppu * numberOfCopiesSelector.value
                    }
                }
            }

            RowLayout {
                width: parent.width
                spacing: 20

                Button {
                    text: "cancel"
                    onClicked: {
                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        gameTransactionPopup.close()
                    }
                }

                Button {
                    text: "add to cart"
                    onClicked: {
                        var transactionItemsArray = [
                                "Game",
                                currentlySelectedGame_title,
                                numberOfCopiesSelector.value,
                                ppu,
                                totalCost,
                                transferOptionSelector.currentText]

                        shoppingCart.addNewItem(transactionItemsArray)

                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        gameTransactionPopup.close()
                    }
                }
            }
        }
    }

    Dialog {
        id: errorDialog
        x: Math.round(parent.width / 2) - Math.round(width / 2)
        y: Math.round(parent.height / 2) - Math.round(height / 2)
        width: 350
        modal: true
        focus: true
        Label {
            id: errorMessage
            width: parent.width
            wrapMode: Label.Wrap
        }
        standardButtons: Dialog.Close
    }
}
