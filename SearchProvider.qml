import QtQuick 2.4
import QtQuick.Controls 2.5

SearchProviderForm {
    providerFilter.onTextChanged: {
//                        timer.restart();
        if(providerFilter.length > 0 ) {
            model.applyFilter(providerFilter.text);
        } else {
            model.reload();
        }
    }

    nextButton.onClicked: {
//        if((providerFilter.length > 0 )&&(model.rowCount() > 0)) {
        if(model.rowCount() > 0) {
            stackView.replace("qrc:/ContactList.qml", {"provider": providerFilter.text})
        }
    }

/*    ListModel {
        id: model
        Component.onCompleted: {
            reload();
        }
    }
    function reload() {
        console.debug("--------- SEARCH RELOAD CALLED -----------")
        var cityList = getOnlineCityList();
        model.clear();
        for( var i=0; i < cityList.length ; ++i ) {
            model.append({city: cityList[i].nm_city_address});
            console.debug("ListView city added "+cityList[i].nm_city_address)
        }
    }*/

}
