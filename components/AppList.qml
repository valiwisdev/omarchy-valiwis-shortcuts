import QtQuick
import qs.Commons

ListView {
  id: root
  property var rootRef

  anchors.fill: parent
  model: rootRef.appsModel
  clip: true
  spacing: Style.space(3)
  boundsBehavior: Flickable.StopAtBounds
  visible: rootRef.viewMode === "apps"

  delegate: Rectangle {
    id: appRow
    required property int index
    required property string name
    required property string icon
    required property int count
    required property int appIndex

    readonly property bool hasCursor: rootRef.cursorActive && index === rootRef.selectedIndex

    width: ListView.view.width
    height: rootRef.rowHeight
    radius: Style.space(10)
    color: hasCursor ? Qt.rgba(rootRef.accentColor.r, rootRef.accentColor.g, rootRef.accentColor.b, 0.12) : rootRef.catppuccinMantle
    border.width: hasCursor ? 1 : 0
    border.color: Qt.rgba(rootRef.accentColor.r, rootRef.accentColor.g, rootRef.accentColor.b, 0.3)

    Row {
      anchors.fill: parent
      anchors.leftMargin: Style.space(14)
      anchors.rightMargin: Style.space(14)
      anchors.topMargin: Style.space(8)
      anchors.bottomMargin: Style.space(8)
      spacing: Style.space(14)

      Text {
        textFormat: Text.PlainText
        width: Style.space(32)
        height: parent.height
        text: appRow.icon || ""
        color: appRow.hasCursor ? rootRef.accentColor : rootRef.catppuccinSubtext0
        font.family: rootRef.monoFamily
        font.pixelSize: Style.font.heading
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        textFormat: Text.PlainText
        width: parent.width - countText.width - parent.spacing
        height: parent.height
        text: appRow.name
        color: appRow.hasCursor ? rootRef.catppuccinText : rootRef.catppuccinSubtext1
        font.family: rootRef.fontFamily
        font.pixelSize: Style.font.body
        font.weight: Font.Medium
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        id: countText
        textFormat: Text.PlainText
        width: contentWidth
        height: parent.height
        text: appRow.count.toString()
        color: appRow.hasCursor ? rootRef.accentColor : rootRef.catppuccinSurface2
        font.family: rootRef.monoFamily
        font.pixelSize: Style.font.caption
        font.weight: Font.Normal
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
