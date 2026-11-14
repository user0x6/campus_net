1. GET http://10.10.16.56/

HTTP/1.1 302 Found
Date: Fri, 30 Oct 2026 08:22:04 GMT
Content-Length: 0
Connection: keep-alive
`Location: http://10.10.16.56/self/index`
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1 ; mode=block
Referrer-Policy: no-referrer

2. GET /self/index

GET /self/index HTTP/1.1 \
Host: 10.10.16.56 \
Upgrade-Insecure-Requests: 1 \
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) \AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0 \
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8, application/signed-exchange;v=b3;q=0.7 \
Accept-Encoding: gzip, deflate \
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6 \
Connection: keep-alive

HTTP/1.1 302 Found \
Date: Fri, 30 Oct 2026 08:45:33 GMT \
Content-Length: 0 \
` Location: /oauth2/authorization/custom-self ` \
Cache-Control: no-cache, no-store, max-age=0, must-revalidate \
Pragma: no-cache \
Expires: 0 \
X-Content-Type-Options: nosniff \
X-Frame-Options: SAMEORIGIN \
X-XSS-Protection: 1 ; mode=block \
Referrer-Policy: no-referrer \
` Set-Cookie: SESSION=1d52eb66-9fbb-4859-883d-1eeced1b5c3a; Path=/; HttpOnly; SameSite=Lax ` \
Proxy-Connection: keep-alive 

3. GET /oauth2/authorization/custom-self (with cookie)

302 ` Location3 `

4. GET Location3

302 Location4 \
` Set-Cookie: SESSION=cdaff4b7-ee7c-4efc-8d74-e00ed019550f; Path=/cas-sso/; HttpOnly ` 

5. GET Location4(/cas-sso/login?...) with 2cookies above
http://10.10.16.56/cas-sso/login?service=http%3A%2F%2F10.10.16.56%2Fcas-sso%2Foauth2.0%2FcallbackAuthorize%3Fclient_id%3DCerVBeNwjL3nexy3yD5ZmyZ5b1l023O-ZlSMVZA3lfkyjNN3QQGQapCjIUOIFE8MM%26redirect_uri%3Dhttp%253A%252F%252F10.10.16.56%252Flogin%252Foauth2%252Fcode%252Fcustom-self%26response_type%3Dcode%26client_name%3DCasOAuthClient
    (1->'/' , 2-> '/cas-sso/')

Host: 10.10.16.56 \
Upgrade-Insecure-Requests: 1 \
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0 \
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7 \
Accept-Encoding: gzip, deflate \
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6 \
` Cookie: SESSION=cdaff4b7-ee7c-4efc-8d74-e00ed019550f; SESSION=1d52eb66-9fbb-4859-883d-1eeced1b5c3a ` \
Connection: keep-alive

200 OK

----
## Login
(Location4)
POST /cas-sso/login?service=http%3A%2F%2F10.10.16.56%2Fcas-sso%2Foauth2.0%2FcallbackAuthorize%3Fclient_id%3DCerVBeNwjL3nexy3yD5ZmyZ5b1l023O-ZlSMVZA3lfkyjNN3QQGQapCjIUOIFE8MM%26redirect_uri%3Dhttp%253A%252F%252F10.10.16.56%252Flogin%252Foauth2%252Fcode%252Fcustom-self%26response_type%3Dcode%26client_name%3DCasOAuthClient&accept-language=zh-CN HTTP/1.1
Host: 10.10.16.56
Content-Length: 11094
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0
Origin: http://10.10.16.56
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Referer: http://10.10.16.56/pc/center?service=http:%2F%2F10.10.16.56%2Fcas-sso%2Foauth2.0%2FcallbackAuthorize%3Fclient_id%3DCerVBeNwjL3nexy3yD5ZmyZ5b1l023O-ZlSMVZA3lfkyjNN3QQGQapCjIUOIFE8MM%26redirect_uri%3Dhttp%253A%252F%252F10.10.16.56%252Flogin%252Foauth2%252Fcode%252Fcustom-self%26response_type%3Dcode%26client_name%3DCasOAuthClient
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6
Cookie: SESSION=cdaff4b7-ee7c-4efc-8d74-e00ed019550f; SESSION=1d52eb66-9fbb-4859-883d-1eeced1b5c3a
Connection: keep-alive

