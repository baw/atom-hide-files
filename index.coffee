file_functions = require "./lib/hide_files.coffee"

module.exports =
  activate: (state) ->
    atom.workspaceView.command "hide-files:hide-file",
                               file_functions.hide_file
    atom.workspaceView.command "hide-files:hide-directory",
                               file_functions.hide_file
    
    atom.workspaceView.command "hide-files:unhide-project-files",
                               file_functions.unhide_files
