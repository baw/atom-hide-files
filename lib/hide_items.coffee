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

  directoryDidExpandHandler: ->
    @rehideItems()
    @resetupEvents()

  getParentDirectory: (node) ->
    node = node.parentNode
    while !node.classList.contains "directory"
      node = node.parentNode

    return node

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

  resetupEvents: ->
    utilites.getTreeView().then (treeView) =>
      Object.keys(@parentPathsToDirectoryEvent).forEach (path) =>
        directory = treeView.entryForPath(path).directory
        event = @parentPathsToDirectoryEvent[path]
        event.eventHandler.dispose()
        event.eventHandler = directory.onDidExpand @directoryDidExpandHandler.bind @

  unhideItems: ->
    for item in @items
      @unHideItem item
    @items = []

module.exports = HideItems
