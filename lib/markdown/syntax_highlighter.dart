enum SyntaxTokenType {
  plain,
  keyword,
  string,
  escape,
  interpolation,
  comment,
  docComment,
  number,
  type,
  function,
  annotation,
  operator,
  punctuation,
  property,
  constant,
  variable,
  flag,
}

class SyntaxToken {
  final String text;
  final SyntaxTokenType type;

  const SyntaxToken(this.text, this.type);
}

class _LangSpec {
  final String? lineComment;
  final String? docComment;
  final String? blockCommentStart;
  final String? blockCommentEnd;
  final Set<String> keywords;
  final Set<String> types;
  final Set<String> constants;
  final Set<String> builtins;
  final Set<String> contextual;
  final bool annotations;
  final bool interpolation;
  final bool shellVariables;
  final bool shellFlags;
  final bool tripleQuotes;
  final bool rawStrings;
  final bool backtickStrings;
  final bool pascalCaseIsType;

  const _LangSpec({
    this.lineComment,
    this.docComment,
    this.blockCommentStart,
    this.blockCommentEnd,
    this.keywords = const {},
    this.types = const {},
    this.constants = const {},
    this.builtins = const {},
    this.contextual = const {},
    this.annotations = false,
    this.interpolation = false,
    this.shellVariables = false,
    this.shellFlags = false,
    this.tripleQuotes = false,
    this.rawStrings = false,
    this.backtickStrings = true,
    this.pascalCaseIsType = false,
  });
}

const _dartSpec = _LangSpec(
  lineComment: '//',
  docComment: '///',
  blockCommentStart: '/*',
  blockCommentEnd: '*/',
  annotations: true,
  interpolation: true,
  tripleQuotes: true,
  rawStrings: true,
  backtickStrings: false,
  pascalCaseIsType: true,
  keywords: {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'if',
    'implements',
    'import',
    'in',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'on',
    'part',
    'required',
    'rethrow',
    'return',
    'set',
    'static',
    'super',
    'switch',
    'this',
    'throw',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  },
  constants: {'true', 'false', 'null'},
  contextual: {
    'base',
    'hide',
    'show',
    'of',
    'when',
    'sealed',
    'interface',
    'operator',
    'sync',
    'deferred',
  },
  types: {
    'int',
    'double',
    'num',
    'String',
    'bool',
    'List',
    'Map',
    'Set',
    'Iterable',
    'Object',
    'Never',
    'Future',
    'Stream',
    'Record',
    'Type',
    'Symbol',
    'Duration',
    'DateTime',
    'Uri',
    'RegExp',
    'Function',
    'Enum',
    'Error',
    'Exception',
  },
);

const _bashSpec = _LangSpec(
  lineComment: '#',
  shellVariables: true,
  shellFlags: true,
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
    'in',
    'select',
    'time',
  },
  builtins: {
    'alias',
    'bg',
    'break',
    'cd',
    'command',
    'continue',
    'declare',
    'echo',
    'eval',
    'exec',
    'exit',
    'export',
    'fg',
    'jobs',
    'kill',
    'local',
    'printf',
    'pwd',
    'read',
    'readonly',
    'return',
    'set',
    'shift',
    'source',
    'sudo',
    'test',
    'trap',
    'type',
    'unalias',
    'unset',
    'wait',
    'dart',
    'flutter',
    'git',
    'pacman',
    'yay',
    'paru',
    'systemctl',
    'cat',
    'ls',
    'mkdir',
    'rm',
    'cp',
    'mv',
    'grep',
    'sed',
    'awk',
    'curl',
    'chmod',
    'chown',
  },
  constants: {'true', 'false'},
);

const _jsonSpec = _LangSpec(
  backtickStrings: false,
  constants: {'true', 'false', 'null'},
);

const _cLikeSpec = _LangSpec(
  lineComment: '//',
  blockCommentStart: '/*',
  blockCommentEnd: '*/',
  pascalCaseIsType: true,
  annotations: true,
  keywords: {
    'abstract',
    'as',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'else',
    'enum',
    'export',
    'extends',
    'finally',
    'fn',
    'for',
    'from',
    'function',
    'if',
    'impl',
    'implements',
    'import',
    'in',
    'interface',
    'let',
    'match',
    'mod',
    'mut',
    'new',
    'of',
    'package',
    'private',
    'protected',
    'pub',
    'public',
    'return',
    'static',
    'struct',
    'super',
    'switch',
    'this',
    'throw',
    'trait',
    'try',
    'type',
    'use',
    'var',
    'void',
    'while',
    'yield',
  },
  constants: {'true', 'false', 'null', 'nil', 'None', 'undefined'},
  types: {
    'int',
    'float',
    'double',
    'string',
    'bool',
    'boolean',
    'char',
    'byte',
    'long',
    'short',
    'number',
    'any',
    'String',
    'Object',
  },
);

