{WorkspaceView} = require "atom"

describe "Hide file", () ->
  
  beforeEach () ->
    waitsForPromise () ->
      atom.packages.activatePackage "hide-files"
    
    runs () ->
      debugger
      atom.workspaceView = new WorkspaceView
      @file = atom.workspaceView.find('.tree-view .file').first().view()
      @file.click()
    
  describe "when the 'hide-files:hide-file' event is triggered", () ->
    it "makes the file hidden", () ->
      expect(@file).toBeVisible()
      @file.trigger 'hide-files:hide-file'
      expect(@file).toBeHidden()
