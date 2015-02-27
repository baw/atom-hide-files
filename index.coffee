{ getAtomView } = require "./lib/utilities.coffee"
HideItems = require "./lib/hide_items.coffee"

module.exports =
  activate: (state) ->
    @hideItems = new HideItems()
    getAtomView.command "hide-files:hide-file",
                               @hideItems.hideItemCommand.bind(@hideItems)
    getAtomView.command "hide-files:hide-directory",
                               @hideItems.hideItemCommand.bind(@hideItems)
    
    getAtomView.command "hide-files:unhide-project-files",
                               @hideItems.unhideItems.bind(@hideItems)
