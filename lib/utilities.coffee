utilities =
  getActiveSidebarElement: ->
    atom.workspaceView.find(".tree-view .selected")?.view?()

module.exports = utilities
