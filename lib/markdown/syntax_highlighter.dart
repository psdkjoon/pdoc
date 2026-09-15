enum SyntaxTokenType {
  plain,
  keyword,
  string,
  comment,
  number,
  type,
  punctuation,
}

class SyntaxToken {
  final String text;
  final SyntaxTokenType type;

  const SyntaxToken(this.text, this.type);
}

class _LangSpec {
  final String? lineComment;
  final String? blockCommentStart;
  final String? blockCommentEnd;
  final Set<String> keywords;
  final Set<String> types;

  const _LangSpec({
    this.lineComment,
    this.blockCommentStart,
    this.blockCommentEnd,
    this.keywords = const {},
    this.types = const {},
  });
}

const _dartSpec = _LangSpec(
  lineComment: '//',
  blockCommentStart: '/*',
  blockCommentEnd: '*/',
  keywords: {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  },
  types: {
    'int',
    'double',
    'String',
    'bool',
    'List',
    'Map',
    'Set',
    'Object',
    'num',
    'Future',
    'Stream',
    'Widget',
    'BuildContext',
    'Function',
    'Duration',
    'Offset',
    'Color',
    'Size',
  },
);

const _bashSpec = _LangSpec(
  lineComment: '#',
  keywords: {
    'if',
    'then',
    'else',
    'elif',
    'fi',
    'for',
    'do',
    'done',
    'while',
    'until',
    'case',
    'esac',
    'function',
    'return',
    'export',
    'local',
    'in',
    'select',
    'break',
    'continue',
    'eval',
    'exec',
    'source',
    'alias',
    'unset',
    'readonly',
    'declare',
    'shift',
    'trap',
    'set',
    'sudo',
    'echo',
    'cd',
    'exit',
  },
);

const _genericSpec = _LangSpec();

const _valueSpec = _LangSpec(keywords: {'true', 'false', 'null', 'yes', 'no'});

