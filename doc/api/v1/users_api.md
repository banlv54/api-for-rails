## GET /api/v1/users
Get list user with authorize

### Example

#### Request
```
GET /api/v1/users HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Authorization: Bearer b1503e66e0bc692740873ecad8f4cdfe8a42ea70c84a85709c1cbd91b8fff68b
Content-Length: 0
Content-Type: application/json
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 62
Content-Type: application/json;charset=utf-8
ETag: W/"d4f6afed0d8b5919760c40ab465dbeeb"
X-Request-Id: ad7c16df-f889-42e1-8293-9d02958038f4
X-Runtime: 0.057252

{
  "users": [
    {
      "id": 1,
      "age": 0
    },
    {
      "id": 2,
      "age": 1
    },
    {
      "id": 3,
      "age": 0
    }
  ]
}
```
