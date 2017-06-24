HideItems = require "./lib/hide_items.coffee"
require "./lib/hideFilesNamedInTxtFile.js"

module.exports =
  activate: (state) ->
    @hideItems = new HideItems(state.itemsPaths, state.parents)
    atom.commands.add "atom-workspace", "hide-files:hide-file",
                               @hideItems.hideItemCommand.bind @hideItems
    atom.commands.add "atom-workspace", "hide-files:hide-directory",
                               @hideItems.hideItemCommand.bind @hideItems
    atom.commands.add "atom-workspace", "hide-files:unhide-project-files",
                               @hideItems.unhideItems.bind @hideItems
    atom.commands.add "atom-workspace", "hide-files:unhide-children",
                               @hideItems.unHideChildren.bind @hideItems

  serialize: () ->
    @hideItems.serialize()
