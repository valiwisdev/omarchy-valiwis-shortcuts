import QtQuick
import qs.Commons

Row {
  id: root
  property var rootRef

  visible: rootRef.viewMode === "shortcuts" && rootRef.visibleCategories.length > 0
  width: parent.width
  height: rootRef.tabsHeight
  spacing: Style.space(4)

  function scrollToCategory(categoryIndex) {
    if (categoryIndex < 0 || categoryIndex >= categoriesRow.children.length) return
    
    var delegate = categoriesRow.children[categoryIndex]
    if (!delegate) return

    var flickableWidth = categoriesFlickable.width
    var contentX = categoriesFlickable.contentX
    var delegateX = delegate.x
    var delegateWidth = delegate.width

    var leftEdge = contentX
    var rightEdge = contentX + flickableWidth

    if (delegateX < leftEdge) {
      categoriesFlickable.contentX = delegateX
    } else if (delegateX + delegateWidth > rightEdge) {
      categoriesFlickable.contentX = delegateX + delegateWidth - flickableWidth
    }
  }

  Flickable {
    id: categoriesFlickable
    width: parent.width
    height: parent.height
    contentWidth: categoriesRow.width
    contentHeight: parent.height
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.HorizontalFlick

    Row {
      id: categoriesRow
      height: parent.height
      spacing: Style.space(4)

      Repeater {
        model: rootRef.visibleCategories

        delegate: Rectangle {
          required property string modelData
          required property int index
          width: categoryText.width + Style.space(20)
          height: parent.height
          radius: Style.space(6)
          color: rootRef.selectedCategory === modelData
            ? Qt.rgba(rootRef.accentColor.r, rootRef.accentColor.g, rootRef.accentColor.b, 0.15)
            : rootRef.catppuccinMantle
          border.width: rootRef.selectedCategory === modelData ? 1 : 0
          border.color: Qt.rgba(rootRef.accentColor.r, rootRef.accentColor.g, rootRef.accentColor.b, 0.4)

          Text {
            id: categoryText
            anchors.centerIn: parent
            textFormat: Text.PlainText
            text: modelData
            color: rootRef.selectedCategory === modelData ? rootRef.accentColor : rootRef.catppuccinSubtext0
            font.family: rootRef.fontFamily
            font.pixelSize: Style.font.caption
            font.weight: rootRef.selectedCategory === modelData ? Font.Medium : Font.Normal
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: rootRef.setCategory(modelData)
          }
        }
      }
    }
  }
}
