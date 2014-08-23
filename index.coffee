HideItems = require "./lib/hide_items.coffee"

module.exports =
  activate: (state) ->
    @hideItems = new HideItems()
    atom.workspaceView.command "hide-files:hide-file",
                               @hideItems.hideItemCommand.bind(@hideItems)
    atom.workspaceView.command "hide-files:hide-directory",
                               @hideItems.hideItemCommand.bind(@hideItems)
    
    atom.workspaceView.command "hide-files:unhide-project-files",
                               @hideItems.unhideItems.bind(@hideItems)
