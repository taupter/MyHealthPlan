import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page {
    id: passswordPage

    background: Image {
        id: background
        fillMode: Image.PreserveAspectCrop
        z: 0
        anchors.fill: parent
        source: "virtualcard-background.png"
    }

    Rectangle {
        id: iconRect
        width: parent.width
        height: parent.height / 3
        color: "transparent"

        Image {
            id: logomhp
            height: parent.height / 1.5
            width: parent.width /2 - 20
            transformOrigin: Item.Center
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            source: "MyHealthPlan-horiz.svg"
        }

        Image {
            id: logowho
            height: parent.height / 1.5
            width: parent.width /2 - 20
            transformOrigin: Item.Center
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignRight
            verticalAlignment: Image.AlignTop
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            source: "who-horiz.png"
        }
    }

    footer: ToolBar {
        background:
            Rectangle {
//            implicitHeight: 50
//            implicitWidth: 200
            color: "transparent"
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                id: control
                font.family: "fontawesome"
                text: qsTr("\uf060")
                font.pointSize: 24
                rightPadding: 10
                contentItem: Text {
                    text: control.text
                    font: control.font
                    opacity: enabled ? 1.0 : 0.3
                    color: mainTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                onClicked: logoutSession()
            }
            Item { Layout.fillWidth: true }
        }
    }

    Text {
        id: resetText
//        text: qsTr("Retrieve Password")
        text: qsTr("Recuperar senha")
        font.pointSize: 24
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        color: mainTextColor
    }

    ColumnLayout {
        width: parent.width
        anchors.top: resetText.bottom
        anchors.topMargin: 30
        spacing: 20

        TextField {
            id: registeredUsername
//            placeholderText: qsTr("User name")
            placeholderText: qsTr("CPF")
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            color: mainTextColor
            font.pointSize: 14
            font.family: "fontawesome"
            leftPadding: 30
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 50
                radius: implicitHeight / 2
                color: "transparent"

                Text {
                    text: "\uf007"
                    font.pointSize: 14
                    font.family: "fontawesome"
                    color: mainAppColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 10
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: mainAppColor
                }
            }
        }

        TextField {
            id: registeredHint
//            placeholderText: qsTr("Password Hint")
            placeholderText: qsTr("Email")
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            color: mainTextColor
            font.pointSize: 14
            font.family: "fontawesome"
            leftPadding: 30
            echoMode: TextField.PasswordEchoOnEdit
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 50
                radius: implicitHeight / 2
                color: "transparent"
                Text {
                    text: "\uf023"
                    font.pointSize: 14
                    font.family: "fontawesome"
                    color: mainAppColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: 10
                }

                Rectangle {
                    width: parent.width - 10
                    height: 1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    color: mainAppColor
                }
            }
        }

        Item {
            height: 20
        }

        CButton{
            height: 50
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
//            name: "Retrieve"
            name: "Recuperar"
            baseColor: mainAppColor
            borderColor: mainAppColor
            onClicked: initiateRetrieval()
        }

        Item {
            height: 40
        }

        Text {
            id: helpText
//            text: qsTr("Your Password is,")
            text: qsTr("Sua data de nascimento é,")
            font.pointSize: 16
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignLeft
            leftPadding: 15
            color: mainTextColor
            visible: false
        }

        Text {
            id: password
            font.pointSize: 13
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignLeft
            leftPadding: 15
            color: mainTextColor
            visible: false
        }

        Item {
            height: 20
        }
    }

    function initiateRetrieval()
    {
        var ret = retrievePassword(registeredUsername.text, registeredHint.text)
        if(ret !== "")
        {
            helpText.visible = true
            password.visible = true
            password.text = ret
        }
    }
}
