function parseShortcuts(raw) {
  try {
    var data = JSON.parse(String(raw || ""))
    return Array.isArray(data) ? data : []
  } catch (e) {
    return []
  }
}

function normalizedQuery(query) {
  return String(query || "").trim().toLowerCase()
}

function searchableText(entry, appName) {
  return (String(entry.keys || "") + " " + String(entry.action || "") + " " + String(appName || "")).toLowerCase()
}

function getItemsFromApp(app, isCommands) {
  if (!app) return []
  var items = []
  if (app.categories) {
    for (var category in app.categories) {
      var categoryItems = app.categories[category]
      if (Array.isArray(categoryItems)) {
        for (var i = 0; i < categoryItems.length; i++) {
          items.push(categoryItems[i])
        }
      }
    }
  } else {
    items = isCommands ? (app.commands || []) : (app.shortcuts || [])
  }
  return items
}

function flattenShortcuts(apps, query, limit) {
  var values = Array.isArray(apps) ? apps : []
  var needle = normalizedQuery(query)
  var max = limit === undefined || limit === null ? 500 : Number(limit)
  if (isNaN(max)) max = 500
  max = Math.max(0, max)
  if (max === 0) return []

  var rows = []
  for (var i = 0; i < values.length; i++) {
    var app = values[i]
    if (!app) continue
    var appName = String(app.app || "")
    var items = getItemsFromApp(app, false)
    for (var j = 0; j < items.length; j++) {
      var shortcut = items[j]
      if (!shortcut || !shortcut.keys) continue
      if (needle && searchableText(shortcut, appName).indexOf(needle) < 0) continue
      rows.push({
        app: appName,
        keys: String(shortcut.keys || ""),
        action: String(shortcut.action || "")
      })
      if (rows.length >= max) return rows
    }
  }
  return rows
}

function flattenCommands(apps, query, limit) {
  var values = Array.isArray(apps) ? apps : []
  var needle = normalizedQuery(query)
  var max = limit === undefined || limit === null ? 500 : Number(limit)
  if (isNaN(max)) max = 500
  max = Math.max(0, max)
  if (max === 0) return []

  var rows = []
  for (var i = 0; i < values.length; i++) {
    var app = values[i]
    if (!app) continue
    var appName = String(app.app || "")
    var items = getItemsFromApp(app, true)
    for (var j = 0; j < items.length; j++) {
      var cmd = items[j]
      if (!cmd || !cmd.keys) continue
      if (needle && searchableText(cmd, appName).indexOf(needle) < 0) continue
      rows.push({
        app: appName,
        keys: String(cmd.keys || ""),
        action: String(cmd.action || "")
      })
      if (rows.length >= max) return rows
    }
  }
  return rows
}

function getCategoriesForApp(apps, appIndex) {
  var values = Array.isArray(apps) ? apps : []
  if (appIndex < 0 || appIndex >= values.length) return []
  var app = values[appIndex]
  if (!app || !app.categories) return []
  var categories = []
  for (var category in app.categories) {
    if (Array.isArray(app.categories[category]) && app.categories[category].length > 0) {
      categories.push(category)
    }
  }
  return categories
}

function filterItemsForApp(apps, appIndex, query, isCommands, category) {
  var values = Array.isArray(apps) ? apps : []
  if (appIndex < 0 || appIndex >= values.length) return []
  var app = values[appIndex]
  if (!app) return []
  var items = []
  if (category && app.categories && app.categories[category]) {
    items = app.categories[category]
  } else {
    items = getItemsFromApp(app, isCommands)
  }
  var appName = String(app.app || "")
  var needle = normalizedQuery(query)
  var rows = []
  for (var j = 0; j < items.length; j++) {
    var item = items[j]
    if (!item || !item.keys) continue
    if (needle && searchableText(item, appName).indexOf(needle) < 0) continue
    rows.push({
      app: appName,
      keys: String(item.keys || ""),
      action: String(item.action || "")
    })
  }
  return rows
}

function filterApps(apps, query) {
  var values = Array.isArray(apps) ? apps : []
  var needle = normalizedQuery(query)
  var result = []
  for (var i = 0; i < values.length; i++) {
    var app = values[i]
    if (!app) continue
    var items = getItemsFromApp(app, false)
    if (items.length === 0) continue
    var appName = String(app.app || "")
    if (needle && appName.toLowerCase().indexOf(needle) < 0) continue
    result.push({
      name: appName,
      icon: String(app.icon || ""),
      count: items.length,
      index: i
    })
  }
  return result
}

function filterCommandApps(apps, query) {
  var values = Array.isArray(apps) ? apps : []
  var needle = normalizedQuery(query)
  var result = []
  for (var i = 0; i < values.length; i++) {
    var app = values[i]
    if (!app) continue
    var items = getItemsFromApp(app, true)
    if (items.length === 0) continue
    var appName = String(app.app || "")
    if (needle && appName.toLowerCase().indexOf(needle) < 0) continue
    result.push({
      name: appName,
      icon: String(app.icon || ""),
      count: items.length,
      index: i
    })
  }
  return result
}

if (typeof module !== "undefined") {
  module.exports = {
    parseShortcuts: parseShortcuts,
    normalizedQuery: normalizedQuery,
    flattenShortcuts: flattenShortcuts,
    flattenCommands: flattenCommands,
    getCategoriesForApp: getCategoriesForApp,
    filterItemsForApp: filterItemsForApp,
    filterApps: filterApps,
    filterCommandApps: filterCommandApps
  }
}