const _pythonSpec = _LangSpec(
  lineComment: '#',
  tripleQuotes: true,
  rawStrings: true,
  annotations: true,
  backtickStrings: false,
  pascalCaseIsType: true,
  keywords: {
    'and',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'class',
    'continue',
    'def',
    'del',
    'elif',
    'else',
    'except',
    'finally',
    'for',
    'from',
    'global',
    'if',
    'import',
    'in',
    'is',
    'lambda',
    'nonlocal',
    'not',
    'or',
    'pass',
    'raise',
    'return',
    'try',
    'while',
    'with',
    'yield',
  },
  constants: {'True', 'False', 'None'},
  builtins: {'print', 'len', 'range', 'self', 'cls'},
  types: {'int', 'float', 'str', 'bool', 'list', 'dict', 'set', 'tuple'},
);

const _genericSpec = _LangSpec();

const _valueSpec = _LangSpec(
  backtickStrings: false,
  constants: {'true', 'false', 'null', 'yes', 'no', 'on', 'off', '~'},
);

final _wordStart = RegExp(r'[A-Za-z_$]');
final _wordChar = RegExp(r'[A-Za-z0-9_$]');
final _digit = RegExp(r'[0-9]');
final _hexDigit = RegExp(r'[0-9A-Fa-f_]');
final _numberChar = RegExp(r'[0-9_]');
final _upper = RegExp(r'[A-Z]');
final _yamlKey = RegExp(r'^(-\s+)?([A-Za-z0-9_.\-\x22\x27]+)(\s*:)(?=\s|$)');
final _tomlKey = RegExp(r'^()([A-Za-z0-9_.\-\x22\x27]+)(\s*=)');
final _tomlSection = RegExp(r'^\[\[?[^\]]+\]\]?');
final _envKey = RegExp(r'^(export\s+)?([A-Za-z0-9_.\-]+)(\s*=)');
final _yamlAnchor = RegExp(r'^(\s*)([&*!][A-Za-z0-9_.\-]*)');
final _bareValue = RegExp(r'^\s*[^\s\x22\x27#\[\]{},]+\s*$');
final _numericStart = RegExp(r'^\s*[-+]?[0-9]');
final _htmlTagPattern = RegExp(
  r'(<\/?|\/?>)|'
  r'([a-zA-Z_:][a-zA-Z0-9_:.\-]*)(\s*=\s*)'
  r'(\x22[^\x22]*\x22|\x27[^\x27]*\x27|[^\s>\x22\x27]+)|'
  r'([a-zA-Z_:][a-zA-Z0-9_:.\-]*)|(\s+)|(.)',
);
const _operatorChars = '+-*/%=<>!&|^~?:';
const _punctuationChars = '{}()[];,.';

