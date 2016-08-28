## GET /api/v1/faqs
Get list faq

### Example

#### Request
```
GET /api/v1/faqs HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 0
Content-Type: application/json
Host: www.example.com
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 116
Content-Type: application/json;charset=utf-8
ETag: W/"28ca44d0462bdb0ca40e9aa810c6f071"
X-Request-Id: b5760893-7068-410c-9a22-a8433311ca2e
X-Runtime: 0.048045

{
  "faqs": [
    {
      "id": 1,
      "question": "question 0",
      "answer": "answer 0"
    },
    {
      "id": 2,
      "question": "question 1",
      "answer": "answer 1"
    }
  ]
}
```
