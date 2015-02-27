utilities = require "./utilities.coffee"

class HideItems
  atom.deserializers.add this
  
  constructor: (@itemPaths = []) ->
    @directories = []
  
  addStyleTag: ->
    @_styleTag = $("<style>").attr "id", "hide-items"
    $("head").append @_styleTag
  
  hideItem: ($item) ->
    path = @_getItemPath $item
    console.log path
    @_getStyleTag().append """
      li:has(> .icon[data-path='#{ path }']) {
        display: none
      }
    """
  
  hideItemCommand: ->
    $item = utilities.getActiveSidebarElement()
    
    if $item?
      @hideItem $item
  
  unhideItems: ->
    @_getStyleTag.html("")
  
  _getItemForPath: (path) ->
    $(".icon[data-path='" + path + "']").closest "li"
  
  _getItemPath: ($item) ->
    $item.find("span").data "path"
  
  _getStyleTag: ->
    @_styleTag ||= $("#hide-items")
    
module.exports = HideItems
