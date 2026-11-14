import 'package:dio/dio.dart';
import 'package:campus_net/dbg_print.dart';
import 'package:campus_net/text_process.dart';
import 'package:campus_net/crypto.dart';
import 'package:html/parser.dart' as html_parser;

class DioHttp {
  Map<String, String> storage = {
    'croypto': '',
    'execution': '',
    'root': '',
    'sam': '',
    'cas-sso': '',
  };
  //List<String> session = [];
  List<String> cookies_list = [];
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.10.16.56',
      connectTimeout: Duration(seconds: 10),
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;'
            'q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8, '
            'application/signed-exchange;v=b3;q=0.7',
        'Accept-Encoding': 'gzip, deflate',
        'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6',
        'Connection': 'keep-alive',
      },
      followRedirects: false,
      validateStatus: (s) => s != null && s < 400,
    ),
  );
  //============================TOOL=============================
  /// 去掉所有空白（含 \u00A0 不换行空格），base64 值里不应有空白
  String _clean(String s) =>
      s.replaceAll('\u00A0', '').replaceAll(RegExp(r'\s+'), '');

  //=============================================================
  //判空函数
  String ifNull(String? data, String name) {
    if (data == null || data == '') {
      throw StateError('$name is null');
    }
    return data;
  }

  String? v(String key) {
    final s = storage[key];
    return (s == null || s.isEmpty) ? null : s;
  }

  ///处理登录成功的无用cookie
  ///format -> {'name': 'name=xxx'}
  Map<String, String> pickMessyCookies(Response response) {
    final cookies = <String, String>{};

    final setCookieList = response.headers.map.entries
        .where((e) => e.key.toLowerCase() == 'set-cookie')
        .expand((e) => e.value);

    for (final raw in setCookieList) {
      final pair = raw.split(';').first.trim(); // 砍掉 Path/HttpOnly
      final eq = pair.indexOf('=');
      if (eq <= 0) continue;

      final name = pair.substring(0, eq);
      if (name == 'SOURCEID_TGC' || name == 'rg_objectid') {
        cookies[name] = pair;
      }
    }
    return cookies;
  }

  void login2SelfHelp() async {
    int count = 1;
    String final_rdr_cookie = '';
    //1.get自助中心地址
    var response = await dio.get('/self/index');
    String? rdrUrl;
    //2.手动控制循环跳转
    while (response.statusCode == 302) {
      DBG(count.toString());
      count++; //counter
      //获取跳转地址
      rdrUrl = response.headers.value('Location');
      //判空
      if (rdrUrl == null) {
        throw StateError('302 BUT redirect location is null');
      }
      //打印状态
      DBG(response.statusCode?.toString() ?? 'Unknown Status Code');
      DBG(rdrUrl); //调试打印

      //检查有没有Set-Cookie
      String? cookie = response.headers.value('Set-Cookie');
      if (cookie != null) {
        parseSessionCookieInto(storage, cookie);
      }
      //根据path选择cookie
      String path = whichPath(rdrUrl);
      DBG('cookie path: $path');

      final add_cookies = switch (path) {
        'sam' => [v('sam'), v('root')],
        'cas-sso' => [v('cas-sso'), v('root')],
        _ => [v('root')],
      }.whereType<String>().join('; ');

      //GET 拿密钥和execution
      response = await dio.get(
        rdrUrl,
        options: Options(headers: {'Cookie': add_cookies}),
      );
      final_rdr_cookie = add_cookies;
    } //302 redirect end

    //3.get login key
    final html = response.data;
    if (html == null || html.isEmpty) throw StateError('html is null');
    final doc = html_parser.parse(html);
    var el = doc.querySelector('#login-croypto');
    if (el == null) throw StateError('#login-croypto is null');
    DBG('#login-croypto: ${el.text}');
    storage['croypto'] = _clean(el.text);

    el = doc.querySelector('#login-page-flowkey');
    if (el == null) throw StateError('#login-page-flowkey is null');
    DBG('execution: ${el.text}');
    storage['execution'] = _clean(el.text);

    DBG('The url for login: $rdrUrl'); //看登录地址是否正确
    DBG('login cookie: $final_rdr_cookie'); //检查cookie还在否

    if (rdrUrl == null || rdrUrl == '') {
      throw StateError('SelfLogin url is null or empty');
    }

    //compose 登录表单
    String croypto = ifNull(storage['croypto'], 'login_croypto');
    String payload = aes_encrypt(croypto, '{}');
    Map<String, String> login_data = {
      'username': '2508210211',
      'type': 'UsernamePassword',
      '_eventId': 'submit',
      'execution': ifNull(storage['execution'], 'login_execution'),
      'croypto': croypto,
      'password': pass('AHQABjF0bkgeLBdCLy15AA=='),
      'captcha_payload': payload,
    };
    response = await dio.post(
      rdrUrl,
      options: Options(
        // 就是 'application/x-www-form-urlencoded'
        contentType: Headers.formUrlEncodedContentType,
        headers: {'Cookie': final_rdr_cookie},
      ),
      data: login_data,
    ); //登录表单发送

    count = 1;
    //存cookie
    Map<String, String> messyCookie = pickMessyCookies(response);

    while (response.statusCode == 302) {
      DBG(count.toString());
      count++;
      rdrUrl = response.headers.value('Location');
      //判空
      if (rdrUrl == null) {
        throw StateError('redirect location is null');
      }
      //打印状态
      DBG(response.statusCode?.toString() ?? 'Unknown Status Code');
      DBG(rdrUrl); //调试打印

      String path = whichPath(rdrUrl);
      DBG('cookie path: $path');
      if (path == 'cas-sso') {
        String messy_cookies =
            '${ifNull(storage['cas-sso'], 'cas-sso cookie')}; '
            '${messyCookie['SOURCEID_TGC']}; '
            '${messyCookie['rg_objectid']}; '
            '${ifNull(storage['root'], 'root cookie')}';

        response = await dio.get(
          rdrUrl,
          options: Options(headers: {'Cookie': messy_cookies}),
        );
      } else {}
    } //end loop
  }

  ///网络认证
  void login2Net() async {
    var response = await dio.get('http://captive.apple.com');
  }
}

///判断字符串开头, 忽略大小写
bool startsWith(String s, String prefix) =>
    s.toLowerCase().startsWith(prefix.toLowerCase());
