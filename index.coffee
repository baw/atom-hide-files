HideItems = require "./lib/hide_items.coffee"

module.exports =
  activate: (state) ->
    @hideItems = new HideItems()
    atom.commands.add "atom-workspace", "hide-files:hide-file",
                               @hideItems.hideItemCommand.bind @hideItems
    atom.commands.add "atom-workspace", "hide-files:hide-directory",
                               @hideItems.hideItemCommand.bind @hideItems
    
    atom.commands.add "atom-workspace", "hide-files:unhide-project-files",
                               @hideItems.unhideItems.bind @hideItems
