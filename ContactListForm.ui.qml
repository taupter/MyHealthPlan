import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Page {
    id: contactListPage

    property int currentContact: -1
    property string specialty
    property string provider
    property string city

    property alias contactListPage: contactListPage
    property alias menuItemCall: menuItemCall
    property alias menuItemSendMessage: menuItemSendMessage
    property alias menuItemWhatsApp: menuItemWhatsApp
    property alias backButton: backButton
    property alias contactMenu: contactMenu
    property alias contactName: contactName
    property alias contactView: contactView

    visible: true

    Material.primary: Material.Green

/*    ContactDialog {
        id: contactDialog
        onFinished: {
            if (currentContact === -1)
                contactView.model.append(fullName, address, city, number)
            else
                contactView.model.set(currentContact, fullName, address, city, number)
        }
    }*/

    Menu {
        id: contactMenu
        width: parent.width * 2 / 3
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        modal: true

        Label {
            id: contactName
            padding: 10
            font.bold: true
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
        }
/*        MenuItem {
            text: qsTr("Edit...")
            onTriggered: contactDialog.editContact(contactView.model.get(currentContact))
        }*/
/*        MenuItem {
            id: menuItemCall
            text: qsTr("Call")
        }
        MenuItem {
            id: menuItemSendMessage
            text: qsTr("Send message")
        }
        MenuItem {
            id: menuItemWhatsApp
            text: qsTr("Send message via WhatsApp")
        }*/
        MenuItem {
            id: menuItemCall
            text: qsTr("Ligar")
        }
        MenuItem {
            id: menuItemSendMessage
            text: qsTr("Enviar mensagem")
        }
        MenuItem {
            id: menuItemWhatsApp
            text: qsTr("Conversar pelo WhatsApp")
        }
    }





    ColumnLayout {
        width: parent.width
        height: parent.height
        spacing: 0

        ToolBar {
            Layout.fillWidth: true
            background:
                Rectangle {
                    color: "darkseagreen"
            }

            RowLayout {
                anchors.fill: parent
//                Item { Layout.fillWidth: true }
                ToolButton {
                    id: backButton
                    font.family: "fontawesome"
//                    text: qsTr("\uf08b")
//                    text: qsTr("\uf0c9")
//                    text: qsTr("\uf141") // ellipsis horizontal
                    text: qsTr("  \uf060  ") // ellipsis vertical
                    Layout.fillHeight: false
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font.pointSize: 14
                    rightPadding: 10
                    contentItem: Text {
                        text: backButton.text
                        font: backButton.font
                        opacity: enabled ? 1.0 : 0.3
                        color: mainTextColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                    }
                }
            }
        }

        ContactView {
            id: contactView
            specialty   : contactListPage.specialty
            provider    : contactListPage.provider
            city        : contactListPage.city
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
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
