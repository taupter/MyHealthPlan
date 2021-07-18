import QtQuick 2.4
import QtQuick.Controls 2.5

SearchSpecialtyForm {
    specialtyFilter.onTextChanged: {
//                        timer.restart();
        if(specialtyFilter.length > 0 ) {
            model.applyFilter(specialtyFilter.text);
        } else {
            model.reload();
        }
    }

    nextButton.onClicked: {
        if ((specialtyFilter.length > 0)&&(model.rowCount() > 0)) {
            stackView.replace("qrc:/ContactList.qml", {"specialty": specialtyFilter.text, "city": city})
        }
    }

    cityButton.onClicked: {
        stackView.replace("qrc:/SelectCity.qml")
    }
}
