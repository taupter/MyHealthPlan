import QtQuick 2.4

NavigationMenuForm {
/*    mouseArea.onClicked: {
            navigationMenu.popup()
    }*/
    menuButton.onClicked: {
        navigationMenu.popup()
    }
    showInfo.onTriggered: {
        showUserInfo(m_user)
    }
    search.onTriggered: {
        searchGuide()
    }
    logout.onTriggered: {
        logoutSession()
    }
    about.onTriggered: {
        aboutPage()
    }
    quit.onTriggered: {
        Qt.quit()
    }
/*    Component.onCompleted: {
        reload();
    }*/
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
