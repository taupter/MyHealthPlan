import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.0
import Qt.labs.settings 1.0

import "backend.js" as Backend

ApplicationWindow {
    id: rootWindow
    visible: true
    width: 420
    height: 680
    title: qsTr("My Health Plan Virtual Card")

    property color backGroundColor : "#394454"
    property color mainAppColor: "#394454"
    property color mainAppColor2: "#346f5a"
    property color mainTextColor: "#000000"
    property color popupBackGroundColor: "#b44"
    property color popupTextColor: "#ffffff"
    property var dataBase
    property var token
    property var m_user
    property var m_dependents
//    property var citylist
//    property var specialtylist
    property bool testResult: false

    Settings {
        id: settings
        property alias x: rootWindow.x
        property alias y: rootWindow.y
        property alias width: rootWindow.width
        property alias height: rootWindow.height

        property string ssn: ""
        property string birthdate: ""
        property bool   autologin: false
    }

    FontLoader {
        id: fontAwesome
        name: "fontawesome"
        source: "qrc:/fontawesome-webfont.ttf"
    }

/*    FontLoader {
        id: fontCreditCard
        name: "creditcard"
        source: "qrc:/creditcard.ttf"
    }*/

    // Main stackview
    StackView {
        id: stackView
        focus: true
        anchors.fill: parent
    }

    // After loading show initial Login Page
    Component.onCompleted: {
        dataBase = userDataBase()
        console.log(dataBase.version)
        if (settings.autologin) {
            console.debug("Autologin is set.")
            if (true === loginUser(settings.ssn, settings.birthdate, settings.autologin)) {
                console.debug("Autologin done.")
                return
            }
        }
        stackView.push("qrc:/LogInPage.qml")   //initial page
    }

    //Popup to show messages or warnings on the bottom postion of the screen
    Popup {
        id: popup
        property alias popMessage: message.text

        background: Rectangle {
            implicitWidth: rootWindow.width
            implicitHeight: 60
            color: popupBackGroundColor
        }
        y: (rootWindow.height - 60)
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutside
        Text {
            id: message
            anchors.centerIn: parent
            font.pointSize: 12
            color: popupTextColor
        }
        onOpened: popupClose.start()
    }

    // Popup will be closed automatically in 2 seconds after its opened
    Timer {
        id: popupClose
        interval: 2000
        onTriggered: popup.close()
    }

    function showPopup(message)
    {
        popup.popMessage = message
        popup.open()
    }

    // Create and initialize the database
    function userDataBase()
    {
        var db = LocalStorage.openDatabaseSync("MyHealthPlan", "1.0", "Login example!", 1000000);
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS UserDetails(code TEXT, owner TEXT, name TEXT, birthdate TEXT, ssn TEXT, cardnumber TEXT, datestart TEXT, dateend TEXT, ordernumber TEXT, identifier TEXT, lastlogin TEXT, duedate TEXT)');
        })
        return db;
    }

    // Register New user
    function registerNewUser(user)
    {
        console.debug("registerNewUser("+user.name+")")
        var ret  = Backend.validateRegisterCredentials(user)
        switch(ret)
        {
            case 0: showPopup("Detalhes válidos!");                   break;
            case 1: showPopup("CPF/data de nascimento incompletos!"); return
            case 2: showPopup("Senha não confere!");                  return
        }

        dataBase.transaction(function(tx) {
            var results = tx.executeSql('SELECT birthdate FROM UserDetails WHERE ssn=?;', user.ssn);
            console.log(results.rows.length)
            if(results.rows.length !== 0)
            {
                showPopup("Usuário existente("+results.rows.length+")")
                return
            }
/*            console.debug("Registering new user:")
            console.debug(user.code)
            console.debug(user.owner)
            console.debug(user.name)
            console.debug(user.birthdate)
            console.debug(user.ssn)
            console.debug(user.cardnumber)
            console.debug(user.datestart)
            console.debug(user.dateend)
            console.debug(user.ordernumber)
            console.debug(user.identifier)
            console.debug(user.lastlogin)
            console.debug(user.duedate)*/
            tx.executeSql('INSERT INTO UserDetails VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [ user.code, user.owner, user.name, user.birthdate, user.ssn, user.cardnumber, user.datestart, user.dateend, user.ordernumber, user.identifier, user.lastlogin, user.duedate ]);
// extra debug
/*            results = tx.executeSql('SELECT * FROM UserDetails;');
            console.debug("User registered as:")
            console.debug(results.rows.item(0).code)
            console.debug(results.rows.item(0).owner)
            console.debug(results.rows.item(0).name)
            console.debug(results.rows.item(0).birthdate)
            console.debug(results.rows.item(0).ssn)
            console.debug(results.rows.item(0).cardnumber)
            console.debug(results.rows.item(0).datestart)
            console.debug(results.rows.item(0).dateend)
            console.debug(results.rows.item(0).ordernumber)
            console.debug(results.rows.item(0).identifier)
            console.debug(results.rows.item(0).lastlogin)
            console.debug(results.rows.item(0).duedate)*/
        })
    }

    function updateUser(user)
    {
        dataBase.transaction(function(tx) {
            console.debug("updateUser("+user.name+")")
            var results = tx.executeSql('SELECT * FROM UserDetails WHERE ssn=?;', user.ssn);

            var date = new Date
            user.lastlogin = date.toISOString()
            // Current way to calculate due date. The canonical way would be to read from dateend,
            //  but due to constraints it is calculated as the last day of the month of the last online login.
            var duedate = new Date(date.getUTCFullYear(),date.getUTCMonth()+1,0)
            user.duedate = duedate.toISOString()

            if(results.rows.length === 0)
            {
                console.debug("New entry. Adding...")
                registerNewUser(user);
                return
            }
            console.debug("Entry already exists("+results.rows.length+"). Contents:")
            console.debug(results.rows.item(0).code)
            console.debug(results.rows.item(0).owner)
            console.debug(results.rows.item(0).name)
            console.debug(results.rows.item(0).birthdate)
            console.debug(results.rows.item(0).ssn)
            console.debug(results.rows.item(0).cardnumber)
            console.debug(results.rows.item(0).datestart)
            console.debug(results.rows.item(0).dateend)
            console.debug(results.rows.item(0).ordernumber)
            console.debug(results.rows.item(0).identifier)
            console.debug(results.rows.item(0).lastlogin)
            console.debug(results.rows.item(0).duedate)
            console.debug("Updating to:")
            console.debug(user.code)
            console.debug(user.owner)
            console.debug(user.name)
            console.debug(user.birthdate)
            console.debug(user.ssn)
            console.debug(user.cardnumber)
            console.debug(user.datestart)
            console.debug(user.dateend)
            console.debug(user.ordernumber)
            console.debug(user.identifier)
            console.debug(user.lastlogin)
            console.debug(user.duedate)
            tx.executeSql('UPDATE UserDetails SET code = ?, owner = ?, name = ?, birthdate = ?, cardnumber = ?, datestart = ?, dateend = ?, ordernumber = ?, identifier = ?, lastlogin = ?, duedate = ? WHERE ssn = ?', [ user.code, user.owner, user.name, user.birthdate, user.cardnumber, user.datestart, user.dateend, user.ordernumber, user.identifier, user.lastlogin, user.duedate, user.ssn ]);
        })
    }

    function getOnlineToken(ssn, birthdate, async)
    {
        console.debug("getOnlineToken("+ssn+","+birthdate+")")
        var ret = {}
        var http = new XMLHttpRequest()
        var url = "http://taupter.org:3001/node/token";
        var params = "cpf="+ssn+"&app=sis&dataNasc="+birthdate;
        http.open("POST", url, async); // true: asynchronous, false: synchronous
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            console.debug("getOnlineToken connection status changed")
            if (http.readyState == 4) {
                ret.httpstatus = http.status
                if (http.status == 200) {
                    console.log("ok")
                    ret = JSON.parse(http.responseText);
                    ret.httpstatus = http.status
                    if (async === true) {
                        token =ret
                    }
                } else {
                     console.log("error: " + http.status)
                 }
             }
         }
        http.send(params);
        console.log(ret.status)

        return ret
    }

    function getOnlineCredentials(token)
    {
        console.debug("getOnlineCredentials started")
        var ret = {}
        var http = new XMLHttpRequest()
//        var url = "http://localhost:3002/node/finduser";
        var url = "http://taupter.org:3002/node/finduser";
        var params = "Bearer "+token.token;
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(ret)
        return ret
    }

    function getOnlineDependents(owner)
    {
        console.debug("getOnlineDependents started")
        var ret = {}
        var http = new XMLHttpRequest()
        var url = "http://taupter.org:3002/node/finddependents?owner="+owner;
        var params = "Bearer "+token.token;
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(ret)
        return ret
    }

    function loginUserOffline(ssn, birthdate, autologin)
    {
        console.debug("loginUserOffline("+ssn+","+birthdate+","+autologin+")")
        var resultvalue = true
        dataBase.transaction(function(tx) {
            var results = tx.executeSql('SELECT * FROM UserDetails WHERE ssn=?;', ssn.toString());
/*            if(results.rows.length === 0) {
                showPopup("Usuário não registrado!")
                resultvalue = false
                return
            }
            if(results.rows.item(0).birthdate !== birthdate) {
                showPopup("CPF/data de nascimento inválidos!")
                resultvalue = false
                return
            }
            var date = new Date
            var duedate = new Date(results.rows.item(0).duedate)
            if (date > duedate) {
                showPopup("Acesso online necessário!")
                resultvalue = false
                return
            }
*/

            var user = {}
/*            user.owner       = results.rows.item(0).owner
            user.name        = results.rows.item(0).name
            user.birthdate   = results.rows.item(0).birthdate
            user.ssn         = results.rows.item(0).ssn
            user.cardnumber  = results.rows.item(0).cardnumber
            user.datestart   = results.rows.item(0).datestart
            user.dateend     = results.rows.item(0).dateend
            user.ordernumber = results.rows.item(0).ordernumber
            user.identifier  = results.rows.item(0).identifier
            user.lastlogin   = results.rows.item(0).lastlogin
            user.duedate     = results.rows.item(0).duedate
            user.autologin   = autologin // Needed to be parsed but not stored in SQLite
*/
            user.owner       = ""
            user.name        = "Test user"
            user.birthdate   = "01/01/1970"
            user.ssn         = "1234567890"
            user.cardnumber  = "10000001"
            user.datestart   = "01/01/1970"
            user.dateend     = "01/01/3000"
            user.ordernumber = "01"
            user.identifier  = ""
            user.lastlogin   = ""
            user.duedate     = "3000/01/01"
            user.autologin   = autologin // Needed to be parsed but not stored in SQLite

            m_user = user

//             console.debug(user.code)
            console.debug(user.owner)
            console.debug(user.name)
            console.debug(user.birthdate)
            console.debug(user.ssn)
            console.debug(user.cardnumber)
            console.debug(user.datestart)
            console.debug(user.dateend)
            console.debug(user.ordernumber)
            console.debug(user.identifier)
            console.debug(user.lastlogin)
            console.debug(user.duedate)

            showUserInfo(m_user)
            resultvalue = true
        })
        console.debug("===== AGORA SAIU ======")
        return resultvalue
    }

    function loginUserOnline(ssn, birthdate, autologin)
    {
        console.debug("loginUserOnline("+ssn+","+birthdate+","+autologin+")")
        var ret  = Backend.validateUserCredentials(ssn, birthdate)
        if(ret) {
            showPopup("CPF/data de nascimento incompletos!")
            return false
        }

        token = getOnlineToken(ssn,birthdate, false)
        console.log("getOnlineToken result: "+token.httpstatus)
        if(token.httpstatus!==200)
        {
            switch(token.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Erro "+token.httpstatus+"!")
            return false
        }

        m_user = getOnlineCredentials(token)
        if(m_user.httpstatus!==201)
        {
            switch(user.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Sem conexão!")
            m_user = ""
            return false
        }
        console.log("Code : "+m_user.codigo)
        console.log("Owner: "+m_user.titular)
        console.log("Name : "+m_user.nome)
        console.log("birth: "+birthdate)
        console.log("SSN  : "+m_user.cpf)
        console.log("Card : "+m_user.num_cartao)
        console.log("DateS: "+m_user.emissao)
        console.log("DateE: "+m_user.validade)
        console.log("OrNum: "+m_user.nu_ordem_usuario)
        console.log("IDent: "+m_user.cd_usuario)

        m_user.code        = m_user.codigo  // Código de usuário
        m_user.owner       = m_user.titular // Código de titular
        m_user.name        = m_user.nome
        m_user.birthdate   = birthdate
        m_user.ssn         = m_user.cpf
        m_user.cardnumber  = m_user.num_cartao
        m_user.datestart   = m_user.emissao
        m_user.dateend     = m_user.validade
        m_user.ordernumber = m_user.nu_ordem_usuario
        m_user.identifier  = m_user.cd_usuario

        m_user.autologin   = autologin // Needed to be parsed but not stored in SQLite

        updateUser(m_user)

        m_dependents = getOnlineDependents(m_user.owner)
        if(m_dependents.httpstatus!==201)
        {
            switch(m_dependents.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("404 - inválido!"); return false
            }
            showPopup("Sem conexão!")
            m_dependents = ""
            return false
        }
        console.debug("Number of dependents: "+m_dependents.length)

        if(userlist.length > 0) {
            for (var i = 0; i < userlist.length; i++) {
                console.debug("Adding item "+i)
                m_dependents[i].code        = m_dependents[i].codigo  // Código de usuário
                m_dependents[i].owner       = m_dependents[i].titular // Código de titular
                m_dependents[i].name        = m_dependents[i].nome
                m_dependents[i].birthdate   = m_dependents[i].nascimento.substr(8,2)+"/"+userlist[i].nascimento.substr(5,2)+"/"+userlist[i].nascimento.substr(0,4)
                m_dependents[i].ssn         = m_dependents[i].cpf
                m_dependents[i].cardnumber  = m_dependents[i].num_cartao
                m_dependents[i].datestart   = m_dependents[i].emissao
                m_dependents[i].dateend     = m_dependents[i].validade
                m_dependents[i].ordernumber = m_dependents[i].nu_ordem_usuario
                m_dependents[i].identifier  = m_dependents[i].cd_usuario
                console.debug(m_dependents[i].owner)
                console.debug(m_dependents[i].name)
                console.debug(m_dependents[i].nascimento)
                console.debug(m_dependents[i].birthdate)
                console.debug(m_dependents[i].ssn)
                console.debug(m_dependents[i].cardnumber)
                console.debug(m_dependents[i].datestart)
                console.debug(m_dependents[i].dateend)
                console.debug(m_dependents[i].ordernumber)
                console.debug(m_dependents[i].identifier)
                console.debug(m_dependents[i].lastlogin)
                console.debug(m_dependents[i].duedate)

                updateUser(m_dependents[i])
            }
        }
        showUserInfo(m_user) // goto user info page
        return true
    }

    function findDependentsOnline(ssn, birthdate, autologin)
    {
//        m_user = ""
        console.debug("findDependentsOnline("+ssn+","+birthdate+","+autologin+")")
        token = getOnlineToken(ssn,birthdate, false)
        console.log("getOnlineToken result: "+token.httpstatus)
        if(token.httpstatus!==200)
        {
            switch(token.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Erro "+token.httpstatus+"!")
            return false
        }

        var user = getOnlineCredentials(token)
        if(user.httpstatus!==201)
        {
            switch(user.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Sem conexão!")
            return false
        }
        console.log("Code : "+user.codigo)
        console.log("Owner: "+user.titular)
        console.log("Name : "+user.nome)
        console.log("birth: "+birthdate)
        console.log("SSN  : "+user.cpf)
        console.log("Card : "+user.num_cartao)
        console.log("DateS: "+user.emissao)
        console.log("DateE: "+user.validade)
        console.log("OrNum: "+user.nu_ordem_usuario)
        console.log("IDent: "+user.cd_usuario)

        user.code        = user.codigo  // Código de usuário
        user.owner       = user.titular // Código de titular
        user.name        = user.nome
        user.birthdate   = birthdate
        user.ssn         = user.cpf
        user.cardnumber  = user.num_cartao
        user.datestart   = user.emissao
        user.dateend     = user.validade
        user.ordernumber = user.nu_ordem_usuario
        user.identifier  = user.cd_usuario

        user.autologin   = autologin // Needed to be parsed but not stored in SQLite

        m_user = user

        updateUser(m_user)
        showUserInfo(m_user) // goto user info page
        return true
    }

    function loginUser(ssn, birthdate, autologin)
    {
        m_user = ""
        m_dependents = ""
        console.debug("loginUser("+ssn+","+birthdate+","+autologin+")")
        ssn = Number(ssn.replace(/[\.-]/g, ""))
        console.log("CPF final: "+ssn)
        var ret  = Backend.validateUserCredentials(ssn, birthdate)
        if(ret) {
            showPopup("CPF/data de nascimento incompletos!")
            return
        }
// In a normal environment the online information should take precedence.
// My Health Plan's card validity is pre-paid, so it should check online only if the offline fails.
// Offline login must be done as swift as possible to avoid an unwanted wait.
        if ( (loginUserOffline(ssn, birthdate, autologin)) === true) {
            console.debug("loginUser: loginUserOffline exited successfully")
            getOnlineToken(ssn,birthdate, true)
            return true
        }
        if ( (loginUserOnline(ssn, birthdate, autologin)) === true) {
            console.debug("loginUser: loginUserOnline exited successfully")
            return true
        }
        console.debug("loginUser exited")
        return false
    }

    function loginUserOLD(ssn, birthdate, autologin)
    {
        m_user = ""
        console.debug("loginUser("+ssn+","+birthdate+","+autologin+")")
        ssn = Number(ssn.replace(/[\.-]/g, ""))
        console.log("CPF final: "+ssn)
        var ret  = Backend.validateUserCredentials(ssn, birthdate)
        if(ret)
        {
            showPopup("CPF/data de nascimento incompletos!")
            return
        }
// In a normal environment the online information should take precedence.
        token = getOnlineToken(ssn,birthdate, false)
        console.log("getOnlineToken result: "+token.httpstatus)
        if(token.httpstatus!==200)
        {
            switch(token.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Erro "+token.httpstatus+"!")
            return loginUserOffline(ssn, birthdate, autologin)
        }

        var user = getOnlineCredentials(token)
        if(user.httpstatus!==201)
        {
            switch(user.httpstatus) {
                case 401: showPopup("Usuário não autorizado!");           return false
                case 404: showPopup("CPF/data de nascimento inválidos!"); return false
            }
            showPopup("Sem conexão!")
            return loginUserOffline(ssn, birthdate, autologin)
        }
        console.log("Code : "+user.codigo)
        console.log("Owner: "+user.titular)
        console.log("Name : "+user.nome)
        console.log("birth: "+birthdate)
        console.log("SSN  : "+user.cpf)
        console.log("Card : "+user.num_cartao)
        console.log("DateS: "+user.emissao)
        console.log("DateE: "+user.validade)
        console.log("OrNum: "+user.nu_ordem_usuario)
        console.log("IDent: "+user.cd_usuario)

        user.code        = user.codigo
        user.owner       = user.titular
        user.name        = user.nome
        user.birthdate   = birthdate
        user.ssn         = user.cpf
        user.cardnumber  = user.num_cartao
        user.datestart   = user.emissao
        user.dateend     = user.validade
        user.ordernumber = user.nu_ordem_usuario
        user.identifier  = user.cd_usuario

        user.autologin   = autologin // Needed to be parsed but not stored in SQLite

        m_user = user

        updateUser(user)
        showUserInfo(user) // goto user info page
        return true
    }

    // Retrieve password using password hint - unused method for now
    function retrievePassword(uname, phint)
    {
        var ret  = Backend.validateUserCredentials(uname, phint)
        var message = ""
        var pword = ""
        if(ret)
        {
//            message = "Missing credentials!"
            message = "CPF/data de nascimento inválidos!"
            popup.popMessage = message
            popup.open()
            return ""
        }

        console.log(uname, phint)
        dataBase.transaction(function(tx) {
            var results = tx.executeSql('SELECT password FROM UserDetails WHERE username=? AND hint=?;', [uname, phint]);
            if(results.rows.length === 0)
            {
//                message = "User not found!"
                message = "Usuário não encontrado!"
                popup.popMessage = message
                popup.open()
            }
            else
            {
                pword = results.rows.item(0).password
            }
        })
        return pword
    }

    // Medical Guide

    function getOnlineCityList()
    {
        var ret = {}
        var http = new XMLHttpRequest()
    //        var url = "http://localhost:3002/node/carteira";
        var url = "http://taupter.org:3003/node/listcity";
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        console.log(ret[0].nm_city_address)
        return ret
    }

    function findOnlineCity(city)
    {
        var ret = {}
        var http = new XMLHttpRequest()
    //        var url = "http://localhost:3002/node/carteira";
//        var url = "http://taupter.org:3003/node/findcity";
        var url = "http://taupter.org:3003/node/findcity?city="+city;
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        return ret
    }

    function getOnlineSpecialtyList()
    {
        var ret = {}
        var http = new XMLHttpRequest()
        var url = "http://taupter.org:3003/node/listspecialty";
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        console.log(ret[0].nm_esp_prestador)
        return ret
    }

    function findOnlineSpecialty(specialty)
    {
        var ret = {}
        var http = new XMLHttpRequest()
    //        var url = "http://localhost:3002/node/carteira";
//        var url = "http://taupter.org:3003/node/findcity";
        var url = "http://taupter.org:3003/node/findspecialty?specialty="+specialty;
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        return ret
    }

    function getOnlineProviderList()
    {
        var ret = {}
        var http = new XMLHttpRequest()
    //        var url = "http://localhost:3002/node/carteira";
        var url = "http://taupter.org:3003/node/listprovider";
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        console.log(ret[0].nm_pessoa_razao_social)
        return ret
    }

    function findOnlineProvider(provider)
    {
        var ret = {}
        var http = new XMLHttpRequest()
    //        var url = "http://localhost:3002/node/carteira";
//        var url = "http://taupter.org:3003/node/findcity";
        var url = "http://taupter.org:3003/node/findprovider?provider="+provider;
        var params = "Bearer "+token.token;
        console.log("Vixe")
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        return ret
    }

    function findContact(provider, specialty, city)
    {
        console.debug("--------- findContact CALLED -----------")
        console.debug("Provider : " + provider)
        console.debug("Specialty: " + specialty)
        console.debug("City     : " + city)
        var ret = {}
        var http = new XMLHttpRequest()
//        var url = "http://taupter.org:3003/node/findcontact?specialty="+specialty+"&city="+city;
        var url = "http://taupter.org:3003/node/findcontact?provider="+provider+"&specialty="+specialty+"&city="+city;
        var params = "Bearer "+token.token;
        console.log(url)
        console.log(params)
        http.open("GET", url, false); // true: asynchronous, false: synchronous

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        http.setRequestHeader("Authorization", params);
        http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
                    if (http.readyState == 4) {
                        ret.httpstatus = http.status
                        if (http.status == 201) {
                            console.log("ok")
                            ret = JSON.parse(http.responseText);
                            ret.httpstatus = http.status
                        } else {
                            console.log("error: " + http.status)
                        }
                    }
                }
        http.send(params);
/*        console.log(http.responseText)
        console.log(ret)
        console.log(ret.length)
        console.log(ret[0].nm_pessoa_razao_social)
        console.log(ret[0].nm_esp_prestador)
// There's a typo in the DB view that returns data as ds_compl_enderero instead of ds_compl_endereco
        console.log(ret[0].cd_tipo_logradouro+" "+ret[0].nm_rua_endereco+" "+ret[0].nu_endereco+" "+ret[0].ds_compl_enderero)
        console.log(ret[0].nm_bairro_endereco)
        console.log(ret[0].cd_cep_endereco)
        console.log(ret[0].nm_city_address+" "+ret[0].cd_uf_endereco)
        console.log(ret[0].nu_meio_comunicacao)*/
        return ret
    }

    // Show UserInfo page
    function showUserInfo(user)
    {
        var owner = qsTr("Holder")
        if(user.code !== user.owner)
        {
            owner = qsTr("Dependent")
        }
        var duedate = user.duedate.substr(8,2)+"/"+user.duedate.substr(5,2)+"/"+user.duedate.substr(0,4)

        stackView.replace("qrc:/UserInfoPage.qml", {"name": user.name, "card": user.cardnumber, "owner": owner, "birthdate": user.birthdate, "identifier": user.identifier, "duedate": duedate})
        settings.ssn       = user.ssn
        settings.birthdate = user.birthdate
        settings.autologin = user.autologin
    }

    // Open medical guide
    function searchGuide()
    {   var ret, i
//        stackView.replace("qrc:/SearchSpecialty.qml", {"city": "Shangri-la"})
        stackView.replace("qrc:/SearchGuide.qml", {"city": "Shangri-la"})
    }

    function searchProvider() // Seachs a provider by name
    {   var ret, i
        stackView.replace("qrc:/SearchProvider.qml")
    }

    function searchCity() // Looks for all providers in a city
    {   var ret, i
//        stackView.replace("qrc:/SearchCity.qml")
        stackView.replace("qrc:/SearchCity.qml", {"city": "Shangri-la"})
    }

    // Logout and show login page
    function logoutSession()
    {
        stackView.replace("qrc:/LogInPage.qml")
        settings.autologin = false
    }

    // About page
    function aboutPage()
    {
        stackView.replace("qrc:/AboutPage.qml")
    }

    // Show all users
    function showAllUsers()
    {
        dataBase.transaction(function(tx) {
            var rs = tx.executeSql('SELECT * FROM UserDetails');
            var data = ""
            for(var i = 0; i < rs.rows.length; i++) {
                data += rs.rows.item(i).username + "\n"
            }
            console.log(data)
        })

    }
}
