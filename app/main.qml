import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: root
    visible: true

    width: 640 * 2
    height: 480 * 1.5

    StackView {
        id: st
        anchors.fill: parent
        initialItem: loginPage
    }

    Component {
        id: loginPage

        LoginPage {
            onLogin: {
                st.replace(mainPage)
            }
        }
    }

    Component {
        id: mainPage

        MainPage { }
    }
}
