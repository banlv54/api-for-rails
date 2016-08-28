Chắc hẳn các bạn đã sử viết api cho rails rất nhiều lần rồi, và không ít người trong đó sử dụng gem `grape` để viết. Khi đó nhiều người hay sử dụng Serializer để cấu trúc response trả ra, mình thấy sử dụng Serializer thì khó có thể xác định được mình trả ra những gì khi đọc code. Hơn nữa nó lại không thể linh hoạt được xử lý đồng thời với những kiểu dữ liệu đặc thù được.
Ở đây, mình giới thiệu thêm cho các bạn một gem khác đó chính là `grape-entity` để định nghĩa cấu trúc response của một api. Sử dụng gem này rất là đơn giản, và nó hầu như có thể xử lý được tất cả các tình huống mà bạn cần.

Hơn nữa, khi sử dụng gem `grape` để viết api. Thì các bạn nên sử dụng gem `doorkeeper` để authorize bới vì nó cũng được tích hợp sẵn với grape chứ không cần phải viết lại.

Ngoài ra, khi viết api chính là một service cung cấp cho client mà việc đặc tả nó thì là một việc rất cần thiết. Việc này mà viết bằng tay thì rất là mất thời gian hơn nữa có thể không chính xác. Mình cũng đề xuất thêm gem `autodoc-grape`. Đây là một gem có thể tự động sinh ra file document cho các bạn khi các bạn viết test cho api đó. Nó sẽ mô phỏng lại request và response của bạn như thế nào.

Bộ 4 gem này là đầy đủ để cho các bạn có thể viết api cho server của bạn một cách nhanh chóng, dễ hiệu và linh hoạt nhất.
```
gem 'grape'
gem 'grape-entity'
gem 'autodoc-grape'
gem 'doorkeeper'
```

Việc sử dụng hay hoạt động của gem grape mình sẽ không đề cập cụ thể chi tiết nữa. Mà mình đi vào chi tiết 3 gem còn lại.

Lưu ý: Khi sử dụng gem grape để viết api với các thứ tiếng như Nhật, Việt Nam, Trung Quốc ... những ngôn ngữ có các thể loại encode khác nhau thì các bạn nên ép ngay kiểu trả về là `utf-8` để tránh trường hợp bị lỗi font khi trả về.
Hãy cài đặt đó là default với tất cả các API.
VD:

```
class API::BaseAPI < Grape::API
  format :json
  content_type :json, "application/json;charset=utf-8"

  mount API::V1::BaseAPI
  mount API::V1::BaseAuthenticateAPI
end
```


## I) Gem 'doorkeeper'
Link github: [doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)

Đây chính là một gem viết ra để thực hiện authenticate cho cả web lần api. Chính vì vậy mà nó rất hay được dùng đối với một server yêu cầu cả 2 dịch vụ trên.

Ở đây mình chỉ đề cập tới việc login đối với user. Và cách mà chúng ta hay sử dụng nhất chính là việc gửi email và password lên để login hay lấy access_token.

Để chuẩn bị cho việc login thì đương nhiên là chúng ta phải có bảng user, và một phương thức để `authenticate` đối tượng với email và password. Việc này ta có thể sử dụng gem `devise` hoặc là gem `sorcery`. Ở đây mình dùng gem `sorcery` để demo.
 Khi bundle xong thì chúng ta chạy các lệnh sau để chuẩn bị database:
 ```
rails generate sorcery:install
rails generate doorkeeper:install
rake db:migrate
```

