import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

import "backend.js" as Backend

Item {
    id: searchCityPage
    property string city

    property alias cityFilter: cityFilter
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
                    id: cityFilter
                    placeholderText: qsTr("City")
                    text: city
                    inputMethodHints: Qt.ImhNoPredictiveText;
                    Layout.fillWidth: true
                    color: mainTextColor
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
                    var cityList = getOnlineCityList();
                    model.clear();
                    for( var i=0; i < cityList.length ; ++i ) {
                        model.append({city: cityList[i].nm_city_address});
                        console.debug("ListView city added "+cityList[i].nm_city_address)
                    }
                }

                function applyFilter(cityFilter) {
                    var cityList = findOnlineCity(cityFilter);
                    model.clear();
                    for( var i=0; i < cityList.length ; ++i ) {
                        model.append({city: cityList[i].nm_city_address});
                    }
                }
            }

            delegate: ItemDelegate {
                text:model.city
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.debug("Item clicked: "+model.city)
                        stackView.replace("qrc:/ContactList.qml", {"city": model.city})
                    }
                }
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
