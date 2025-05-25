import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtCore

import "backend.js" as Backend

Page {
    id: loginPage

    signal registerClicked()

    Settings {
        property bool   autologin: false
    }

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
            source: "who-horiz.svg"
        }
    }

    ColumnLayout {
        width: parent.width
        anchors.top: iconRect.bottom
        spacing: 15

        TextField {
            id: loginSSN
            placeholderText: qsTr("SSN")
            inputMask: "999.999.999-99"
            inputMethodHints: Qt.ImhDigitsOnly
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
            id: loginBirthDate
            placeholderText: qsTr("Birth date")
            inputMask: "99/99/9999"
            inputMethodHints: Qt.ImhDigitsOnly
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
            color: mainTextColor
            font.pointSize: 14
            font.family: "fontawesome"
            leftPadding: 30
//            echoMode: TextField.PasswordEchoOnEdit
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

        CheckBox {
            id: checkRememberMe
            text: qsTr("Remember me")
            checked: settings.autologin
            Layout.preferredWidth: parent.width - 20
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            height: 20
        }

        CButton{
            height: 50
            Layout.preferredWidth: loginPage.width - 20
            Layout.alignment: Qt.AlignHCenter
            name: "Login"
            baseColor: mainAppColor
            borderColor: mainAppColor
            onClicked: {
                loginUser(loginSSN.text, loginBirthDate.text, checkRememberMe.checked)
            }
        }

/*        Text {
            id: name
//            text: '<html><style type="text/css"></style><a href="http://google.com">Need help?</a></html>' //qsTr("Forgot password?")
            text: '<html><style type="text/css"></style><a href="http://authorize.myhealthplan.taupter.org/medical_directory_MyHealthPlan/">Medical directory</a></html>' //qsTr("Forgot password?")
            linkColor: mainTextColor
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: 14
            color: mainTextColor
            Layout.margins: 10
            onLinkActivated: Qt.openUrlExternally('http://authorize.myhealthplan.taupter.org/medical_directory_MyHealthPlan/')
//            onLinkActivated: forgotPassword()
        }*/
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
