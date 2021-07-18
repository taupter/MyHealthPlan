import QtQuick 2.4

SelectCityForm {
    backButton.onClicked: {
        showUserInfo(m_user)
    }

    cityFilter.onTextChanged: {
        if(cityFilter.length > 0 ) {
            model.applyFilter(cityFilter.text);
        } else {
            model.reload();
        }
    }

    nextButton.onClicked: {
        if(model.rowCount() > 0) {
            stackView.replace("qrc:/SearchGuide.qml", {"city": cityFilter.text})
        }
    }
}
