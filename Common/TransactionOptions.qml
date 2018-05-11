import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Popup {

    property string thumbUrl: "file:/home/vpd/projects/qt/modioburn/assets/posters/movies/darktower_thumb.jpg"

    onOpened: componentLoader.sourceComponent = movieTransactionComponent

    Loader {
        id: componentLoader
    }

    Component {
        id: movieTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Movie"
                }
            }
        }
    }    

    Component {
        id: seriesTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Series"
                }
            }
        }
    }

    Component {
        id: episodeTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Episode"
                }
            }
        }
    }

    Component {
        id: musicSingleTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Music"
                }
            }
        }
    }

    Component {
        id: musicAlbumTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Music Album"
                }
            }
        }
    }

    Component {
        id: gameTransactionComponent

        ColumnLayout {
            id: parentLayout
            spacing: 20

            RowLayout {
                id: movieDataLayout
                spacing: 20

                Image {
                    id: movieThumb
                    source: thumbUrl
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: "Game"
                }
            }
        }
    }
}
