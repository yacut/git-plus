{BufferedProcess} = require 'atom'
LogListView = require './log-list-view'
StatusView = require './status-view'

dir = ->
  atom.project.getRepo().getWorkingDirectory()

currentFile = ->
  atom.project.getRepo().relativize atom.workspace.getActiveEditor()?.getPath()

gitLog = (onlyCurrentFile=false) ->
  args = ['log', '--pretty="%h;|%aN <%aE>;|%s;|%ar (%aD)"', '-s', '-n25']
  args.push currentFile() if onlyCurrentFile and currentFile()?

  new BufferedProcess
    command: 'git'
    args: args
    options:
      cwd: dir()
    stdout: (data) ->
      new LogListView(data, onlyCurrentFile)
    stderr: (data) ->
      new StatusView(type: 'alert', message: data.toString())

module.exports = gitLog
