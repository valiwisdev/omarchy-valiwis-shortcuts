import QtQuick
import qs.Commons

Rectangle {
  id: root
  property var rootRef

  width: parent.width
  height: rootRef.headerHeight
  radius: Style.space(8)
  color: rootRef.catppuccinMantle

  Row {
    anchors.fill: parent
    anchors.leftMargin: Style.space(14)
    anchors.rightMargin: Style.space(14)
    spacing: Style.space(10)

    Text {
      textFormat: Text.PlainText
      width: parent.width - (rootRef.filterText ? clearButton.width + parent.spacing : 0) - (rootRef.showCopiedFeedback ? copiedBadge.width + parent.spacing : 0) - (rootRef.viewMode === "shortcuts" ? backLabel.width + parent.spacing : 0)
      height: parent.height
      text: rootRef.filterText || (rootRef.viewMode === "apps" ? "Search..." : rootRef.selectedAppName)
      color: rootRef.catppuccinText
      opacity: rootRef.filterText ? 1 : 0.6
      font.family: rootRef.fontFamily
      font.pixelSize: Style.font.heading
      font.weight: Font.Medium
      elide: Text.ElideRight
      verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
      id: clearButton
      visible: rootRef.filterText.length > 0
      width: clearLabel.width + Style.space(16)
      height: parent.height - Style.space(12)
      radius: Style.space(6)
      color: rootRef.catppuccinSurface0
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: clearLabel
        anchors.centerIn: parent
        textFormat: Text.PlainText
        text: "Ctrl+U"
        color: rootRef.catppuccinSubtext0
        font.family: rootRef.monoFamily
        font.pixelSize: Style.font.caption
        font.weight: Font.Medium
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: rootRef.clearSearch()
      }
    }

    Rectangle {
      id: backLabel
      visible: rootRef.viewMode === "shortcuts"
      width: backLabelText.width + Style.space(16)
      height: parent.height - Style.space(12)
      radius: Style.space(6)
      color: rootRef.catppuccinSurface0
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: backLabelText
        anchors.centerIn: parent
        textFormat: Text.PlainText
        text: "Esc"
        color: rootRef.catppuccinSubtext0
        font.family: rootRef.monoFamily
        font.pixelSize: Style.font.caption
        font.weight: Font.Medium
      }
    }

    Rectangle {
      id: copiedBadge
      visible: rootRef.showCopiedFeedback
      width: copiedLabel.width + Style.space(16)
      height: parent.height - Style.space(12)
      radius: Style.space(6)
      color: rootRef.catppuccinGreen
      anchors.verticalCenter: parent.verticalCenter

      Text {
        id: copiedLabel
        anchors.centerIn: parent
        textFormat: Text.PlainText
        text: "Copied!"
        color: rootRef.catppuccinCrust
        font.family: rootRef.fontFamily
        font.pixelSize: Style.font.caption
        font.weight: Font.Bold
      }
    }
  }
}
