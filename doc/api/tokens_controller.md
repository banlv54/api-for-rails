## POST '/oauth/token'
Login success

### Example

#### Request
```
POST /oauth/token HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 71
Content-Type: application/x-www-form-urlencoded
Host: www.example.com
X-App-Secret: Ct-7_CEqO37l-3ViExTZsg

password=&email=&grant_type=password&device_id=5e1478961dbdbe721033872a
```

#### Response
```
HTTP/1.1 200
Cache-Control: no-store
Content-Length: 129
Content-Type: application/json; charset=utf-8
ETag: W/"ba0e54d5472bfa83a0ef5cc1c1ee9ab3"
Pragma: no-cache
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Request-Id: af6144f6-f456-4baf-946c-f89893add3ee
X-Runtime: 0.019394
X-XSS-Protection: 1; mode=block

{
  "access_token": "7cc27fda63e68603c0d7e5fcabf9ad02948f9191788787c7a2071c506801ffdf",
  "token_type": "bearer",
  "created_at": 1496044730
}
```
