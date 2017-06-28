"use babel";

module.exports = {
  getActiveSidebarElement() {
    return this.getAtomView().querySelector(".tree-view .selected");
  },

  getAtomView() {
    if (this.atomView === undefined) {
      this.atomView = atom.views.getView(atom.workspace);
    }

    return this.atomView;
  },

  getTreeView() {
    return atom.packages.activatePackage("tree-view").then((result) => {
      return result.mainModule.treeView;
    });
  }
};
