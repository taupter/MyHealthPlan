import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "backend.js" as Backend

Page {
    id: searchProviderPage
    property string provider

    property alias providerFilter: providerFilter
    property alias nextButton: nextButton

    property alias model: model

    ColumnLayout {
        spacing: 0
        anchors.fill: parent

        ToolBar {
            Layout.fillWidth: true
            background:
                Rectangle {
                color: "cornflowerblue"
            }

            RowLayout {
                anchors.fill: parent

                TextField {
                    id: providerFilter
//                    height: 40
                    placeholderText: qsTr("Provider")
                    text: provider
                    inputMethodHints: Qt.ImhNoPredictiveText;
                    Layout.fillWidth: true
                    color: mainTextColor
                    transformOrigin: Item.Center
                    //                    font.pointSize:30
                    font.family: "fontawesome"
                    font.underline: false
                    leftPadding: 30
                    background: Rectangle {
                        implicitWidth: 200
                        implicitHeight: 50
                        radius: implicitHeight / 2
                        color: "transparent"
                    }
                }

                ToolButton {
                    id: nextButton
                    font.family: "fontawesome"
//                    text: qsTr("\uf08b")
//                    text: qsTr("\uf0c9")
//                    text: qsTr("\uf141") // ellipsis horizontal
                    text: qsTr("  \uf061  ") // ellipsis vertical
                    Layout.fillHeight: false
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    font.pointSize: 14
                    rightPadding: 10
                    contentItem: Text {
                        text: nextButton.text
                        font: nextButton.font
                        opacity: enabled ? 1.0 : 0.3
                        color: mainTextColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideLeft
                    }
                }
            }
        }

        ListView {
            id:listView
            clip: true
            width: parent.width
            height: parent.height
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: ListModel {
                id: model
                Component.onCompleted: {
                    reload();
                }

                function reload() {
                    console.debug("--------- SEARCH RELOAD CALLED -----------")
                    var providerList = getOnlineProviderList();
                    model.clear();
                    for( var i=0; i < providerList.length ; ++i ) {
                        model.append({provider: providerList[i].nm_pessoa_razao_social});
                        console.debug("ListView city added "+providerList[i].nm_pessoa_razao_social)
                    }
                }

                function applyFilter(providerFilter) {
                    var providerList = findOnlineProvider(providerFilter);
                    model.clear();
                    for( var i=0; i < providerList.length ; ++i ) {
                        model.append({provider: providerList[i].nm_pessoa_razao_social});
                    }
                }
            }

            delegate: ItemDelegate {
                text:model.provider
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.debug("Item clicked: "+model.provider)
                        stackView.replace("qrc:/ContactList.qml", {"provider": model.provider})
                    }
                }
            }
        }
    }
}







/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:480;anchors_width:640}
}
 ##^##*/
