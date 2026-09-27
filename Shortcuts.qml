import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.Commons
import qs.Ui
import "ShortcutsSearch.js" as ShortcutsSearch
import "components"

Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null

  property bool opened: false
  property string filterText: ""
  property int selectedIndex: 0
  property bool cursorActive: false
  property var shortcutsApps: []
  property var commandsApps: []
  property bool showCopiedFeedback: false
  property string notificationKeys: ""
  property string notificationAction: ""
  property string notificationApp: ""
  property bool notificationIsCommand: false
  property bool showNotification: false

  property string viewMode: "apps"
  property string activeTab: "shortcuts"
  property int selectedAppIndex: -1
  property string selectedAppName: ""
  property string selectedCategory: ""
  property var appCategories: []
  property var visibleCategories: []

  property color catppuccinBase: "#1e1e2e"
  property color catppuccinMantle: "#181825"
  property color catppuccinCrust: "#11111b"
  property color catppuccinSurface0: "#313244"
  property color catppuccinSurface2: "#585b70"
  property color catppuccinText: "#cdd6f4"
  property color catppuccinSubtext0: "#a6adc8"
  property color catppuccinSubtext1: "#bac2de"
  property color accentColor: "#f5c2e7"
  property color catppuccinGreen: "#a6e3a1"

  readonly property int cornerRadius: Style.cornerRadius
  property string fontFamily: Style.font.menuFamily
  property string monoFamily: Style.font.monoFamily || "JetBrains Mono"
  property int contentMargin: Style.spacing.panelPadding
  property int headerHeight: Math.max(Style.space(40), Style.font.title + Style.spacing.controlPaddingY * 2)
  property int tabsHeight: Style.space(38)
  property int contentSpacing: Style.spacing.md
  property int cardWidth: Math.min(Style.space(720), panel.width - Style.gapsOut * 2)
  property int cardHeight: Math.min(Style.space(580), panel.height - Style.gapsOut * 2)
  property int rowHeight: Math.max(Style.space(42), Style.font.body + Style.spacing.rowPaddingX * 2)

  property alias appsModel: _appsModel
  property alias displayModel: _displayModel

  function open(payloadJson) {
    root.opened = true
    root.filterText = ""
    root.selectedIndex = 0
    root.cursorActive = true
    root.showCopiedFeedback = false
    root.viewMode = "apps"
    root.activeTab = "shortcuts"
    root.selectedAppIndex = -1
    root.selectedAppName = ""
    root.rebuildApps()
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.opened = false
    root.showCopiedFeedback = false
  }

  function dismiss() {
    root.opened = false
    if (root.shell && typeof root.shell.hide === "function")
      root.shell.hide((root.manifest && root.manifest.id) || "valiwis.shortcuts")
  }

  function toggle() {
    if (root.opened) root.dismiss()
    else root.open("{}")
  }

  function loadShortcutsData(raw) {
    root.shortcutsApps = ShortcutsSearch.parseShortcuts(raw)
    if (root.opened) root.rebuildApps()
  }

  function loadCommandsData(raw) {
    root.commandsApps = ShortcutsSearch.parseShortcuts(raw)
    if (root.opened) root.rebuildApps()
  }

  function rebuildApps() {
    appsModel.clear()
    var apps = root.activeTab === "shortcuts" ? root.shortcutsApps : root.commandsApps
    var filtered = root.activeTab === "shortcuts"
      ? ShortcutsSearch.filterApps(apps, root.filterText)
      : ShortcutsSearch.filterCommandApps(apps, root.filterText)

    for (var i = 0; i < filtered.length; i++) {
      appsModel.append({
        name: filtered[i].name,
        icon: filtered[i].icon,
        count: filtered[i].count,
        appIndex: filtered[i].index,
        index: i
      })
    }

    if (appsModel.count === 0) selectedIndex = 0
    else if (selectedIndex >= appsModel.count) selectedIndex = appsModel.count - 1
    else if (selectedIndex < 0) selectedIndex = 0
    cursorActive = appsModel.count > 0

    Qt.callLater(function() {
      if (appsModel.count > 0) appsList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
    })
  }

  function rebuildShortcuts() {
    displayModel.clear()
    var apps = root.activeTab === "shortcuts" ? root.shortcutsApps : root.commandsApps
    var isCommands = root.activeTab === "commands"
    var rows
    if (root.selectedAppIndex === -2) {
      rows = isCommands
        ? ShortcutsSearch.flattenCommands(apps, root.filterText, 500)
        : ShortcutsSearch.flattenShortcuts(apps, root.filterText, 500)
    } else {
      rows = ShortcutsSearch.filterItemsForApp(apps, root.selectedAppIndex, root.filterText, isCommands, root.selectedCategory)
    }

    for (var i = 0; i < rows.length; i++) {
      displayModel.append({
        app: rows[i].app,
        keys: rows[i].keys,
        action: rows[i].action,
        index: i
      })
    }

    root.updateVisibleCategories()

    if (displayModel.count === 0) selectedIndex = 0
    else if (selectedIndex >= displayModel.count) selectedIndex = displayModel.count - 1
    else if (selectedIndex < 0) selectedIndex = 0
    cursorActive = displayModel.count > 0

    Qt.callLater(function() {
      if (displayModel.count > 0) resultList.positionViewAtIndex(root.selectedIndex, ListView.Contain)
    })
  }

  function updateVisibleCategories() {
    if (root.selectedAppIndex < 0) {
      root.visibleCategories = []
      return
    }
    var apps = root.activeTab === "shortcuts" ? root.shortcutsApps : root.commandsApps
    var allCats = ShortcutsSearch.getCategoriesForApp(apps, root.selectedAppIndex)
    if (!root.filterText) {
      root.visibleCategories = allCats
      return
    }
    var visibleCats = []
    for (var i = 0; i < allCats.length; i++) {
      var cat = allCats[i]
      var items = ShortcutsSearch.filterItemsForApp(apps, root.selectedAppIndex, root.filterText, root.activeTab === "commands", cat)
      if (items.length > 0) visibleCats.push(cat)
    }
    root.visibleCategories = visibleCats
    if (visibleCats.indexOf(root.selectedCategory) === -1 && visibleCats.length > 0) {
      root.selectedCategory = visibleCats[0]
    }
  }

  function rebuildDisplay() {
    if (root.viewMode === "apps") rebuildApps()
    else rebuildShortcuts()
  }

  function select(delta) {
    var model = root.viewMode === "apps" ? appsModel : displayModel
    if (model.count === 0) return
    if (!cursorActive) {
      cursorActive = true
      selectedIndex = delta < 0 ? model.count - 1 : 0
    } else {
      selectedIndex = (selectedIndex + delta + model.count) % model.count
    }
    var list = root.viewMode === "apps" ? appsList : resultList
    list.positionViewAtIndex(selectedIndex, ListView.Contain)
  }

  function selectPage(delta) {
    var model = root.viewMode === "apps" ? appsModel : displayModel
    var list = root.viewMode === "apps" ? appsList : resultList
    if (model.count === 0) return
    var visibleRows = Math.max(1, Math.floor(list.height / rowHeight))
    var newIndex = selectedIndex + delta * visibleRows
    if (newIndex < 0) newIndex = 0
    if (newIndex >= model.count) newIndex = model.count - 1
    selectedIndex = newIndex
    list.positionViewAtIndex(selectedIndex, ListView.Contain)
  }

  function setFilter(nextFilter) {
    root.filterText = nextFilter
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildDisplay()
  }

  function setTab(tab) {
    root.activeTab = tab
    root.filterText = ""
    root.selectedIndex = 0
    root.cursorActive = true
    root.viewMode = "apps"
    root.rebuildApps()
  }

  function setCategory(category) {
    root.selectedCategory = category
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildShortcuts()

    Qt.callLater(function() {
      var cats = root.visibleCategories
      var index = cats.indexOf(category)
      if (index >= 0) {
        categoryBar.scrollToCategory(index)
      }
    })
  }

  function selectCategory(delta) {
    var cats = root.visibleCategories
    if (cats.length === 0) return
    var currentIndex = cats.indexOf(root.selectedCategory)
    if (currentIndex === -1) currentIndex = 0
    var newIndex = (currentIndex + delta + cats.length) % cats.length
    root.selectedCategory = cats[newIndex]
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildShortcuts()

    Qt.callLater(function() {
      categoryBar.scrollToCategory(newIndex)
    })
  }

  function clearSearch() {
    root.filterText = ""
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildDisplay()
  }

  function enterApp(appIndex, appName) {
    root.selectedAppIndex = appIndex
    root.selectedAppName = appName
    var apps = root.activeTab === "shortcuts" ? root.shortcutsApps : root.commandsApps
    root.appCategories = ShortcutsSearch.getCategoriesForApp(apps, appIndex)
    root.selectedCategory = root.appCategories.length > 0 ? root.appCategories[0] : ""
    root.viewMode = "shortcuts"
    root.filterText = ""
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildShortcuts()
  }

  function exitApp() {
    root.viewMode = "apps"
    root.filterText = ""
    root.selectedAppIndex = -1
    root.selectedAppName = ""
    root.selectedCategory = ""
    root.appCategories = []
    root.visibleCategories = []
    root.selectedIndex = 0
    root.cursorActive = true
    root.rebuildApps()
  }

  function activateIndex(index) {
    if (root.viewMode === "apps") {
      if (index < 0 || index >= appsModel.count) return
      var app = appsModel.get(index)
      root.enterApp(app.appIndex, app.name)
    } else if (root.activeTab === "commands") {
      if (index < 0 || index >= displayModel.count) return
      var row = displayModel.get(index)
      root.copyShortcut(row.keys, row.action)
    } else {
      if (index < 0 || index >= displayModel.count) return
      var shortcutRow = displayModel.get(index)
      root.showShortcutNotification(shortcutRow.app, shortcutRow.keys, shortcutRow.action)
    }
  }

  function showShortcutNotification(app, keys, action) {
    root.notificationApp = app
    root.notificationKeys = keys
    root.notificationAction = action
    root.notificationIsCommand = false
    root.showNotification = true
    root.dismiss()
    notificationTimer.restart()
  }

  function copyShortcut(keys, action) {
    if (!keys) return
    root.showCopiedFeedback = true
    Quickshell.execDetached(["wl-copy", keys])
    copiedTimer.restart()

    var category = ""
    if (root.viewMode === "shortcuts" && root.selectedAppIndex >= 0) {
      category = root.selectedCategory
    }
    root.showCommandCopiedNotification(keys, category, action)
  }

  function showCommandCopiedNotification(keys, category, action) {
    root.notificationApp = category || "Command"
    root.notificationKeys = keys
    root.notificationAction = action || ""
    root.notificationIsCommand = true
    root.showNotification = true
    root.dismiss()
    notificationTimer.restart()
  }

  ListModel { id: _appsModel }
  ListModel { id: _displayModel }

  Timer {
    id: copiedTimer
    interval: 1500
    repeat: false
    onTriggered: root.showCopiedFeedback = false
  }

  Timer {
    id: notificationTimer
    interval: 3000
    repeat: false
    onTriggered: root.showNotification = false
  }

  FileView {
    path: Quickshell.env("HOME") + "/.config/omarchy/plugins/valiwis.shortcuts/shortcuts.json"
    watchChanges: true
    onLoaded: root.loadShortcutsData(text())
    onFileChanged: reload()
  }

  FileView {
    path: Quickshell.env("HOME") + "/.config/omarchy/plugins/valiwis.shortcuts/commands.json"
    watchChanges: true
    onLoaded: root.loadCommandsData(text())
    onFileChanged: reload()
  }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "valiwis-shortcuts"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    Rectangle {
      anchors.fill: parent
      color: Qt.rgba(root.catppuccinCrust.r, root.catppuccinCrust.g, root.catppuccinCrust.b, 0.85)
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.dismiss()
    }

    BorderSurface {
      id: card
      width: root.cardWidth
      height: root.cardHeight
      radius: root.cornerRadius
      anchors.centerIn: parent
      color: root.catppuccinBase
      borderSpec: Border.surfaceSpec("menu", "border", root.catppuccinSurface0, Math.max(1, Style.space(1)))
      padding: root.contentMargin

      MouseArea { anchors.fill: parent; onClicked: {} }

      Item {
        id: keyCatcher
        anchors.fill: parent
        focus: true

        Keys.priority: Keys.BeforeItem
        Keys.onPressed: function(event) {
          if (event.key === Qt.Key_Escape) {
            if (root.filterText) {
              root.setFilter("")
            } else if (root.viewMode === "shortcuts") {
              root.exitApp()
            } else {
              root.dismiss()
            }
            event.accepted = true
          } else if (event.key === Qt.Key_Backspace) {
            if (root.filterText) {
              root.setFilter(root.filterText.slice(0, -1))
              event.accepted = true
            } else if (root.viewMode === "shortcuts") {
              root.exitApp()
              event.accepted = true
            }
          } else if (event.key === Qt.Key_1 && event.modifiers & Qt.ControlModifier) {
            root.setTab("shortcuts")
            event.accepted = true
          } else if (event.key === Qt.Key_2 && event.modifiers & Qt.ControlModifier) {
            root.setTab("commands")
            event.accepted = true
          } else if (event.key === Qt.Key_U && event.modifiers & Qt.ControlModifier) {
            root.clearSearch()
            event.accepted = true
          } else if (event.key === Qt.Key_Left && root.viewMode === "shortcuts" && root.visibleCategories.length > 0) {
            root.selectCategory(-1)
            event.accepted = true
          } else if (event.key === Qt.Key_Right && root.viewMode === "shortcuts" && root.visibleCategories.length > 0) {
            root.selectCategory(1)
            event.accepted = true
          } else if (Util.editsFilter(event, root.filterText)) {
            root.setFilter(Util.editedFilter(event, root.filterText))
            event.accepted = true
          } else if (event.key === Qt.Key_Up) {
            root.select(-1)
            event.accepted = true
          } else if (event.key === Qt.Key_Down) {
            root.select(1)
            event.accepted = true
          } else if (event.key === Qt.Key_PageUp) {
            root.selectPage(-1)
            event.accepted = true
          } else if (event.key === Qt.Key_PageDown) {
            root.selectPage(1)
            event.accepted = true
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (root.cursorActive) root.activateIndex(root.selectedIndex)
            else {
              var model = root.viewMode === "apps" ? appsModel : displayModel
              if (model.count > 0) root.cursorActive = true
            }
            event.accepted = true
          } else if (event.text && event.text.length === 1 && event.text.charCodeAt(0) >= 32 && event.text.charCodeAt(0) !== 127) {
            root.setFilter(root.filterText + event.text)
            event.accepted = true
          }
        }
      }

      Column {
        anchors.fill: parent
        anchors.topMargin: card.contentTopInset
        anchors.rightMargin: card.contentRightInset
        anchors.bottomMargin: card.contentBottomInset
        anchors.leftMargin: card.contentLeftInset
        spacing: Style.space(12)

        HelpBar { rootRef: root }

        SearchHeader { rootRef: root }

        TabBar { rootRef: root }

        CategoryBar {
          id: categoryBar
          rootRef: root
        }

        Item {
          width: parent.width
          height: {
            var showCats = root.viewMode === "shortcuts" && root.visibleCategories.length > 0
            var catHeight = showCats ? root.tabsHeight : 0
            var helpBarHeight = Style.space(28)
            var gaps = (showCats ? 4 : 3) * root.contentSpacing
            return Math.max(100, parent.height - root.headerHeight - root.tabsHeight - catHeight - helpBarHeight - gaps)
          }

          AppList {
            id: appsList
            rootRef: root
          }

          ShortcutList {
            id: resultList
            rootRef: root
          }

          EmptyState { rootRef: root }
        }
      }
    }
  }

  Notification { rootRef: root }
}
