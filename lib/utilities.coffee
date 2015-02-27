utilities =
  getActiveSidebarElement: ->
    $(@getAtomView).find(".tree-view .selected")
  getAtomView: ->
    @atomView ||= atom.views.getView(atom.workspace)

module.exports = utilities
