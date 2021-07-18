import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Item {
    id: navigationMenuPage
    property alias menuButton: menuButton
    //    property alias mouseArea: mouseArea
    property alias navigationMenu: navigationMenu
    property alias showInfo: showInfo
    property alias search: search
    property alias logout: logout
    property alias about: about
    property alias quit: quit
    ToolButton {
        id: menuButton
        font.family: "fontawesome"
        //                    text: qsTr("\uf08b")
        //                    text: qsTr("\uf0c9")
        //                    text: qsTr("\uf141") // ellipsis horizontal
        text: qsTr("  \uf142  ") // ellipsis vertical
        Layout.fillHeight: false
        Layout.fillWidth: false
        font.pointSize: 14
        rightPadding: 10
        contentItem: Text {
            text: menuButton.text
            font: menuButton.font
            opacity: enabled ? 1.0 : 0.3
            //            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        Menu {
            id: navigationMenu
            title: qsTr("&File")
            MenuItem {
                id: showInfo
                text: qsTr("Virtual &card")
            }
            MenuItem {
                id: search
                text: qsTr("Medical &directory")
            }
            MenuItem {
                id: logout
                text: qsTr("L&ogout")
            }
            MenuItem {
                id: about
                text: qsTr("A&bout")
            }
            MenuItem {
                id: quit
                text: qsTr("E&xit")
            }
        }
    }


    /*    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        Menu {
            id: navigationMenu
            title: qsTr("&File")
            MenuItem {
                id: searchGuide
                text: qsTr("&Virtual &card")
            }
            MenuItem {
                id: logout
                text: qsTr("L&ogout")
            }
            MenuItem {
                id: about
                text: qsTr("A&bout")
            }
            MenuItem {
                id: quit
                text: qsTr("E&xit")
            }
        }
    }*/
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

