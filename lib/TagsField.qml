import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Rectangle {
    border.color: 'lightgray'
    border.width: transparent ? 0 : 1

    property var tags: []
    property ListModel tagsModel: ListModel {}
    property bool readOnly: false
    property alias contentHeight: scrollView.contentHeight
    property bool scrollable: true
    property bool transparent: false

    onTagsChanged: {
        tagsModel.clear()
        if (!tags) {
            return
        }

        for (const tag of tags) {
            tagsModel.append({tagText: tag })
        }
    }

    function appendTag(tag) {
        for (let i = 0; i < tagsModel.count; i++) {
            let item = tagsModel.get(i)
            if (tag === item.tagText) {
                return
            }
        }
         tagsModel.append({tagText: tag })
    }

    function removeTag(tagIndex) {
        tagsModel.remove(tagIndex)
    }

    function getTags() {
        let tags = []
        for (let i = 0; i < tagsModel.count; i++) {
            let item = tagsModel.get(i)
            tags.push(item.tagText)
        }
        return tags
    }

    Timer {
        id: hintTimer
        interval: 250
        running: false
        repeat: false
        onTriggered: {
            hintLabel.visible = true
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 1
        spacing: 0

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: transparent ? 'transparent' : 'whitesmoke'

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 5

                clip: true
                ScrollBar.vertical.interactive: false
                enabled: scrollable

                Flow {
                    id: flow
                    spacing: 5
                    anchors.margins: 5
                    width: scrollView.width
                    clip: true

                    Repeater {
                        model: tagsModel
                        Rectangle {
                            color: 'gold'
                            width: labelFlow.width + 10
                            height: labelFlow.height + 10
                            radius: 10

                            Flow {
                                id: labelFlow
                                anchors.centerIn: parent
                                spacing: 5

                                TextMetrics {
                                    id: textMetrics
                                    elide: Text.ElideRight
                                    elideWidth: 150
                                    text: tagText
                                }

                                Text {
                                    id: labelText
                                    text: textMetrics.elidedText
                                    textFormat: Text.PlainText
                                }

                                Text {
                                    visible: !readOnly
                                    id: closeLabel
                                    text: 'x'
                                    font.pixelSize: labelText.font.pixelSize - 3
                                    rightPadding: 5

                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.margins: -5
                                        onClicked: {
                                            removeTag(index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }

        Rectangle {
            Layout.alignment: Qt.AlignBottom
            Layout.preferredHeight: hintLabel.visible ? inputField.height + hintLabel.height : inputField.height
            Layout.fillWidth: true
            color: 'whitesmoke'
            visible: !readOnly

            TextField {
                id: inputField
                anchors.top: parent.top
                anchors.leftMargin: 5
                leftPadding: 5
                placeholderText: 'Input tag'
                focus: true
                validator: RegExpValidator {
                    regExp: /^\S+(?: +\S+)*$/
                }

                onAccepted: {
                    appendTag(text)
                    text = ''
                }

                onTextChanged: {
                    if (text === '') {
                        return
                    }

                    if (!acceptableInput) {
                        hintTimer.restart()
                    } else {
                        hintTimer.stop()
                        hintLabel.visible = false
                    }
                }
            }

            Label {
                id: hintLabel
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.leftMargin: 5
                text: 'Input tag cannot end with whitespace.'
                color: 'red'
                visible: false
            }
        }
    }
}
