utilities =
  getActiveSidebarElement: ->
    @getAtomView().querySelector ".tree-view .selected"
  getAtomView: ->
    @atomView ||= atom.views.getView atom.workspace
  getTreeView: ->
    atom.packages.activatePackage('tree-view').then (result) ->
      result.mainModule.treeView

module.exports = utilities
