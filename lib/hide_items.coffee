utilites = require "./utilities.coffee"

class HideItems
  atom.deserializers.add this
  
  constructor: (@items = []) ->
  
  hideItem: (item) ->
    item.classList.add "hide-files-hide"
  
  hideItemCommand: ->
    item = utilites.getActiveSidebarElement()
    
    if item?
      @hideItem item
      @items.push item
  
  unhideItems: ->
    for item in @items
      item.classList.remove "hide-files-hide"
    @items = []
  
module.exports = HideItems
