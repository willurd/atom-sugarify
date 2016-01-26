# REQUIRE_REGEX = /\s*(var\s+([^\s]+)\s*=\s*)?require\s*\(\s*['"](?:([^!\n'"]+)!)?(.+)['"]\s*\)\s*;?/
REQUIRE_REGEX = /\s*((var|let|const)\s+{?\s*([^\s]+)\s*}?\s*=\s*)?require\s*\(\s*['"](?:([^!\n'"]+)!)?(.+)['"]\s*\)\s*;?/
# REQUIRE_REGEX = /\s*(var|let|const\s+\{?\s*([^\s]+\s*,\s*?)+\s*\}?\s*=\s*)?require\s*\(\s*['"](?:([^!\n'"]+)!)?(.+)['"]\s*\)\s*;?/
REQUIRE_GLOBAL_REGEX = new RegExp(REQUIRE_REGEX.source, 'g')
REQUIRE_BLOCK_REGEX = new RegExp("(#{REQUIRE_REGEX.source})+", 'm')

getName = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[3] if match

getPath = (line) ->
  match = line.match(REQUIRE_REGEX)
  return match[5] if match

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
  sortify: (text) ->
    requireText = @getRequireText(text)

    if requireText
      [..., prefix] = requireText.match(/^\s*/)?[0]?.split('\n')
      requireText = requireText.trim()
      sortedRequireText = @sortRequires(requireText, prefix) # + '\n'
      return text.replace(requireText, sortedRequireText)

  getRequireText: (text) ->
    match = text.match(REQUIRE_BLOCK_REGEX)
    console.debug('getRequireText', match)
    return match[0] if match

  sortRequires: (text, prefix) ->
    requires = text.match(REQUIRE_GLOBAL_REGEX)
    console.debug('sortRequires', requires)
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
