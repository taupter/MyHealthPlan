import QtQuick 2.12
import QtQuick.Controls 2.12
import Backend 1.0

ListView {
    id: listView
    property string specialty
    property string provider
    property string city
//    property string specialty   : "Test name"
//    property string city        : "Test name"

    signal pressAndHold(int index)

    focus: true
    boundsBehavior: Flickable.StopAtBounds

    section.property: "fullName"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: SectionDelegate {
        width: listView.width
    }

    delegate: ContactDelegate {
        id: delegate
        width: listView.width

        Connections {
            target: delegate
            onPressAndHold: listView.pressAndHold(index)
        }
    }

    model: ContactModel {
        id: contactModel
        Component.onCompleted: {
            reload();
        }

        function reload() {
            var providerList = findContact(provider, specialty, city);
            contactModel.clear();
            for( var i=0; i < providerList.length ; ++i ) {
                contactModel.append(   providerList[i].nm_pessoa_razao_social,
                                providerList[i].nm_esp_prestador,
                                providerList[i].cd_tipo_logradouro,
                                providerList[i].nm_rua_endereco,
                                providerList[i].nu_endereco,
                                providerList[i].ds_compl_enderero,
                                providerList[i].nm_bairro_endereco,
                                providerList[i].cd_cep_endereco,
                                providerList[i].nm_cidade_endereco,
                                providerList[i].cd_uf_endereco,
                                providerList[i].nu_meio_comunicacao)
                console.debug("ListView city added "+providerList[i].nm_cidade_endereco)
            }
        }

    }

    ScrollBar.vertical: ScrollBar { }
}
