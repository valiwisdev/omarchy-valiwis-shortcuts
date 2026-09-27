import QtQuick
import qs.Commons

Column {
  id: root
  property var rootRef

  anchors.centerIn: parent
  spacing: Style.space(10)
  visible: (rootRef.viewMode === "apps" ? rootRef.appsModel.count === 0 : rootRef.displayModel.count === 0)

  Text {
    text: "⌨"
    color: rootRef.catppuccinSurface2
    font.pixelSize: Style.font.displayLarge
    horizontalAlignment: Text.AlignHCenter
    width: parent.width
  }

  Text {
    textFormat: Text.PlainText
    text: rootRef.activeTab === "shortcuts" && rootRef.shortcutsApps.length === 0 ? "No shortcuts loaded" :
          rootRef.activeTab === "commands" && rootRef.commandsApps.length === 0 ? "No commands loaded" :
          "No matches for \"" + rootRef.filterText + "\""
    color: rootRef.catppuccinSubtext0
    font.family: rootRef.fontFamily
    font.pixelSize: Style.font.title
    font.weight: Font.Normal
    horizontalAlignment: Text.AlignHCenter
    width: parent.width
  }
}
