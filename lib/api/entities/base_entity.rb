module API::Entities
  class BaseEntity < Grape::Entity
    format_with(:integer) { |item| item.to_i }
    format_with(:string) { |item| item.to_s }
    format_with(:avatar) { |item| item.url }
  end
end
