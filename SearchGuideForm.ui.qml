import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "backend.js" as Backend

Page {
    id: searchGuidePage
    property string city: "Shangri-la"
    property alias label: label

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        ToolBar {
            id: header
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            background: Rectangle {
                color: "royalblue"
            }

            RowLayout {
                id: rowLayout
                Layout.fillWidth: true

                Label {
                    id: label
                    color: "#2b2926"
                    text: "My Health Guide"
                    font.pointSize: 18
                    font.bold: true
                    padding: 10
                }


                /*                NavigationMenu {
                    id: navigationMenu2
                    Layout.alignment: Qt.AlignRight
                    width: 40
                    height: 40
                }*/
            }
        }

        StackLayout {
            id: stackLayout
            currentIndex: tabBar.currentIndex

            Item {
                SearchSpecialty {
                    id: searchSpecialty
                    anchors.fill: parent
                    city: searchGuidePage.city
                }
            }

            Item {
                SearchProvider {
                    id: searchProvider
                    anchors.fill: parent
                }
            }

            Item {
                SearchCity {
                    id: searchCity
                    anchors.fill: parent
                }
            }

            TextInput {
                id: textInput
                width: 80
                height: 20
                text: qsTr("Text Input")
                font.pixelSize: 12
            }
        }

        TabBar {
            id: tabBar
            currentIndex: 0
            Layout.fillWidth: true
            background: Rectangle {
                color: "#ffffff"
            }

            TabButton {
                id: specialtyButton
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: specialtyButton.down ? "#d0d0d0" : tabBar.currentIndex == 0 ? "royalblue" : "steelblue"
                }
                text: qsTr("&Specialty")
            }

            TabButton {
                id: doctorButton
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: doctorButton.down ? "#d0d0d0" : tabBar.currentIndex == 1 ? "royalblue" : "steelblue"
                }
                text: qsTr("P&rovider")
            }

            TabButton {
                id: cityButton
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    opacity: enabled ? 1 : 0.3
                    color: cityButton.down ? "#d0d0d0" : tabBar.currentIndex == 2 ? "royalblue" : "steelblue"
                }
                text: qsTr("C&ity")
            }
        }
    }
    NavigationMenu {
        id: navigationMenu
        width: 40
        height: 40
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        transformOrigin: Item.Right
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:11}D{i:1}
}
##^##*/

