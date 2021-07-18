import QtQuick 2.4

SearchCityForm {
    cityFilter.onTextChanged: {
//                        timer.restart();
        if(cityFilter.length > 0 ) {
            model.applyFilter(cityFilter.text);
        } else {
            model.reload();
        }
    }

    nextButton.onClicked: {
        if((cityFilter.length > 0 )&&(model.rowCount() > 0)) {
            stackView.replace("qrc:/ContactList.qml", {"city": cityFilter.text})
        }
    }
}
