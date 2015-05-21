{CompositeDisposable} = require 'atom'


DEFINE_HEADER = '''define(function(require, exports, module) {

'''

STRICT_MODE_DIRECTIVE = '''  'use strict';

'''

# IS_REQUIRE_LINE_REGEX = /^\s*(?P<var>var\s+[^\s]+\s*=\s*)?require\s*\(\s*(?P<quote>['"])(?:(?P<plugin>[^!]+)!)?(?P<path>.+)(?P=quote)\s*\)\s*;?.*$/
# IS_BLANK_LINE_REGEX = /'^\s*$/
# DEFINE_SECTION_REGEX = /(?P<prefix>.*)define\(\s*\[\s*(?P<deps>[^\]]+)\s*\]\s*,\s*function\s*\(\s*(?P<vars>[^\)]+)\s*\)\s*{(?P<strictmode>\s*(?P<strictmodequote>['"])use\sstrict(?P=strictmodequote);?)?/<!--  -->
# DEFINE_SECTION_REGEX = /(.*)define\(\s*\[\s*([^\]]+)\s*\]\s*,\s*function\s*\(\s*([^\)]+)\s*\)\s*{(\s*['"]use\sstrict['"];?)?/

REQUIRE_REGEX = /(var\s+([^\s]+)\s*=\s*)?require\s*\(\s*['"](?:([^!])+!)?(.+)['"]\s*\)\s*;?/g
REQUIRE_BLOCK_REGEX = new RegExp("(\\s*#{REQUIRE_REGEX.source}\\s*)+", 'm')

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
      processedText = sortifier.sortify(text)

      if processedText
        editor.setText(processedText)

class Sortifier
  sortify: (text) ->
    requireText = @getRequireText(text)

    if requireText
      requireText = requireText.trim()
      processedText = @processRequireText(requireText) + '\n'
      return text.replace(requireText, processedText)

  getRequireText: (text) ->
    console.log REQUIRE_BLOCK_REGEX.source
    match = text.match(REQUIRE_BLOCK_REGEX)
    return match[0] if match

  processRequireText: (text) ->
    console.log 'processRequireText', text
    requires = text.match(REQUIRE_REGEX)
    console.log requires

  # def process_requires(self, requires):
  #   """
  #   Takes a block of text containing calls to `require()` and returns a block of text
  #   containing sorted calls to `require()`.
  #   """
  #   def format_groups(groups, sep = '\n\n'):
  #     return sep.join(map(lambda group: '\n'.join(group[1]), groups))
  #
  #   def group_reducer(acc, item):
  #     key, lst = item
  #     acc[key] += lst
  #     return acc
  #
  #   lines = requires.split('\n')
  #   lines = list(filter(is_require_line, lines))
  #   lines.sort(key = require_sort_key)
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


# class Sugarifier
#   sugarify: (text) ->
#     {fullMatch, requires, isStrictMode} = @getRequires(text)
#
#     if requires
#       processedRequires = @processRequires(requires)
#       strictModePart = if is_strict_mode then STRICT_MODE_DIRECTIVE else ''
#       newContents = DEFINE_HEADER + strictModePart + processedRequires
#
#       return newContents
#
#   getRequires: (text) ->
#     match = text.match(DEFINE_SECTION_REGEX)
#     console.log match
#
#     return {fullMatch: null, requires: null, isStrictMode, null}
