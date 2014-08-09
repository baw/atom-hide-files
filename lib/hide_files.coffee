utilites = require "./utilities.coffee"

hiddenItems = []

hide_file = () ->
  if element = utilites.getActiveSidebarElement()
    element.addClass "hide-files-hide"
    hiddenItems.push element
    
unhide_files = () ->
  hiddenItems.forEach (item) ->
    item.removeClass "hide-files-hide"

module.exports.hide_file = hide_file
module.exports.unhide_files = unhide_files
