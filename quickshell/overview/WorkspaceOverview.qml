import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Quickshell
import Quickshell.Io
import "../"

Item {
    id: window
    focus: true
    width: Screen.width

    Scaler {
        id: scaler
        currentWidth: Screen.width
    }
    function s(val) { return scaler.s(val); }

    MatugenColors { id: _theme }

    readonly property color base: _theme.base
    readonly property color text: _theme.text
    readonly property color subtext0: _theme.subtext0
    readonly property color surface0: _theme.surface0
    readonly property color surface1: _theme.surface1
    readonly property color teal: _theme.teal

    readonly property real skewFactor: -0.35
    readonly property real itemWidth: s(280)
    readonly property real itemHeight: s(380)
    readonly property real spacing: s(20)

    property int activeWorkspace: 1
    property var workspaceData: []
    property bool initialFocusSet: false

    property string scriptsDir: Quickshell.env("HOME") + "/.config/hypr/scripts"

    function refreshData() {
        wsProc.running = true;
    }

    Process {
        id: wsProc
        running: true
        command: ["bash", "-c", "hyprctl workspaces -j && echo '---' && hyprctl clients -j && echo '---' && hyprctl activeworkspace -j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let parts = this.text.split("---");
                    let workspaces = JSON.parse(parts[0].trim());
                    let clients = JSON.parse(parts[1].trim());
                    let active = JSON.parse(parts[2].trim());
                    
                    window.activeWorkspace = active.id;
                    
                    let data = [];
                    for (let i = 1; i <= 10; i++) {
                        let ws = workspaces.find(w => w.id === i);
                        let wsClients = clients.filter(c => c.workspace.id === i);
                        let appClasses = wsClients.map(c => c.class).filter(c => c);
                        let uniqueApps = [...new Set(appClasses)];
                        
                        data.push({
                            id: i,
                            windowCount: ws ? ws.windows : 0,
                            apps: uniqueApps,
                            isActive: i === active.id,
                            isOccupied: ws !== undefined && ws.windows > 0
                        });
                    }
                    window.workspaceData = data;
                    
                    Qt.callLater(() => {
                        view.currentIndex = active.id - 1;
                        view.positionViewAtIndex(active.id - 1, ListView.Center);
                        window.initialFocusSet = true;
                    });
                } catch(e) {
                    console.log("Overview parse error:", e);
                }
            }
        }
    }

    function switchToWorkspace(idx) {
        Quickshell.execDetached(["hyprctl", "dispatch", "workspace", (idx + 1).toString()]);
        Quickshell.execDetached(["bash", scriptsDir + "/qs_manager.sh", "close"]);
    }

    Connections {
        target: window
        function onVisibleChanged() {
            if (window.visible) {
                window.initialFocusSet = false;
                window.refreshData();
                window.forceActiveFocus();
            }
        }
    }

    Keys.onLeftPressed: {
        if (view.currentIndex > 0) view.currentIndex--;
        event.accepted = true;
    }
    Keys.onRightPressed: {
        if (view.currentIndex < 9) view.currentIndex++;
        event.accepted = true;
    }
    Keys.onReturnPressed: {
        switchToWorkspace(view.currentIndex);
        event.accepted = true;
    }
    Keys.onEscapePressed: {
        Quickshell.execDetached(["bash", scriptsDir + "/qs_manager.sh", "close"]);
        event.accepted = true;
    }

    ListView {
        id: view
        anchors.fill: parent
        anchors.leftMargin: window.s(60)
        anchors.rightMargin: window.s(60)
        
        spacing: window.spacing
        orientation: ListView.Horizontal
        clip: false
        cacheBuffer: 2000
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - (window.itemWidth / 2)
        preferredHighlightEnd: (width / 2) + (window.itemWidth / 2)
        
        highlightMoveDuration: window.initialFocusSet ? 400 : 0
        focus: true

        model: window.workspaceData

        delegate: Item {
            id: delegateRoot
            width: window.itemWidth
            height: window.itemHeight

            property bool isCurrent: index === view.currentIndex
            property bool isActive: modelData.isActive

            Item {
                anchors.fill: parent
                
                transform: Matrix4x4 {
                    property real s: window.skewFactor
                    matrix: Qt.matrix4x4(1, s, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1)
                }

                Rectangle {
                    anchors.fill: parent
                    radius: window.s(16)
                    color: delegateRoot.isActive ? Qt.rgba(window.teal.r, window.teal.g, window.teal.b, 0.12) : window.surface0
                    border.width: 2
                    border.color: delegateRoot.isCurrent ? window.teal : (delegateRoot.isActive ? Qt.rgba(window.teal.r, window.teal.g, window.teal.b, 0.4) : window.surface1)
                    Behavior on border.color { ColorAnimation { duration: 250 } }

                    opacity: delegateRoot.isCurrent ? 1.0 : 0.55
                    Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }

                    scale: delegateRoot.isCurrent ? 1.15 : 0.85
                    Behavior on scale { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }
                    Behavior on scale { NumberAnimation { duration: 350; easing.type: Easing.OutExpo } }
                }
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: window.s(24)
                spacing: window.s(12)
Item { Layout.fillHeight: true }

Text {
    text: modelData.id
    font.family: "JetBrains Mono"
    font.pixelSize: window.s(72)
    font.weight: Font.Black
    color: delegateRoot.isCurrent ? window.teal : window.text
    Layout.alignment: Qt.AlignHCenter
    Behavior on color { ColorAnimation { duration: 250 } }
}

Text {
    text: modelData.windowCount + (modelData.windowCount === 1 ? " window" : " windows")
    font.family: "JetBrains Mono"
    font.pixelSize: window.s(13)
    color: window.subtext0
    Layout.alignment: Qt.AlignHCenter
}

Item { Layout.fillHeight: true }

Flow {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter
    spacing: window.s(8)
    Repeater {
        model: modelData.apps.slice(0, 6)
        delegate: Rectangle {
            width: window.s(40)
            height: window.s(40)
            radius: window.s(10)
            color: window.surface1
            
            Image {
                anchors.centerIn: parent
                width: window.s(28)
                height: window.s(28)
                source: "image://icon/" + modelData.toLowerCase()
                sourceSize: Qt.size(64, 64)
                fillMode: Image.PreserveAspectFit
                smooth: true
            }
        }
    }
}

                Rectangle {
                    visible: modelData.isActive
                    Layout.alignment: Qt.AlignHCenter
                    width: window.s(60)
                    height: window.s(4)
                    radius: 2
                    color: window.teal
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index;
                    window.switchToWorkspace(index);
                }
            }
        }
    }
}
