{CompositeDisposable} = require 'atom'
Sortifier = require './Sortifier'

module.exports = Sugarify =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'sugarify:run': => @run()

  deactivate: ->
    @subscriptions.dispose()

  run: ->
    if editor = atom.workspace.getActiveTextEditor()
      sortifier = new Sortifier()
      text = editor.getText()
      sortedRequireText = sortifier.sortify(text)

      if sortedRequireText
        editor.setText(sortedRequireText)
