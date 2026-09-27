import QtQuick
import qs.Commons

Row {
  id: root
  property var rootRef

  anchors.horizontalCenter: parent.horizontalCenter
  spacing: Style.space(20)

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h1Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h1Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "↑↓"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: "Navigate"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h2Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h2Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "←→"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: "Categories"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h3Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h3Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "↵"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: rootRef.activeTab === "commands" ? "Copy" : "Enter"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h4Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h4Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "Ctrl+U"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: "Clear"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h5Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h5Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "Esc"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: "Back"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }

  Row {
    spacing: Style.space(6)
    Rectangle {
      width: h6Keys.width + Style.space(12)
      height: Style.space(22)
      radius: Style.space(4)
      color: rootRef.catppuccinMantle
      border.width: 1
      border.color: rootRef.catppuccinSurface2
      anchors.verticalCenter: parent.verticalCenter
      Text { id: h6Keys; anchors.centerIn: parent; textFormat: Text.PlainText; text: "Ctrl+1/2"; color: rootRef.accentColor; font.family: rootRef.monoFamily; font.pixelSize: Style.font.caption; font.weight: Font.Medium }
    }
    Text { textFormat: Text.PlainText; text: "Tabs"; color: rootRef.catppuccinSubtext0; font.family: rootRef.fontFamily; font.pixelSize: Style.font.caption; anchors.verticalCenter: parent.verticalCenter }
  }
}