username=2508210211& \
type=UsernamePassword& \
_eventId=submit& \
` execution=cmVESENyTEZWX3A0R0x2aE1GTDJrVThnZEh4OE5nejRpZzdwS3YwVUx1Zi1faHBKVUIyMDlOSkExbGdn& ` \
captcha_code=& \
croypto=Kq%2BQa%2BP0ntM9kuU%2F52V6DQ%3D%3D& \
password=9%2BL9zNZ4fG3Di46nos9EmA%3D%3D& \
captcha_payload=c4%2FSYIBWbYXzUARyAyuN2A%3D%3D

---

## 认证

1. GET captive.apple.com

<script>
    top.self.location.href = 'http://10.10.16.56/eportal/index.jsp?wlanuserip=6bd9e97e7885a4e1b71725dd2871b390&wlanacname=4c0f0fef6b365fa3ed5af456db843eb9&ssid=&nasip=27902849584a1a3a980ee2fe3c675cf8&snmpagentip=&mac=83492bf34fc75b553f34441f1b4b6619&t=wireless-v2&url=601b2bbb95ce53e1ba26ebc96e6a3ccfb0f413d4f972ae02e446276b0bd24566&apmac=&nasid=4c0f0fef6b365fa3ed5af456db843eb9&vid=8be953436f077ade&port=2952ff85a4b7f39e&nasportid=fde5c7efbdfa07fbecbf2f859eaf7473a15c458ae70c8855292d5c49dfb5f305'
</script>

<HTML><HEAD><TITLE>Success</TITLE></HEAD><BODY>Success</BODY></HTML>

2. GET /eportal...

HTTP/1.1 302 \
Date: Sun, 08 Nov 2026 11:37:04 GMT \
Content-Length: 0 \
Connection: keep-alive \
P3P: CP="CAO PSA OUR" \
Allow: GET, HEAD, POST, PUT, DELETE, OPTIONS, PATCH \
Access-Control-Allow-Methods: POST,GET,PUT,OPTIONS,DELETE \
Access-Control-Allow-Credentials: true \
Access-Control-Max-Age: 3600 \
` Set-Cookie: JSESSIONID=F521EE309A21DCDE9802449684966599; Path=/eportal; HttpOnly ` \
- Location: http://10.10.16.56/portal/portal-main? **sessionId=0f1e6f986a2e** &**userIp=10.215.22.198&userMac=928b9128686c&nasIp=10.0.0.13**&**customPageId=06ffbb43ab13405d964d5a6c384b3d3d**& \
从这里切割字符串
redirectUrl=http://captive.apple.com/&samPortalRedirectUrl=http://123.123.123.123&clearIdentitySelect=true&waitMac=false&getIdentityEnable=false&terminalType=pc&accessTime=2026-11-08 19:37:04.384&guestFlow=false&terminalStatus=false 

3. GET portal-main

200 OK

4. 先GET获取cookie为登录做准备
 curl --url 'http://10.10.16.56/cas-sso/login?**flowSessionId=0f1e6f986a2e**&**customPageId=06ffbb43ab13405d964d5a6c384b3d3d**&preview=false&appType=normal&language=zh-CN&**timer=1794137831238**&nasIp=10.0.0.13&userIp=10.215.22.198&userMac=928b9128686c' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
  -H 'Connection: keep-alive' \
  -H 'Referer: http://10.10.16.56/portal/entry/pc/authenticate;flowParams=undefined;from=' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36' \
  --insecure

  HTTP/1.1 200
Date: Sun, 08 Nov 2026 11:37:08 GMT
Content-Type: text/html;charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Pragma: no-cache
- Set-Cookie: **SESSION=a357bcdb-1eef-4b8b-9b50-0ece84423784**; Path=/cas-sso/; HttpOnly \
Content-Language: zh-CN

5. POST url as same as top one (前面的set-cookie都是多余的?JSESSION)(serviceLogin有用处)
开始登陆
POST /cas-sso/login?flowSessionId=0f1e6f986a2e&customPageId=06ffbb43ab13405d964d5a6c384b3d3d&preview=false&appType=normal&language=zh-CN&timer=1794137831238&nasIp=10.0.0.13&userIp=10.215.22.198&userMac=928b9128686c&accept-language=zh-CN HTTP/1.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/jxl,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
Cache-Control: max-age=0
Connection: keep-alive
**Content-Length: 6990**
**Content-Type: application/x-www-form-urlencoded**
**Cookie: SESSION=a357bcdb-1eef-4b8b-9b50-0ece84423784**
Host: 10.10.16.56
Origin: http://10.10.16.56
Referer: http://10.10.16.56/pc/center?flowSessionId=0f1e6f986a2e&customPageId=06ffbb43ab13405d964d5a6c384b3d3d&preview=false&appType=normal&language=zh-CN&timer=1794137831238&nasIp=10.0.0.13&userIp=10.215.22.198&userMac=928b9128686c
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36

