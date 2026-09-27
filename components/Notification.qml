import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Commons

PanelWindow {
  id: root
  property var rootRef

  visible: rootRef.showNotification
  anchors { top: true; right: true }
  width: notificationContent.width + Style.space(40)
  height: Style.space(60) + notificationContent.height + Style.space(100)
  color: "transparent"
  WlrLayershell.namespace: "valiwis-shortcuts-notification"
  WlrLayershell.layer: WlrLayer.Overlay
  exclusionMode: ExclusionMode.Ignore

  Column {
    anchors { horizontalCenter: parent.horizontalCenter; top: parent.top }
    spacing: 0

    Item {
      width: 1
      height: Style.space(60)
    }

    Rectangle {
      id: notificationContent
      width: notifColumn.width + Style.space(32)
      height: notifColumn.height + Style.space(24)
      radius: Style.space(12)
      color: rootRef.catppuccinBase
      border.width: 1
      border.color: rootRef.accentColor

      Column {
        id: notifColumn
        anchors.centerIn: parent
        spacing: Style.space(8)

        Row {
          spacing: Style.space(10)
          Text {
            textFormat: Text.PlainText
            text: rootRef.notificationApp
            color: rootRef.accentColor
            font.family: rootRef.fontFamily
            font.pixelSize: Style.font.body
            font.weight: Font.Bold
          }
        }

        Rectangle {
          width: notifKeys.width + Style.space(16)
          height: notifKeys.height + Style.space(8)
          radius: Style.space(6)
          color: rootRef.catppuccinMantle
          border.width: 1
          border.color: rootRef.catppuccinSurface2

          Text {
            id: notifKeys
            anchors.centerIn: parent
            textFormat: Text.PlainText
            text: rootRef.notificationKeys
            color: rootRef.accentColor
            font.family: rootRef.monoFamily
            font.pixelSize: Style.font.title
            font.weight: Font.Medium
          }
        }

        Text {
          textFormat: Text.PlainText
          text: rootRef.notificationAction
          color: rootRef.catppuccinText
          font.family: rootRef.fontFamily
          font.pixelSize: Style.font.body
          horizontalAlignment: Text.AlignHCenter
          visible: rootRef.notificationAction !== ""
        }

        Text {
          textFormat: Text.PlainText
          text: "✓ Copied to clipboard"
          color: rootRef.catppuccinGreen
          font.family: rootRef.fontFamily
          font.pixelSize: Style.font.caption
          font.weight: Font.Medium
          visible: rootRef.notificationIsCommand
        }
      }
    }
  }
}
