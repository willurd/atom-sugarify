{CompositeDisposable} = require 'atom'

REQUIRE_REGEX = /(var\s+([^\s]+)\s*=\s*)?require\s*\(\s*['"](?:([^!])+!)?(.+)['"]\s*\)\s*;?/
REQUIRE_GLOBAL_REGEX = new RegExp(REQUIRE_REGEX.source, 'g')
REQUIRE_BLOCK_REGEX = new RegExp("(\\s*#{REQUIRE_REGEX.source}\\s*)+", 'm')

getName = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[2] if match

getPath = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[4] if match

getBaseDirectory = (line) ->
  path = getPath(line)
  return ':unnamed' if !getName(line)
  return path.split('/')[0] if path and ~path.indexOf('/')
  return ':aliased'

groupBy = (array, fn) ->
  groups = {}
  array.forEach (item) ->
    group = fn(item)
    groups[group] = groups[group] || []
    groups[group].push(item)

  return Object.keys(groups).map (key) -> groups[key]

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

class Sortifier
  sortify: (text) ->
    requireText = @getRequireText(text)

    if requireText
      requireText = requireText.trim()
      sortedRequireText = @sortRequires(requireText) # + '\n'
      return text.replace(requireText, sortedRequireText)

  getRequireText: (text) ->
    match = text.match(REQUIRE_BLOCK_REGEX)
    return match[0] if match

  sortRequires: (text) ->
    requires = text.match(REQUIRE_GLOBAL_REGEX)
    requires.sort (a, b) ->
      aPath = getPath(a)
      bPath = getPath(b)
      return -1 if (aPath < bPath)
      return  1 if (aPath > bPath)
      return  0

    groups = groupBy requires, getBaseDirectory
    groups.sort (a, b) ->
      aGroup = getBaseDirectory(a[0])
      bGroup = getBaseDirectory(b[0])
      return -1 if aGroup == ':aliased' or aGroup < bGroup
      return  1 if aGroup == ':unnamed' or aGroup > bGroup
      return  0

    groups.forEach (group) ->
      console.group getBaseDirectory(group[0])
      group.forEach (item) ->
        console.log item
      console.groupEnd()

    return text


  #   def format_groups(groups, sep = '\n\n'):
  #     return sep.join(map(lambda group: '\n'.join(group[1]), groups))
  #
  #   def group_reducer(acc, item):
  #     key, lst = item
  #     acc[key] += lst
  #     return acc
  #
  #   groups = [(key, list(group)) for key, group in groupby(lines, base_dir_key)]
  #
  #   # groupby was not properly grouping items (sometimes).
  #   groups = list(reduce(group_reducer, groups, defaultdict(lambda: [])).items())
  #   groups.sort(key = group_sort_key)
  #
  #   named = list(filter(lambda group: group[0], groups))
  #   unnamed = list(filter(lambda group: not group[0], groups))
  #
  #   return '\n\n'.join(filter(None, [format_groups(named), format_groups(unnamed, '\n')]))
