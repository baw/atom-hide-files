utilites = require "./utilities.coffee"

hiddenItems = []

hide_file = () ->
  console.log "hide_file"
  if element = utilites.getActiveSidebarElement()
    console.log element
    element.addClass "hide-files-hide"
    hiddenItems.push element
    
unhide_files = () ->
  hiddenItems.forEach (item) ->
    item.removeClass "hide-files-hide"

module.exports.hide_file = hide_file
module.exports.unhide_files = unhide_files
