import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "backend.js" as Backend

Page {
    id: userInfoPage

    property string name: "Test name"
    property string card: "Test card number"
    property string owner: "Test owner"
    property string birthdatetext: qsTr("Birth date: ")
    property string birthdate: "Test birth date"
    property string identifier: "Test identifier"
    property string duedatetext: qsTr("Due date: ")
    property string duedate: "Test due date"

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
            width: parent.width / 2 - 20
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
            width: parent.width / 2 - 20
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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        CButton {
            height: 50
            //            Layout.preferredWidth: parent.width - 40
            Layout.alignment: Qt.AlignHCenter
            name: "VIRTUAL CARD - MY HEALTH PLAN"
            baseColor: mainAppColor
            borderColor: mainAppColor
        }
        Text {
            id: textCardNumber
            font.family: "creditcard"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pointSize: 24
            color: mainTextColor
            text: "Test card number"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    ColumnLayout {
        transformOrigin: Item.Center
        //        height: parent.height / 1.5
        width: parent.width / 2 - 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        Text {
            id: textName
            font.family: "creditcard"
            text: name
            font.pointSize: 16
            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: textOwner
            font.family: "creditcard"
            text: owner
            font.pointSize: 16
            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: textBirthday
            font.family: "creditcard"
            text: birthdatetext + birthdate
            font.pointSize: 16
            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    ColumnLayout {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        Text {
            id: textIdentifier
            font.family: "creditcard"
            text: identifier
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            font.pointSize: 16
            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Text {
            id: textDueDate
            font.family: "creditcard"
            text: duedatetext + duedate
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            font.pointSize: 16
            color: mainTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
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
    D{i:0;autoSize:true;height:480;width:640}D{i:15}
}
##^##*/

