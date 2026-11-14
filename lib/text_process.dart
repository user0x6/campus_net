String? extractSessionId(String setCookieHeader) {
  // 1. 按分号分割成多个部分
  final parts = setCookieHeader.split(';');

  // 2. 逐个检查每个部分
  for (final part in parts) {
    final trimmed = part.trim(); // 去掉首尾空格
    if (trimmed.startsWith('SESSION=')) {
      // 直接返回整个 'SESSION=...' 部分
      return trimmed;
    }
  }

  // 没找到返回 null
  return null;
}

/// 解析 Set-Cookie，把 name == 'SESSION'（可由 [names] 配置）的条目
/// 按 Path 归入 root / cas-sso / sam，并就地写入 [out]。
///
/// 行为约定：
///   1. 不清空、不预置 key。[out] 里原有的键值对（包括这三个 key 的旧值）
///      只有在本轮真的收到对应 Path 的新 SESSION 时才会被覆盖。
///   2. 只处理 cookie 名在 [names] 中的条目，其余 cookie 一律忽略。
///   3. 同一 Path 一轮内出现多次时，后出现的覆盖先出现的。
///   4. Path 精确匹配（忽略尾部 '/'）；没有 Path 属性的条目忽略。
///
/// [out] 必须是可变 Map，传入 const / unmodifiable 会抛 UnsupportedError。
/// 返回 [out] 本身，方便链式调用。
Map<String, String> parseSessionCookieInto(
  Map<String, String> out,
  String? setCookie, {
  Set<String> names = const {'SESSION'},
}) {
  if (setCookie == null || setCookie.trim().isEmpty) return out;

  const pathToKey = <String, String>{
    '/': 'root',
    '/cas-sso': 'cas-sso',
    '/sam': 'sam',
  };

  // 只在 ", name=" 边界切分，避开 Expires=Wed, 21 Oct 2015 ... 里的逗号
  final segments = setCookie.split(RegExp(r',(?=\s*[^;,=\s]+=)'));

  for (final segment in segments) {
    final parts = segment.split(';');
    if (parts.isEmpty) continue;

    // 第一段是 name=value
    final pair = parts.first.trim();
    final eq = pair.indexOf('=');
    if (eq <= 0) continue;

    final name = pair.substring(0, eq).trim();
    if (!names.contains(name)) continue; // 只关心 SESSION

    // 在属性里找 Path（属性名大小写不敏感，Path 值大小写敏感）
    String? path;
    for (final attr in parts.skip(1)) {
      final i = attr.indexOf('=');
      if (i <= 0) continue;
      if (attr.substring(0, i).trim().toLowerCase() == 'path') {
        path = _unquote(attr.substring(i + 1).trim());
        break;
      }
    }
    if (path == null) continue;

    final key = pathToKey[_normalizePath(path)];
    if (key == null) continue;

    out[key] = pair; // 整体存 'SESSION=xxx'
  }

  return out;
}

String _unquote(String s) {
  if (s.length >= 2 && s.startsWith('"') && s.endsWith('"')) {
    return s.substring(1, s.length - 1);
  }
  return s;
}

/// '/sam/' -> '/sam'，'' -> '/'
String _normalizePath(String path) {
  if (path.isEmpty) return '/';
  var p = path;
  while (p.length > 1 && p.endsWith('/')) {
    p = p.substring(0, p.length - 1);
  }
  return p;
}

String whichPath(String? path) {
  /**
   * /abc/def/ggg  =>  ['', 'abc', 'def', 'ggg']
   */
  if (path == null) throw StateError('rdrUrl is null');

  return path.split('/')[1];
}
