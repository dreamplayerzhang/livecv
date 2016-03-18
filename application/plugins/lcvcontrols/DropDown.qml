import QtQuick 2.3

Rectangle{
    id: root

    property variant model: []

    property color backgroundColor: "#444"
    property color highlightColor: "#44444a"
    property color textColor: "#ccc"

    property int dropBoxHeight: 80

    property alias selectedItem: chosenItemText.text
    property alias selectedIndex: listView.currentIndex

    signal comboClicked

    z: 100

    Rectangle {
        id: chosenItem
        width: parent.width
        height: root.height
        color: chosenItemMouse.containsMouse ? root.highlightColor : root.backgroundColor
        Text{
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            id: chosenItemText
            text: root.model ? root.model[0] : ''
            font.family: "Arial, Helvetica, sans-serif"
            font.pixelSize: 13
            color: "#ddd"
        }

        MouseArea{
            id: chosenItemMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                root.state = root.state === "dropDown" ? "" : "dropDown"
            }
            cursorShape: Qt.PointingHandCursor
        }
    }

    Rectangle {
        id: dropDown
        width: root.width
        height: 0
        clip: true
        anchors.top: chosenItem.bottom
        color: root.backgroundColor

        ListView {
            id: listView
            height: root.dropBoxHeight
            model: root.model
            currentIndex: 0
            delegate: Rectangle {
                width: root.width
                height: root.height
                color: delegateArea.containsMouse ? root.highlightColor : "transparent"

                Text{
                    text: modelData
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 10
                    color: "#ddd"
                    font.family: "Arial, Helvetica, sans-serif"
                    font.pixelSize: 13
                }
                MouseArea{
                    id: delegateArea
                    anchors.fill: parent
                    onClicked: {
                        root.state = ""
                        var prevSelection = chosenItemText.text
                        chosenItemText.text = modelData
                        if (chosenItemText.text != prevSelection) {
                            root.comboClicked()
                        }
                        listView.currentIndex = index
                    }
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }

    states: State {
        name: "dropDown"
        PropertyChanges {
            target: dropDown
            height: 40 * root.model.length
        }
    }

    transitions: Transition {
        NumberAnimation {
            target: dropDown
            properties: "height"
            easing.type: Easing.OutExpo
            duration: 1000
        }
    }
}