Sau đó, ta config lại `resource_owner_from_credentials` trong file `config/initializes/doorkeeper.rb` để sử dụng `authenticate` của gem `sorcery` (các bạn hoàn toàn có thể thay thế bằng phương thức của gem devise)
```
Doorkeeper.configure do
  # Change the ORM that doorkeeper will use (needs plugins)
  orm :active_record

  resource_owner_from_credentials do
    User.authenticate(params[:email], params[:password])
  end
end
Doorkeeper.configuration.token_grant_types << "password"
```
Ở trên ta phải thêm `password` vào config `token_grant_types` của Doorkeeper để có thể login bằng password mà ko cần sử dụng `authorization_code` (chi tiết tại [api-endpoint](https://github.com/doorkeeper-gem/doorkeeper/wiki/API-endpoint-descriptions-and-examplesdoorkeeper)

Vậy là đã xong bước chuẩn bị. Khi login thì chúng ta sử dụng api sau để lấy access_token:


```
curl -F grant_type=password \
-F email=test@gmail.com \
-F password=11111111 \
-X POST http://localhost:3000/oauth/token
```

Như trên ta thấy được request ở đây là method `POST` với url `/oauth/token` và các params truyền lên là
- `grant_type=password` giá trị bằng `password` là bắt buộc
- email
- password
```
{"access_token":"f9fbdec2b5e15d7feddd0f57ef53c3faa80385385e11275ec4977f247aa83521","token_type":"bearer","expires_in":7200,"created_at":1472399786}
```


Đã có token để authorize rồi. Vậy viết api như thế nào để sử dụng authorize của doorkeper đây.

Vâng, nó cũng rất là đơn giản. Vì `doorkeeper` cũng đã cung cấp sẵn cho `grape` rồi.

```ruby
require 'doorkeeper/grape/helpers'

class API::V1::BaseAuthenticateAPI < Grape::API
  version 'v1'

  helpers Doorkeeper::Grape::Helpers

  before do
    doorkeeper_authorize!
  end

  mount API::V1::UsersAPI
end
```

Nhìn vào nội dung này hẳn các bạn thấy cú pháp quen chứ ạ?
1. Thêm `require 'doorkeeper/grape/helpers'`
2. Thêm `helpers Doorkeeper::Grape::Helpers`
3. Thêm `doorkeeper_authorize!` vào `before do`

=> Tất cả các api trong `API::V1::UsersAPI` sẽ đều phải đi qua authorize trước khi thực hiện các bước tiếp theo. Nó khá giống với `before_action :authenticate_user!` của devise đúng không.

Sự khác nhau ở đây chính là. Khi sử dụng web để truy cập vào các controller thì trình duyệt sử dụng session để nhận biết được user đó. Còn api thì sử dụng access_token mà client gửi lên.

Để truy cập vào các api trong user thì khi request ta phải gửi thêm `Authorization: Bearer token` và trong header.

Ví dụ
```
curl -X GET http://localhost:3000/api/v1/users -H "Authorization: Bearer f9fbdec2b5e15d7feddd0f57ef53c3faa80385385e11275ec4977f247aa83521"
```

## II) Gem 'grape-entity'
Link [grap-entity](https://github.com/ruby-grape/grape-entity)

Khi sử dụng grape-entity thì nó cũng khác giống với `grape-active_model_serializers`, cũng có kế thừa, cũng có định nghĩa các trường phải trả ra trong response.

Nhưng điểm khác biệt ở đây chính là `grape-entity` có option format_with đối với mỗi trường.
Ví dụ:
```ruby
module API
  module Entities
    class User < Grape::Entity
      format_with(:iso_timestamp) { |dt| dt.iso8601 }

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end

      expose :deleted_at, format_with: :iso_timestamp
    end
  end
end
```
Như các bạn thấy, ta có thể định nghĩa một format bất kỳ trong entity và sử dụng nó với tất cả các trường khác. Việc này khá là linh hoạt. Nhất là đối với các dữ liệu `nil` trong databse. Việc response trả ra string `null` trong response sẽ khiến cho client hay gặp các lỗi khi build object. Kiểu integer, float, hay string cũng đều trả ra `null` sẽ khiến cho việc ép kiểu của client bị lỗi. Chính vì vậy, sử dụng format với các trường dữ liệu mà không require là thực sự hữu ích và cần thiết.

Chúng ta có thể định nghĩa các format này ở trong class base của entity (tự tạo ra) sau đó các class con kế thứa class base này sẽ dùng được.

VD:
```
module API::Entities
  class BaseEntity < Grape::Entity
    format_with(:integer) { |int| int.to_i }
    format_with(:string) { |int| int.to_s }
  end
end
```
```
module API::Entities::Users
  class Index < API::Entities::BaseEntity
    expose :id
    expose :age, format_with: :integer
  end
end
```
```
module API::Entities::Faqs
  class Index < API::Entities::BaseEntity
    expose :id
    expose :question, format_with: :string
    expose :answer, format_with: :string
  end
end
```
=> các dữ liệu nil sẽ bị convert thành 0 hoặc '' với các kiểu dữ liệu integer hoặc string khi sử dụng với format.

Hơn nữa, khi nhìn file entity này ta có thể biết được trường đó trả về dữ liệu là kiểu nào. Nó khá là rõ ràng, minh bạch.

Với gem [grape-entity](https://github.com/ruby-grape/grape-entity) có khá nhiều cách sử dụng. Các bạn tham khảo thêm tại đó nhé.

## III) Gem 'autodoc-grape'
Khi chúng ta viết spec thì có khá là nhiều gem hỗ trợ để tạo ra doc cho chúng. Nhưng với grape thì ta có gem `autodoc-grape`.
Sử đụng gem này khá là đơn giản. Ta chỉ việc thêm `autodoc: true` vào chính test case mà bạn muốn sinh document từ đó là song.

Nhưng nó cũng có một nhược điểm là: Ngay cả khi bạn đã định nghĩa params trên user thì bạn vẫn phải định nghĩa lại nó ở trong `params do end` của mỗi api. Nếu không khi genrenate ra document no sẽ bị lỗi.

VD:
```
route_param :id do
      params do
        requires :id, type: Integer
      end

      get do
        present User.find(params[:id]), with: API::Entities::Users::Index
      end
    end
```

Dưới đây là ví dụ mình viết rspec cho api và genrate ra document của nó:

File spec:
```
require "rails_helper"

describe API::V1::UsersAPI, type: :request do
  let(:json) {JSON.parse(response.body)}
  let(:user) { User.create email: "email@gmail.com"}
  let(:access_token) { Doorkeeper::AccessToken.create(resource_owner_id: user.id).token }

  describe "GET /api/v1/users" do
    let(:path) { "/api/v1/users" }

    context "authorize", autodoc: true do
      let(:description) { "Get list user with authorize" }

      before do
        2.times do |n|
          User.create email: "email-#{n}@gmail.com", age: n
        end

        get(path, {}, "CONTENT_TYPE" => "application/json",
            "Authorization" => "Bearer #{access_token}")
      end

      it { expect(json["users"].count).to eq 3 }
    end

    context "unauthorize" do
      let(:description) { "Get list user unauthorize" }

      before do
        2.times do |n|
          User.create email: "email-#{n}@gmail.com", age: n
        end

        get(path, {}, "CONTENT_TYPE" => "application/json",
            "Authorization" => "Bearer xxx")
      end

      it { expect(json["error"]).to eq "The access token is invalid" }
    end
  end
end
```

Khi chạy spec thì thêm AUTODOC=1 vào để genrate ra document nếu bạn muốn
```
AUTODOC=1 rspec spec/lib/api/v1/users_api_spec.rb
```
=> Kết quả như dưới




## GET /api/v1/users
Get list user with authorize

### Example

#### Request
```
GET /api/v1/users HTTP/1.1
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Authorization: Bearer 22bd5ce86f5043a3a6f2655ed6956b6aee4cb670d1a67f8d50dec46f98710321
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
X-Request-Id: 4c75ee97-e0e1-4796-bccb-9a886ce53b6e
X-Runtime: 0.052645

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


