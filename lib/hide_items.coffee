utilities = require "./utilities.coffee"

class HideItems
  atom.deserializers.add this
  
  constructor: (@itemPaths = []) ->
    @directories = []
  
  addProjectRootEvent: ($item) ->
    $projectRoot = $item.closest ".project-root"
    $projectRoot.off "click.rehideItems"
    $projectRoot.on "click.rehideItems", ".directory", @rehideItemsEventHandler.bind(this)
  
  hideItem: ($item) ->
    $item.addClass "hide-files-hide"
  
  hideItemCommand: ->
    $item = utilities.getActiveSidebarElement()
    
    if $item?
      @hideItem $item
      @itemPaths.push $item.find("span").data("path")
      
      @addProjectRootEvent $item
  
  rehideItems: ->
    for itemPath in @itemPaths
      $item = @_getItemForPath itemPath
      @hideItem $item
  
  rehideItemsEventHandler: (e) ->
    if e.currentTarget.classList.contains "expanded"
      return
    
    setTimeout @rehideItems.bind(this), 0
  
  unhideItems: ->
    for itemPath in @itemPaths
      $item = @_getItemForPath(itemPath)
      $item.removeClass "hide-files-hide"
    @itemPaths = []
    
    for directory in @directories
      directory.removeEventListener "click", @rehideItemsEventHandler.bind(this)
    @directories = []
  
  _getItemForPath: (path) ->
    $(".icon[data-path='" + path + "']").closest "li"
  
module.exports = HideItems
