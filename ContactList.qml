import QtQuick 2.12
import QtQml 2.3

ContactListForm {
    contactName.text: currentContact >= 0 ? contactView.model.get(currentContact).fullName : ""

//    specialty   : contactListPage.specialty
//    doctor      : contactListPage.doctor
//    city        : contactListPage.city

    menuItemCall.onTriggered: {
        console.debug("Calling number "+contactView.model.get(currentContact).contactNumber)
        Qt.openUrlExternally("tel:%1".arg("+55 "+contactView.model.get(currentContact).contactNumber))
    }
    menuItemSendMessage.onTriggered: {
        console.debug("Sending message to number "+contactView.model.get(currentContact).contactNumber)
        Qt.openUrlExternally("sms:%1".arg("+55 "+contactView.model.get(currentContact).contactNumber))
    }
    menuItemWhatsApp.onTriggered: {
        console.debug("Sending message to number "+contactView.model.get(currentContact).contactNumber)
        Qt.openUrlExternally("https://api.whatsapp.com/send?l=pt&phone=55%1".arg(contactView.model.get(currentContact).contactNumber))
    }
    backButton.onClicked: {
        searchGuide()
    }
    contactView.onPressAndHold: {
        currentContact = index
        contactMenu.open()
    }
}
