module API::Entities
  class BaseEntity < Grape::Entity
    format_with(:integer) { |int| int.to_i }
    format_with(:string) { |int| int.to_s }
  end
end
