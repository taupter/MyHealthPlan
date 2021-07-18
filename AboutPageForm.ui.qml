import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12

Item {
    id: element
    property alias backButton: backButton

    Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        z: 0
        anchors.fill: parent
        source: "virtualcard-background.png"
        antialiasing: true
    }
    ColumnLayout {
        id: row
        anchors.fill: parent
        Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter | Qt.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.right: parent.left
        anchors.rightMargin: 40
        Image {
            id: image
            antialiasing: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            transformOrigin: Item.Center
            fillMode: Image.PreserveAspectFit
            source: "MyHealthPlan-icon.svg"
        }
        Text {
            id: labelMyHealthPlan
            text: qsTr("My Health Plan")
            font.pixelSize: 36
            font.bold: true
            color: "steelblue"
            Layout.alignment: Qt.AlignCenter
        }
        Text {
            id: labelVersion
            text: qsTr("Version 0.1")
            font.pixelSize: 12
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter | Qt.AlignHCenter
        }
        Text {
            id: labelCopyright
            text: qsTr("© 2018, 2019, 2020, 2021 Taupter")
            font.pixelSize: 12
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter | Qt.AlignHCenter
        }
        Text {
            id: labelCopyright2
            text: qsTr("This app is distributed under the GNU Public License 2 or superior")
            font.pixelSize: 12
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter | Qt.AlignHCenter
        }
    }
    ToolBar {
        id: toolBar
        background: Rectangle {
            implicitHeight: 50
            implicitWidth: 200
            color: "transparent"
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                id: backButton
                font.family: "fontawesome"
                text: qsTr("\uf060")
                font.pointSize: 18
                rightPadding: 10
                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    opacity: enabled ? 1.0 : 0.3
                    color: mainTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