**HTTP/1.1 302** 不用跟随了
Date: Sun, 08 Nov 2026 11:37:26 GMT
Content-Length: 0
Connection: keep-alive
Pragma: no-cache
Set-Cookie: SOURCEID_TGC=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.ZXlKNmFYQWlPaUpFUlVZaUxDSmhiR2NpT2lKa2FYSWlMQ0psYm1NaU9pSkJNVEk0UTBKRExVaFRNalUySWl3aWRIbHdJam9pU2xkVUluMC4uak04cGwyZkNVWVZJNlhuejFma1RtUS55RlM1Y3FEM3hEdVlhSXF6VlI0bXF4V0NVLV91Tkl4LXJKZE56cHJaa3FrdWdLSlFSWGdfNndpTE5MbEc5RHNucnJmWjlqZ0Y3SDM4M25MU1Z3ekFfQXo0aHExY2lMRlNoTWFTc3lBajRFUDhMT0J6NjFiN2ZUUU9TQ013OEtZZ3pZVzMtY3pvX3RDWHpYUnZPazF2ZTVnVzhQZmtsSzNnU1pBXzRqaV9QcnVDMzRBWXpPS0lrdm55TGM4Yy13bkouX0lkSVNXTEtHYXhXVDdYb2hSVGhsdw==.-KhuZ7JS74miZV93R55wyBeXw-xvhRFfwpYN9Zncv_zEVxWvVF2O3UhJca4JQjKg2dljIMwKbAuNsqLq2A_QFA; Path=/cas-sso/; HttpOnly
Set-Cookie: rg_objectid=83d84fead9daa000c1aec5d67821712c5b979ffc9f85bdee1de1d686d818205920bcdb4bc7ef2319d51d9eae37d6b78a; HttpOnly
- Location: http://10.10.16.56/portal/assets/auth-success.html?ticket=ST-873576-DcXZ7hkfv-3zZFA2z7Id5bl8JlIrg-sso-native-6d44f5b8bb-wwlgb&i18n_lang=zh

6. 直接serviceLogin

  "body": "{**"sessionId":"0f1e6f986a2e"**,\"service\":\"电信宽带\"}",

POST /eportal/network/serviceLogin HTTP/1.1
Accept: application/json, text/plain, */*
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN
Connection: keep-alive
Content-Length: 53
**Content-Type: application/json**
**Cookie: JSESSIONID=F521EE309A21DCDE9802449684966599**
Host: 10.10.16.56
Origin: http://10.10.16.56
Referer: http://10.10.16.56/portal/entry/pc/serviceSelection;flowParams=undefined;from=authenticate;sid=false
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36
isPortal: true

HTTP/1.1 200
Date: Sun, 08 Nov 2026 11:37:29 GMT
Content-Type: application/json;charset=UTF-8
Content-Length: 111
Connection: keep-alive
P3P: CP="CAO PSA OUR"
Allow: GET, HEAD, POST, PUT, DELETE, OPTIONS, PATCH
Access-Control-Allow-Methods: POST,GET,PUT,OPTIONS,DELETE
Access-Control-Allow-Credentials: true
Access-Control-Max-Age: 3600
//登录成功设新的JSESSIONID
- Set-Cookie: **JSESSIONID=A975FD867C7F05CF19DE3D411FC57C0A; Path=/eportal;** HttpOnly
encrypted: false
{
  "code" : 200,
  "message" : null,
  "data" : {
    "authResult" : "success", //判断登录是否成功
    "authMessage" : null
  }
}

7. POST **/eportal**/network/userOnline HTTP/1.1
Accept: application/json, text/plain, */*
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN
Connection: keep-alive
**Content-Length: 28**
**Content-Type: application/json**
Cookie: JSESSIONID=A975FD867C7F05CF19DE3D411FC57C0A
Host: 10.10.16.56
Origin: http://10.10.16.56
Referer: http://10.10.16.56/portal/entry/pc/finish;flowParams=undefined;from=
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36
isPortal: true

{
  "sessionId": "0f1e6f986a2e" //利用sessionId查是否cookie是否可用
}

{
  "code" : 200,
  "message" : null,
  "data" : {
    "sessionId" : "0f1e6f986a2e",
    **"online" : true,** //t or f
    "userIndex" : "c538a73a46c14872b10e21d6f25e1719",
    "message" : null,
    "portalSuccessUrl" : "",
    "portalSuccessMode" : 0
  }
}