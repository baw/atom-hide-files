"use babel";

let utilites = require("./utilities.js");

class HideItems {
  constructor(itemsPaths, parents) {
    this.items = [];
    this.parentPathsToDirectoryEvent = {};

    this.deserialize(itemsPaths, parents);
  }

  addParentExpandEvents(node) {
    this.loopThroughParents(node, (parent) => {
      let event = this.parentPathsToDirectoryEvent[parent.directory.path];
      if (event !== undefined) {
        event.count += 1;
      } else {
        this.parentPathsToDirectoryEvent[parent.directory.path] = {
          eventHandler: parent.directory.onDidExpand(this.directoryDidExpandHandler.bind(this)),
          count: 1
        };
      }
    });
  }

  decrementEvent(path) {
    let event = this.parentPathsToDirectoryEvent[path];
    if (event) {
      if (event.count > 1) {
        event.count -= 1;
      } else {
        event.eventHandler.dispose();
        delete this.parentPathsToDirectoryEvent[path];
      }
    }
  }

  deserialize(itemsPaths, parents) {
    utilites.getTreeView().then((treeView) => {
      this.items = itemsPaths.map((path) => {
        let item = treeView.entryForPath(path);
        this.hideItem(item);
        return item;
      });

      parents.forEach((parentObj) => {
        let parent = treeView.entryForPath(parentObj.path).directory;
        this.parentPathsToDirectoryEvent[parent.path] = {
          eventHandler: parent.onDidExpand(this.directoryDidExpandHandler.bind(this)),
          count: parentObj.count
        };
      });
    });
  }

  directoryDidExpandHandler() {
    this.rehideItems();
    this.resetupEvents();
  }

  getParentDirectory(node) {
    node = node.parentNode;
    while (!node.classList.contains("directory")) {
      node = node.parentNode;
    }

    return node;
  }

  getPathOfItem(item) {
    let path = "";
    if (item.file !== undefined) {
      path = item.file.path;
    } else {
      path = item.directory.path;
    }

    return path;
  }

  hideItem(item) {
    item.classList.add("hide-files-hide");
  }

  hideItemCommand(event) {
    let item = utilites.getActiveSidebarElement();
    if (item !== undefined) {
      this.hideItem(item);
      this.items.push(item);

      this.addParentExpandEvents(event.target);
    }
  }

  loopThroughParents(node, cb) {
    if (node.directory !== undefined && node.directory.isRoot) {
      return;
    }

    let parent = this.getParentDirectory(node);

    while(parent) {
      cb(parent);

      if (parent.directory.isRoot) {
        parent = undefined;
      } else {
        parent = this.getParentDirectory(parent);
      }
    }
  }

  rehideItems() {
    utilites.getTreeView().then((treeView) => {
      this.items.forEach((item) => {
        let path = this.getPathOfItem(item);
        let node = treeView.entryForPath(path);
        this.hideItem(node);
      });
    });
  }

  removeItemByPath(path) {
    this.items = this.items.filter((item) => {
      let itemPath = this.getPathOfItem(item);

      return itemPath !== path;
    });
  }

  removeParentExpandEvents(node) {
    this.loopThroughParents(node, (parent) => {
      this.decrementEvent(parent.directory.path);
    });
  }

  resetupEvents() {
    utilites.getTreeView().then((treeView) => {
      Object.keys(this.parentPathsToDirectoryEvent).forEach((path) => {
        let directory = treeView.entryForPath(path).directory;
        let event = this.parentPathsToDirectoryEvent[path];
        event.eventHandler.dispose();
        event.eventHandler = directory.onDidExpand(this.directoryDidExpandHandler.bind(this));
      });
    });
  }

  serialize() {
    let state = {};
    state.itemsPaths = this.items.map((item) => {
      return this.getPathOfItem(item);
    });

    state.parents = Object.keys(this.parentPathsToDirectoryEvent).map((path) => {
      return {
        count: this.parentPathsToDirectoryEvent[path].count,
        path: path
      };
    });

    return state;
  }

  unHideChildren(event) {
    let node = utilites.getActiveSidebarElement();
    let directory = node.directory;
    let entries = directory.entries;

    this.decrementEvent(directory.path);

    this.removeParentExpandEvents(node);

    utilites.getTreeView().then((treeView) => {
      Object.keys(entries).forEach((key) => {
        let entry = entries[key];
        let item = treeView.entryForPath(entry.path);
        if (item !== undefined) {
          this.unHideItem(item);
          this.removeItemByPath(entry.path);
        }
      });
    });
  }

  unHideItem(item) {
    item.classList.remove("hide-files-hide");
  }

  unhideItems() {
    this.items.forEach((item) => {
      this.unHideItem(item);
    });

    this.items = [];
  }
}

module.exports = HideItems;
