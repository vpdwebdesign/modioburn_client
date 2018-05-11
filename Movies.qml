import QtQuick 2.9
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import ModioBurn.Tools 1.0

import "Common"

Pane {

    property string pageTitle: qsTr("Movies")

    property int delegateHeight: 220
    property int movieRectangleWidth: 160
    property int movieRectangleHeight: delegateHeight - 20
    property string movieRectangleColor: "transparent"
    property real movieRectangleOpacity: 1.0
    property int movieYearRectangleWidth: Math.round(movieRectangleWidth / 1.5)
    property int movieFontSize: 16

    property string currentlySelectedMovie_thumb
    property string currentlySelectedMovie_title

    // prices
    property real moviePrice: itemPriceManager.itemPrice("movie")
    property real dvdPrice: itemPriceManager.itemPrice("dvd")
    property real usbDiskPrice: 0.00

    property real ppu: 50.00 // pricePerUnit
    property real totalCost: 50.00

    ParentModel {
        id: parentModelMovies
    }

    RowLayout {
        id: searchBarRow
        width: parent.width
        height: 80
        SearchBar {
            Layout.alignment: Qt.AlignHCenter
            placeHolder: qsTr("Movie title, star, director, category or year")
            fuzzySearchEnabled: true
            onSearchActivated: {
                parentModelMovies.filter(ParentModel.Movies, searchString)
            }
        }

    }

    Item {
        id: sortBarRow
        width: parent.width
        height: 30
        anchors.top: searchBarRow.bottom
        SortBarMovies {
            onSortActivated: {
                parentModelMovies.sort(ParentModel.Movies, col, sortOrder)
            }
        }

    }

    ListView {
        id: moviesView
        clip: true
        anchors.top: sortBarRow.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        model: parentModelMovies.moviesModel
        delegate: moviesDelegate
        ScrollBar.vertical: ScrollBar {
            id: moviesScrollbar
            active: true
            contentItem: Rectangle {
                implicitWidth: 10
                radius: width / 2
                color: moviesScrollbar.pressed ? "#607d8b" : "#a5b7c0"
            }
        }
    }

    Component {
        id: moviesDelegate

        Item {
            width: parent.width
            height: delegateHeight

            Image {
                id: movieThumb
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "file:" + thumb
            }

            MouseArea {
                anchors.fill: movieThumb
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: notYet.open()
            }

            RowLayout {
                height: parent.height
                anchors.left: movieThumb.right
                anchors.leftMargin: 30
                spacing: 20

                Rectangle {
                    id: titleRectangle
                    width: movieRectangleWidth
                    height: movieRectangleHeight
                    color: movieRectangleColor
                    opacity: movieRectangleOpacity

                    Text {
                        id: titleText
                        anchors.centerIn: parent
                        color: "#595959"
                        text: title
                        font.pixelSize: movieFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }

                }

                Rectangle {
                    id: starsRectangle
                    width: movieRectangleWidth
                    height: movieRectangleHeight
                    color: movieRectangleColor
                    opacity: movieRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: stars.replace(/{|}|"/g, "").replace(/,/g, ", ");
                        font.pixelSize: movieFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: directorRectangle
                    width: movieRectangleWidth
                    height: movieRectangleHeight
                    color: movieRectangleColor
                    opacity: movieRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: director
                        font.pixelSize: movieFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: categoryRectangle
                    width: movieRectangleWidth
                    height: movieRectangleHeight
                    color: movieRectangleColor
                    opacity: movieRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: category.replace(/{|}|"/g, '').replace(/,/g, ", ");
                        font.pixelSize: movieFontSize
                        width: parent.width - 10
                        wrapMode: Text.WordWrap
                    }
                }

                Rectangle {
                    id: yearRectangle
                    width: movieYearRectangleWidth
                    height: movieRectangleHeight
                    color: movieRectangleColor
                    opacity: movieRectangleOpacity

                    Text {
                        anchors.centerIn: parent
                        color: "#595959"
                        text: year
                        font.pixelSize: movieFontSize
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
                    text: "Watch"
                    onClicked: {

                        // test if file can be accessed before opening player window
                        if (fileManager.fileExists(url))
                        {
                            var videoPlayerComponent = Qt.createComponent("qrc:/Player.qml");
                            if (videoPlayerComponent.status === Component.Ready) {
                                vpWin = videoPlayerComponent.createObject(mainAppWindow, {
                                                                              "videoUrl": "file:" + url,
                                                                              "videoTitle": "ModioBurn Video Player - " + title
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
                          currentlySelectedMovie_thumb = movieThumb.source
                          currentlySelectedMovie_title = titleText.text
                          movieTransactionPopup.open()
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
        id: movieTransactionPopup
        modal: true
        focus: true
        x: Math.round((mainAppWindow.width / 2) - (width / 2))
        y: Math.round((mainAppWindow.height / 2) - (height / 2))

        closePolicy: "NoAutoClose"

        ColumnLayout {
            spacing: 10

            RowLayout {
                id: movieDataLayout
                spacing: 20
                height: thumbImage.height + 20

                Image {
                    id: thumbImage
                    source: currentlySelectedMovie_thumb
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
                        text: currentlySelectedMovie_title
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
                    model: parentModelMovies.copyMediaModel
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

                        ppu = moviePrice + copyMediumCost
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

                        ppu = moviePrice + copyMediumCost
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
                        movieTransactionPopup.close()
                    }
                }

                Button {
                    text: "add to cart"
                    onClicked: {
                        var transactionItemsArray = [
                                "Movie",
                                currentlySelectedMovie_title,
                                numberOfCopiesSelector.value,
                                ppu,
                                totalCost,
                                transferOptionSelector.currentText]

                        shoppingCart.addNewItem(transactionItemsArray)

                        transferOptionSelector.currentIndex = 0
                        numberOfCopiesSelector.value = 1
                        movieTransactionPopup.close()
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
