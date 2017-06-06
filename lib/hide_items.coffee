utilites = require "./utilities.coffee"

class HideItems
  atom.deserializers.add this

  constructor: (@items = []) ->
    @rehideItems

    @parentPathsToDirectoryEvent = {}

  addParentExpandEvents: (node) ->
    @loopThroughParents node, (parent) =>
      event = @parentPathsToDirectoryEvent[parent.directory.path]
      if event
        event.count += 1
      else
        @parentPathsToDirectoryEvent[parent.directory.path] = {
          eventHandler: parent.directory.onDidExpand(@directoryDidExpandHandler.bind(@)),
          count: 1
        }

  decrementEvent: (path) ->
    event = @parentPathsToDirectoryEvent[path]
    if event
      if event.count > 1
        event.count -= 1
      else
        event.eventHandler.dispose()
        delete @parentPathsToDirectoryEvent[path]

  directoryDidExpandHandler: ->
    @rehideItems()
    @resetupEvents()

  getParentDirectory: (node) ->
    node = node.parentNode
    while !node.classList.contains "directory"
      node = node.parentNode

    return node

  getPathOfItem: (item) ->
    path = ""
    if item.file?
      path = item.file.path
    else
      path = item.directory.path

    path

  hideItem: (item) ->
    item.classList.add "hide-files-hide"

  hideItemCommand: (event) ->
    item = utilites.getActiveSidebarElement()
    if item?
      @hideItem item
      @items.push item

      @addParentExpandEvents(event.target)

  loopThroughParents: (node, cb) ->
    if node.directory?.isRoot
      return

    parent = @getParentDirectory node
    while parent
      cb(parent)

      if parent.directory.isRoot
        parent = undefined
      else
        parent = @getParentDirectory parent

  rehideItems: ->
    utilites.getTreeView().then (treeView) =>
      for item in @items
        path = @getPathOfItem(item)
        node = treeView.entryForPath(path)
        @hideItem node

  removeItemByPath: (path) ->
    @items = @items.filter (item) =>
      itemPath = @getPathOfItem(item)
      itemPath != path

  removeParentExpandEvents: (node) ->
    @loopThroughParents node, (parent) =>
      @decrementEvent parent.directory.path

  resetupEvents: ->
    utilites.getTreeView().then (treeView) =>
      Object.keys(@parentPathsToDirectoryEvent).forEach (path) =>
        directory = treeView.entryForPath(path).directory
        event = @parentPathsToDirectoryEvent[path]
        event.eventHandler.dispose()
        event.eventHandler = directory.onDidExpand @directoryDidExpandHandler.bind @

  unHideChildren: (event) ->
    node = utilites.getActiveSidebarElement()
    directory = node.directory
    entries = directory.entries

    @decrementEvent directory.path

    @removeParentExpandEvents node

    utilites.getTreeView().then (treeView) =>
      Object.keys(entries).forEach (key) =>
        entry = entries[key]
        item = treeView.entryForPath(entry.path)
        if item
          @unHideItem item
          @removeItemByPath entry.path

  unHideItem: (item) ->
    item.classList.remove "hide-files-hide"

  unhideItems: ->
    for item in @items
      @unHideItem item
    @items = []

module.exports = HideItems
