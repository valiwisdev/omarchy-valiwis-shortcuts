import QtQuick
import qs.Commons

ListView {
  id: root
  property var rootRef

  anchors.fill: parent
  model: rootRef.displayModel
  clip: true
  spacing: Style.space(2)
  boundsBehavior: Flickable.StopAtBounds
  visible: rootRef.viewMode === "shortcuts"

  delegate: Rectangle {
    id: row
    required property int index
    required property string app
    required property string keys
    required property string action

    readonly property bool hasCursor: rootRef.cursorActive && index === rootRef.selectedIndex

    width: ListView.view.width
    height: rootRef.rowHeight
    radius: Style.space(8)
    color: hasCursor ? Qt.rgba(rootRef.accentColor.r, rootRef.accentColor.g, rootRef.accentColor.b, 0.12) : "transparent"

    Row {
      anchors.fill: parent
      anchors.leftMargin: Style.space(14)
      anchors.rightMargin: Style.space(14)
      anchors.topMargin: Style.space(8)
      anchors.bottomMargin: Style.space(8)
      spacing: Style.space(14)

      Text {
        textFormat: Text.PlainText
        width: Style.space(200)
        height: parent.height
        text: row.keys
        color: row.hasCursor ? rootRef.accentColor : rootRef.catppuccinText
        font.family: rootRef.monoFamily
        font.pixelSize: Style.font.body
        font.weight: Font.Normal
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        textFormat: Text.PlainText
        width: parent.width - Style.space(200) - parent.spacing
        height: parent.height
        text: row.action
        color: row.hasCursor ? rootRef.catppuccinText : rootRef.catppuccinSubtext0
        font.family: rootRef.fontFamily
        font.pixelSize: Style.font.body
        font.weight: Font.Normal
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onContainsMouseChanged: if (containsMouse) {
        rootRef.cursorActive = true
        rootRef.selectedIndex = index
      }
      onClicked: {
        rootRef.cursorActive = true
        rootRef.selectedIndex = index
        rootRef.activateIndex(index)
      }
    }
  }
}
