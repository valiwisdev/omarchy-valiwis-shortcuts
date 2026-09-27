import QtQuick
import qs.Commons

Row {
  id: root
  property var rootRef

  width: parent.width
  height: rootRef.tabsHeight
  spacing: Style.space(6)

  Repeater {
    model: [
      { label: "Shortcuts", tab: "shortcuts", color: rootRef.accentColor },
      { label: "Commands", tab: "commands", color: rootRef.accentColor }
    ]

    delegate: Rectangle {
      required property var modelData
      width: (parent.width - parent.spacing) / 2
      height: parent.height
      radius: Style.space(8)
      color: rootRef.activeTab === modelData.tab
        ? Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.15)
        : rootRef.catppuccinMantle
      border.width: rootRef.activeTab === modelData.tab ? 1 : 0
      border.color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.4)

      Text {
        anchors.centerIn: parent
        textFormat: Text.PlainText
        text: modelData.label
        color: rootRef.activeTab === modelData.tab ? modelData.color : rootRef.catppuccinSubtext0
        font.family: rootRef.fontFamily
        font.pixelSize: Style.font.body
        font.weight: rootRef.activeTab === modelData.tab ? Font.Medium : Font.Normal
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: rootRef.setTab(modelData.tab)
      }
    }
  }
}
