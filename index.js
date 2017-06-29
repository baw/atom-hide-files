"use babel";

let HideItems = require("./lib/hide_items.js");

module.exports = {
  activate(state) {
    this.hideItems = new HideItems(state.itemsPaths, state.parents);
    atom.commands.add("atom-workspace", "hide-files:hide-file",
                               this.hideItems.hideItemCommand.bind(this.hideItems));
    atom.commands.add("atom-workspace", "hide-files:hide-directory",
                               this.hideItems.hideItemCommand.bind(this.hideItems));
    atom.commands.add("atom-workspace", "hide-files:unhide-project-files",
                               this.hideItems.unhideItems.bind(this.hideItems));
    atom.commands.add("atom-workspace", "hide-files:unhide-children",
                               this.hideItems.unHideChildren.bind(this.hideItems));
  },

  serialize() {
    this.hideItems.serialize();
  }
};
