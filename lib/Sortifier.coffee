REQUIRE_REGEX = ///
  \s*?

  # Optional:
  #   `const something = `
  #   `const {one, two, three} = `
  (
    (var|let|const)
    \s+
    {?
      \s*
      ([$_a-zA-Z0-9]+)
      (\s*,\s*([$_a-zA-Z0-9]+))*
      \s*
    }?
    \s*
    =
    \s*
  )?

  # Required:
  #   require('path/to/module')
  #   require('json!path/to/json/module')
  require
  \s*
  \(
    \s*
    ['"]
    (?:([^!\n'"]+)!)?
    (.+)
    ['"]
    \s*
  \)
  \s*
  ;?
///

REQUIRE_GLOBAL_REGEX = new RegExp(REQUIRE_REGEX.source, 'g')
REQUIRE_BLOCK_REGEX = new RegExp("(#{REQUIRE_REGEX.source})+", 'm')

getName = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[3] if match

getPath = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[7] if match

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

entryFormatter = (entry, prefix) ->
  return prefix + entry.trim()

groupFormatter = (group, prefix) ->
  return group.map((entry) -> entryFormatter(entry, prefix)).join('\n')

class Sortifier
  sortify: (editor) ->
    buffer = editor.buffer

    editor.scanInBufferRange REQUIRE_BLOCK_REGEX, buffer.getRange(), ({range}) =>
      requireText = buffer.getTextInRange(range)
      return if not requireText

      [..., prefix] = requireText.match(/^\s*/)?[0]?.split('\n')
      openingWhitespace = requireText.match(/^\s*/)[0]
      requireText = requireText.trim()
      sortedRequireText = @sortRequires(requireText, prefix)
      return if not sortedRequireText

      buffer.setTextInRange(range, openingWhitespace + sortedRequireText)

  getRequireText: (text) ->
    match = text.match(REQUIRE_BLOCK_REGEX)
    return match[0] if match

  sortRequires: (text, prefix) ->
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
      return -1 if aGroup == ':aliased' or bGroup == ':unnamed'
      return  1 if aGroup == ':unnamed' or bGroup == ':aliased'
      return -1 if aGroup < bGroup
      return  1 if aGroup > bGroup
      return  0

    sortedText = groups.map((group) -> groupFormatter(group, prefix)).join('\n\n')

    return sortedText.replace(/^\s*/, '')

module.exports = Sortifier