class SyntaxHighlighter {
  static List<SyntaxToken> highlight(String code, String? language) {
    switch (language?.toLowerCase().trim()) {
      case 'dart':
        return _tokenize(code, _dartSpec);
      case 'bash':
      case 'sh':
      case 'shell':
      case 'zsh':
        return _tokenize(code, _bashSpec);
      case 'yaml':
      case 'yml':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: RegExp(r'^([A-Za-z0-9_.\-]+\s*:)'),
        );
      case 'toml':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: RegExp(r'^([A-Za-z0-9_.\-]+\s*=)'),
        );
      case 'env':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: RegExp(r'^([A-Za-z0-9_.\-]+\s*=)'),
        );
      case 'html':
        return _highlightHtml(code);
      default:
        return _tokenize(code, _genericSpec);
    }
  }

  static List<SyntaxToken> _tokenize(String code, _LangSpec spec) {
    final tokens = <SyntaxToken>[];
    final n = code.length;
    final wordStart = RegExp(r'[A-Za-z_$]');
    final wordChar = RegExp(r'[A-Za-z0-9_$]');
    final digit = RegExp(r'[0-9]');
    var i = 0;

    void plain(String text) {
      if (tokens.isNotEmpty && tokens.last.type == SyntaxTokenType.plain) {
        tokens[tokens.length - 1] = SyntaxToken(
          tokens.last.text + text,
          SyntaxTokenType.plain,
        );
      } else {
        tokens.add(SyntaxToken(text, SyntaxTokenType.plain));
      }
    }

    while (i < n) {
      final lineComment = spec.lineComment;
      if (lineComment != null && code.startsWith(lineComment, i)) {
        final end = code.indexOf('\n', i);
        final stop = end == -1 ? n : end;
        tokens.add(
          SyntaxToken(code.substring(i, stop), SyntaxTokenType.comment),
        );
        i = stop;
        continue;
      }

      final blockStart = spec.blockCommentStart;
      final blockEnd = spec.blockCommentEnd;
      if (blockStart != null &&
          blockEnd != null &&
          code.startsWith(blockStart, i)) {
        final endIdx = code.indexOf(blockEnd, i + blockStart.length);
        final stop = endIdx == -1 ? n : endIdx + blockEnd.length;
        tokens.add(
          SyntaxToken(code.substring(i, stop), SyntaxTokenType.comment),
        );
        i = stop;
        continue;
      }

      final ch = code[i];
      if (ch == '"' || ch == "'" || ch == '`') {
        final quote = ch;
        var j = i + 1;
        while (j < n) {
          if (code[j] == '\\' && j + 1 < n) {
            j += 2;
            continue;
          }
          if (code[j] == quote) {
            j++;
            break;
          }
          j++;
        }
        tokens.add(SyntaxToken(code.substring(i, j), SyntaxTokenType.string));
        i = j;
        continue;
      }

      if (digit.hasMatch(ch)) {
        var j = i + 1;
        while (j < n && RegExp(r'[0-9._]').hasMatch(code[j])) {
          j++;
        }
        tokens.add(SyntaxToken(code.substring(i, j), SyntaxTokenType.number));
        i = j;
        continue;
      }

      if (wordStart.hasMatch(ch)) {
        var j = i + 1;
        while (j < n && wordChar.hasMatch(code[j])) {
          j++;
        }
        final word = code.substring(i, j);
        if (spec.keywords.contains(word)) {
          tokens.add(SyntaxToken(word, SyntaxTokenType.keyword));
        } else if (spec.types.contains(word)) {
          tokens.add(SyntaxToken(word, SyntaxTokenType.type));
        } else {
          plain(word);
        }
        i = j;
        continue;
      }

      plain(ch);
      i++;
    }
    return tokens;
  }

  static List<SyntaxToken> _highlightKeyValue(
    String code, {
    required String commentPrefix,
    required RegExp keyPattern,
  }) {
    final tokens = <SyntaxToken>[];
    final lines = code.split('\n');
    for (var li = 0; li < lines.length; li++) {
      final line = lines[li];
      final trimmedLeft = line.trimLeft();
      final indent = line.substring(0, line.length - trimmedLeft.length);
      if (indent.isNotEmpty) {
        tokens.add(SyntaxToken(indent, SyntaxTokenType.plain));
      }

      if (trimmedLeft.startsWith(commentPrefix)) {
        tokens.add(SyntaxToken(trimmedLeft, SyntaxTokenType.comment));
      } else {
        final match = keyPattern.firstMatch(trimmedLeft);
        if (match != null) {
          final key = match.group(1)!;
          tokens.add(SyntaxToken(key, SyntaxTokenType.type));
          tokens.addAll(
            _tokenize(trimmedLeft.substring(key.length), _valueSpec),
          );
        } else {
          tokens.addAll(_tokenize(trimmedLeft, _valueSpec));
        }
      }
      if (li != lines.length - 1) {
        tokens.add(const SyntaxToken('\n', SyntaxTokenType.plain));
      }
    }
    return tokens;
  }

  static List<SyntaxToken> _highlightHtml(String code) {
    final tokens = <SyntaxToken>[];
    final n = code.length;
    var i = 0;
    while (i < n) {
      if (code.startsWith('<!--', i)) {
        final end = code.indexOf('-->', i);
        final stop = end == -1 ? n : end + 3;
        tokens.add(
          SyntaxToken(code.substring(i, stop), SyntaxTokenType.comment),
        );
        i = stop;
        continue;
      }
      if (code[i] == '<') {
        var j = i + 1;
        while (j < n && code[j] != '>') {
          j++;
        }
        final stop = j < n ? j + 1 : j;
        tokens.addAll(_tokenizeHtmlTag(code.substring(i, stop)));
        i = stop;
        continue;
      }
      var j = i;
      while (j < n && code[j] != '<') {
        j++;
      }
      tokens.add(SyntaxToken(code.substring(i, j), SyntaxTokenType.plain));
      i = j;
    }
    return tokens;
  }

  static List<SyntaxToken> _tokenizeHtmlTag(String tag) {
    final tokens = <SyntaxToken>[];
    final pattern = RegExp(
      r'''([a-zA-Z0-9_-]+)(=)("[^"]*"|'[^']*')|([<>/])|(\s+)|([a-zA-Z0-9_-]+)''',
    );
    for (final match in pattern.allMatches(tag)) {
      if (match.group(1) != null) {
        tokens.add(SyntaxToken(match.group(1)!, SyntaxTokenType.keyword));
        tokens.add(SyntaxToken(match.group(2)!, SyntaxTokenType.plain));
        tokens.add(SyntaxToken(match.group(3)!, SyntaxTokenType.string));
      } else if (match.group(4) != null) {
        tokens.add(SyntaxToken(match.group(4)!, SyntaxTokenType.type));
      } else if (match.group(5) != null) {
        tokens.add(SyntaxToken(match.group(5)!, SyntaxTokenType.plain));
      } else if (match.group(6) != null) {
        tokens.add(SyntaxToken(match.group(6)!, SyntaxTokenType.type));
      }
    }
    return tokens;
  }
}
