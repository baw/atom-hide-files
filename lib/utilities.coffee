utilities =
  getActiveSidebarElement: ->
    @getAtomView.find(".tree-view .selected")?.view?()
  getAtomView: ->
    @atomView ||= atom.views.getView(atom.workspace)

module.exports = utilities