class SyntaxHighlighter {
  static List<SyntaxToken> highlight(String code, String? language) {
    switch (language?.toLowerCase().trim()) {
      case 'dart':
        return _tokenize(code, _dartSpec);
      case 'bash':
      case 'sh':
      case 'shell':
      case 'zsh':
      case 'console':
        return _tokenize(code, _bashSpec);
      case 'python':
      case 'py':
        return _tokenize(code, _pythonSpec);
      case 'json':
      case 'jsonc':
        return _highlightJson(code);
      case 'js':
      case 'javascript':
      case 'ts':
      case 'typescript':
      case 'java':
      case 'kotlin':
      case 'kt':
      case 'swift':
      case 'go':
      case 'rust':
      case 'rs':
      case 'c':
      case 'cpp':
      case 'cs':
      case 'csharp':
        return _tokenize(code, _cLikeSpec);
      case 'yaml':
      case 'yml':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: _yamlKey,
        );
      case 'toml':
      case 'ini':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: _tomlKey,
          sectionPattern: _tomlSection,
        );
      case 'env':
      case 'dotenv':
        return _highlightKeyValue(
          code,
          commentPrefix: '#',
          keyPattern: _envKey,
        );
      case 'html':
      case 'xml':
      case 'svg':
        return _highlightHtml(code);
      default:
        return _tokenize(code, _genericSpec);
    }
  }

  static List<SyntaxToken> _tokenize(String code, _LangSpec spec) {
    final tokens = <SyntaxToken>[];
    final n = code.length;
    var i = 0;

    void add(String text, SyntaxTokenType type) {
      if (text.isEmpty) return;
      if (tokens.isNotEmpty && tokens.last.type == type) {
        tokens[tokens.length - 1] = SyntaxToken(tokens.last.text + text, type);
      } else {
        tokens.add(SyntaxToken(text, type));
      }
    }

    String? previousWord() {
      for (var k = tokens.length - 1; k >= 0; k--) {
        final token = tokens[k];
        final text = token.text.trim();
        if (token.type == SyntaxTokenType.plain && text.isEmpty) {
          continue;
        }
        if (token.type == SyntaxTokenType.keyword) return text;
        return null;
      }
      return null;
    }

    int nextNonSpace(int from) {
      var k = from;
      while (k < n && (code[k] == ' ' || code[k] == '\t')) {
        k++;
      }
      return k;
    }

    while (i < n) {
      final lineComment = spec.lineComment;
      final docComment = spec.docComment;
      if (docComment != null &&
          code.startsWith(docComment, i) &&
          !code.startsWith('$docComment/', i)) {
        final end = code.indexOf('\n', i);
        final stop = end == -1 ? n : end;
        add(code.substring(i, stop), SyntaxTokenType.docComment);
        i = stop;
        continue;
      }

      if (lineComment != null && code.startsWith(lineComment, i)) {
        final isShellExpansion =
            spec.shellVariables &&
            lineComment == '#' &&
            i > 0 &&
            _wordChar.hasMatch(code[i - 1]);
        if (!isShellExpansion) {
          final end = code.indexOf('\n', i);
          final stop = end == -1 ? n : end;
          add(code.substring(i, stop), SyntaxTokenType.comment);
          i = stop;
          continue;
        }
      }

      final blockStart = spec.blockCommentStart;
      final blockEnd = spec.blockCommentEnd;
      if (blockStart != null &&
          blockEnd != null &&
          code.startsWith(blockStart, i)) {
        final endIdx = code.indexOf(blockEnd, i + blockStart.length);
        final stop = endIdx == -1 ? n : endIdx + blockEnd.length;
        final isDoc = code.startsWith('/**', i) && !code.startsWith('/**/', i);
        add(
          code.substring(i, stop),
          isDoc ? SyntaxTokenType.docComment : SyntaxTokenType.comment,
        );
        i = stop;
        continue;
      }

      final ch = code[i];

      final isRaw =
          spec.rawStrings &&
          ch == 'r' &&
          i + 1 < n &&
          (code[i + 1] == '"' || code[i + 1] == "'");
      final isQuote =
          ch == '"' || ch == "'" || (spec.backtickStrings && ch == '`');
      if (isRaw || isQuote) {
        final prefixLength = isRaw ? 1 : 0;
        final quote = code[i + prefixLength];
        final triple =
            spec.tripleQuotes && code.startsWith(quote * 3, i + prefixLength);
        final quoteLength = triple ? 3 : 1;
        final canInterpolate =
            (spec.interpolation && !isRaw && quote != '`') ||
            (spec.shellVariables && quote == '"');
        final canEscape = !isRaw;

        add(
          code.substring(i, i + prefixLength + quoteLength),
          SyntaxTokenType.string,
        );
        var j = i + prefixLength + quoteLength;
        final terminator = quote * quoteLength;
        var closed = false;

        while (j < n) {
          if (code.startsWith(terminator, j)) {
            add(terminator, SyntaxTokenType.string);
            j += quoteLength;
            closed = true;
            break;
          }
          if (!triple && code[j] == '\n' && !spec.shellVariables) {
            break;
          }
          if (canEscape && code[j] == '\\' && j + 1 < n) {
            add(code.substring(j, j + 2), SyntaxTokenType.escape);
            j += 2;
            continue;
          }
          if (canInterpolate && code[j] == '\$' && j + 1 < n) {
            final next = code[j + 1];
            if (next == '{') {
              var depth = 1;
              var k = j + 2;
              while (k < n && depth > 0) {
                if (code[k] == '{') depth++;
                if (code[k] == '}') depth--;
                k++;
              }
              add(code.substring(j, k), SyntaxTokenType.interpolation);
              j = k;
              continue;
            }
            if (_wordStart.hasMatch(next) && next != '\$') {
              var k = j + 2;
              while (k < n && _wordChar.hasMatch(code[k]) && code[k] != '\$') {
                k++;
              }
              add(code.substring(j, k), SyntaxTokenType.interpolation);
              j = k;
              continue;
            }
            if (spec.shellVariables && '0123456789?!@*#'.contains(next)) {
              add(code.substring(j, j + 2), SyntaxTokenType.interpolation);
              j += 2;
              continue;
            }
          }
          add(code[j], SyntaxTokenType.string);
          j++;
        }
        if (!closed && j >= n) {
          i = n;
        } else {
          i = j;
        }
        continue;
      }

      if (spec.shellVariables && ch == '\$' && i + 1 < n) {
        final next = code[i + 1];
        if (next == '{') {
          final end = code.indexOf('}', i);
          final stop = end == -1 ? n : end + 1;
          add(code.substring(i, stop), SyntaxTokenType.variable);
          i = stop;
          continue;
        }
        if (next == '(') {
          add('\$', SyntaxTokenType.variable);
          i++;
          continue;
        }
        if (_wordStart.hasMatch(next) ||
            _digit.hasMatch(next) ||
            '?!@*#\$'.contains(next)) {
          var k = i + 2;
          if (_wordStart.hasMatch(next)) {
            while (k < n && _wordChar.hasMatch(code[k])) {
              k++;
            }
          }
          add(code.substring(i, k), SyntaxTokenType.variable);
          i = k;
          continue;
        }
      }

      if (spec.shellFlags &&
          ch == '-' &&
          i + 1 < n &&
          (code[i + 1] == '-' || _wordStart.hasMatch(code[i + 1])) &&
          (i == 0 || code[i - 1] == ' ' || code[i - 1] == '\t')) {
        var k = i + 1;
        while (k < n && code[k] == '-') {
          k++;
        }
        while (k < n && (_wordChar.hasMatch(code[k]) || code[k] == '-')) {
          k++;
        }
        add(code.substring(i, k), SyntaxTokenType.flag);
        i = k;
        continue;
      }

      if (spec.annotations &&
          ch == '@' &&
          i + 1 < n &&
          _wordStart.hasMatch(code[i + 1])) {
        var k = i + 1;
        while (k < n && (_wordChar.hasMatch(code[k]) || code[k] == '.')) {
          k++;
        }
        add(code.substring(i, k), SyntaxTokenType.annotation);
        i = k;
        continue;
      }

      final leadingDot =
          ch == '.' &&
          i + 1 < n &&
          _digit.hasMatch(code[i + 1]) &&
          !_isWordBefore(code, i);
      if (_digit.hasMatch(ch) || leadingDot) {
        var k = i;
        final hasHexPrefix =
            i + 1 < n && (code[i + 1] == 'x' || code[i + 1] == 'X');
        if (ch == '0' && hasHexPrefix) {
          k = i + 2;
          while (k < n && _hexDigit.hasMatch(code[k])) {
            k++;
          }
        } else {
          while (k < n && _numberChar.hasMatch(code[k])) {
            k++;
          }
          while (k + 1 < n && code[k] == '.' && _digit.hasMatch(code[k + 1])) {
            k++;
            while (k < n && _numberChar.hasMatch(code[k])) {
              k++;
            }
          }
          if (k < n && (code[k] == 'e' || code[k] == 'E')) {
            var m = k + 1;
            if (m < n && (code[m] == '+' || code[m] == '-')) m++;
            if (m < n && _digit.hasMatch(code[m])) {
              k = m;
              while (k < n && _numberChar.hasMatch(code[k])) {
                k++;
              }
            }
          }
        }
        add(code.substring(i, k), SyntaxTokenType.number);
        i = k;
        continue;
      }

      if (_wordStart.hasMatch(ch)) {
        var k = i + 1;
        while (k < n && _wordChar.hasMatch(code[k])) {
          k++;
        }
        final word = code.substring(i, k);
        final after = nextNonSpace(k);
        final followedByCall = after < n && code[after] == '(';
        final afterDot = i > 0 && code[i - 1] == '.';
        final previous = previousWord();

        SyntaxTokenType type;
        if (spec.constants.contains(word)) {
          type = SyntaxTokenType.constant;
        } else if (spec.keywords.contains(word) && !afterDot) {
          type = SyntaxTokenType.keyword;
        } else if (spec.contextual.contains(word) &&
            !afterDot &&
            !followedByCall &&
            _isContextualKeyword(code, i, k)) {
          type = SyntaxTokenType.keyword;
        } else if (spec.types.contains(word)) {
          type = SyntaxTokenType.type;
        } else if (spec.builtins.contains(word) && !afterDot) {
          type = spec.shellVariables
              ? SyntaxTokenType.function
              : SyntaxTokenType.keyword;
        } else if (spec.pascalCaseIsType &&
            _upper.hasMatch(word[0]) &&
            word.length > 1 &&
            word != word.toUpperCase()) {
          type = SyntaxTokenType.type;
        } else if (spec.pascalCaseIsType &&
            _upper.hasMatch(word[0]) &&
            word == word.toUpperCase() &&
            word.length > 1 &&
            !followedByCall) {
          type = SyntaxTokenType.constant;
        } else if (followedByCall) {
          type = SyntaxTokenType.function;
        } else if (afterDot) {
          type = SyntaxTokenType.property;
        } else if (previous == 'class' ||
            previous == 'enum' ||
            previous == 'mixin' ||
            previous == 'extension' ||
            previous == 'typedef' ||
            previous == 'interface' ||
            previous == 'struct' ||
            previous == 'trait') {
          type = SyntaxTokenType.type;
        } else {
          type = SyntaxTokenType.plain;
        }
        add(word, type);
        i = k;
        continue;
      }

      if (_operatorChars.contains(ch)) {
        add(ch, SyntaxTokenType.operator);
        i++;
        continue;
      }

      if (_punctuationChars.contains(ch)) {
        add(ch, SyntaxTokenType.punctuation);
        i++;
        continue;
      }

      add(ch, SyntaxTokenType.plain);
      i++;
    }
    return tokens;
  }

  static bool _isContextualKeyword(String code, int start, int end) {
    var after = end;
    while (after < code.length && (code[after] == ' ' || code[after] == '\t')) {
      after++;
    }
    if (after >= code.length) return false;
    final next = code[after];
    return _wordStart.hasMatch(next) || next == '{' || next == "'";
  }

  static bool _isWordBefore(String code, int index) {
    if (index == 0) return false;
    return _wordChar.hasMatch(code[index - 1]);
  }

  static List<SyntaxToken> _highlightJson(String code) {
    final tokens = _tokenize(code, _jsonSpec);
    final result = <SyntaxToken>[];
    for (var i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      if (token.type == SyntaxTokenType.string) {
        var j = i + 1;
        while (j < tokens.length &&
            tokens[j].type == SyntaxTokenType.plain &&
            tokens[j].text.trim().isEmpty) {
          j++;
        }
        final isKey =
            j < tokens.length &&
            tokens[j].type == SyntaxTokenType.operator &&
            tokens[j].text.startsWith(':');
        result.add(
          SyntaxToken(
            token.text,
            isKey ? SyntaxTokenType.property : SyntaxTokenType.string,
          ),
        );
      } else {
        result.add(token);
      }
    }
    return result;
  }

  static List<SyntaxToken> _highlightKeyValue(
    String code, {
    required String commentPrefix,
    required RegExp keyPattern,
    RegExp? sectionPattern,
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
        final section = sectionPattern?.firstMatch(trimmedLeft);
        if (section != null) {
          tokens.add(SyntaxToken(section.group(0)!, SyntaxTokenType.type));
          tokens.addAll(
            _valueTokens(trimmedLeft.substring(section.end), commentPrefix),
          );
        } else {
          final match = keyPattern.firstMatch(trimmedLeft);
          if (match != null) {
            final lead = match.group(1) ?? '';
            final key = match.group(2)!;
            final separator = match.group(3)!;
            if (lead.isNotEmpty) {
              tokens.add(SyntaxToken(lead, SyntaxTokenType.punctuation));
            }
            tokens.add(SyntaxToken(key, SyntaxTokenType.property));
            tokens.add(SyntaxToken(separator, SyntaxTokenType.operator));
            tokens.addAll(
              _valueTokens(trimmedLeft.substring(match.end), commentPrefix),
            );
          } else if (trimmedLeft.startsWith('- ')) {
            tokens.add(SyntaxToken('-', SyntaxTokenType.punctuation));
            tokens.addAll(
              _valueTokens(trimmedLeft.substring(1), commentPrefix),
            );
          } else {
            tokens.addAll(_valueTokens(trimmedLeft, commentPrefix));
          }
        }
      }
      if (li != lines.length - 1) {
        tokens.add(const SyntaxToken('\n', SyntaxTokenType.plain));
      }
    }
    return tokens;
  }

  static List<SyntaxToken> _valueTokens(String text, String commentPrefix) {
    final commentIndex = _findInlineComment(text, commentPrefix);
    final value = commentIndex == -1 ? text : text.substring(0, commentIndex);
    final tokens = <SyntaxToken>[];

    var rest = value;
    final anchorMatch = _yamlAnchor.firstMatch(rest);
    if (anchorMatch != null) {
      final space = anchorMatch.group(1)!;
      if (space.isNotEmpty) {
        tokens.add(SyntaxToken(space, SyntaxTokenType.plain));
      }
      tokens.add(
        SyntaxToken(anchorMatch.group(2)!, SyntaxTokenType.annotation),
      );
      rest = rest.substring(anchorMatch.end);
    }

    if (_bareValue.hasMatch(rest) && !_numericStart.hasMatch(rest)) {
      final word = rest.trim();
      final lead = rest.substring(0, rest.indexOf(word));
      final trail = rest.substring(lead.length + word.length);
      if (lead.isNotEmpty) tokens.add(SyntaxToken(lead, SyntaxTokenType.plain));
      final lower = word.toLowerCase();
      final isConstant = _valueSpec.constants.contains(lower);
      tokens.add(
        SyntaxToken(
          word,
          isConstant ? SyntaxTokenType.constant : SyntaxTokenType.string,
        ),
      );
      if (trail.isNotEmpty) {
        tokens.add(SyntaxToken(trail, SyntaxTokenType.plain));
      }
    } else {
      tokens.addAll(_tokenize(rest, _valueSpec));
    }

    if (commentIndex != -1) {
      tokens.add(
        SyntaxToken(text.substring(commentIndex), SyntaxTokenType.comment),
      );
    }
    return tokens;
  }

  static int _findInlineComment(String text, String prefix) {
    String? quote;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (quote != null) {
        if (ch == '\\' && quote == '"') {
          i++;
        } else if (ch == quote) {
          quote = null;
        }
        continue;
      }
      if (ch == '"' || ch == "'") {
        quote = ch;
        continue;
      }
      final atBoundary = i == 0 || text[i - 1] == ' ' || text[i - 1] == '\t';
      if (atBoundary && text.startsWith(prefix, i)) {
        return i;
      }
    }
    return -1;
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
        String? quote;
        while (j < n) {
          final ch = code[j];
          if (quote != null) {
            if (ch == quote) quote = null;
          } else if (ch == '"' || ch == "'") {
            quote = ch;
          } else if (ch == '>') {
            break;
          }
          j++;
        }
        final stop = j < n ? j + 1 : j;
        tokens.addAll(_tokenizeHtmlTag(code.substring(i, stop)));
        i = stop;
        continue;
      }
      if (code[i] == '&') {
        final end = code.indexOf(';', i);
        if (end != -1 && end - i <= 10) {
          tokens.add(
            SyntaxToken(code.substring(i, end + 1), SyntaxTokenType.escape),
          );
          i = end + 1;
          continue;
        }
      }
      var j = i;
      while (j < n && code[j] != '<' && code[j] != '&') {
        j++;
      }
      if (j == i) j++;
      tokens.add(SyntaxToken(code.substring(i, j), SyntaxTokenType.plain));
      i = j;
    }
    return tokens;
  }

  static List<SyntaxToken> _tokenizeHtmlTag(String tag) {
    final tokens = <SyntaxToken>[];
    final pattern = _htmlTagPattern;
    var sawName = false;
    for (final match in pattern.allMatches(tag)) {
      if (match.group(1) != null) {
        tokens.add(SyntaxToken(match.group(1)!, SyntaxTokenType.punctuation));
      } else if (match.group(2) != null) {
        tokens.add(SyntaxToken(match.group(2)!, SyntaxTokenType.property));
        tokens.add(SyntaxToken(match.group(3)!, SyntaxTokenType.operator));
        tokens.add(SyntaxToken(match.group(4)!, SyntaxTokenType.string));
      } else if (match.group(5) != null) {
        tokens.add(
          SyntaxToken(
            match.group(5)!,
            sawName ? SyntaxTokenType.property : SyntaxTokenType.keyword,
          ),
        );
        sawName = true;
      } else if (match.group(6) != null) {
        tokens.add(SyntaxToken(match.group(6)!, SyntaxTokenType.plain));
      } else if (match.group(7) != null) {
        tokens.add(SyntaxToken(match.group(7)!, SyntaxTokenType.plain));
      }
    }
    return tokens;
  }
}
