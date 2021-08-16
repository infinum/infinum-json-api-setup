RSpec::Matchers.define :include_all_resource_string_ids do |params|
  match do |response|
    body = JSON.parse(response.body)
    resource_ids = body['data'].map { |resource| resource['id'] }
    params.sort == resource_ids.sort
  end
end

RSpec::Matchers.define :include_all_resource_ids_sorted do |params|
  match do |response|
    body = JSON.parse(response.body)
    resource_ids = body['data'].map { |resource| resource['id'].to_i }
    resource_ids == params
  end
end

RSpec::Matchers.define :include_related_resource do |type, id|
  match do |response|
    body = JSON.parse(response.body)
    body['included'].one? do |resource|
      resource['type'] == type && resource['id'].to_i == id
    end
  end
end

RSpec::Matchers.define :have_empty_data do
  match do |response|
    body = JSON.parse(response.body)
    body['data'].empty?
  end
end

RSpec::Matchers.define :have_resource_count_of do |count|
  match do |response|
    body = JSON.parse(response.body)
    body['data'].count == count
  end
end

RSpec::Matchers.define :include_error_text do |error_detail|
  match do |response|
    body = JSON.parse(response.body)
    body['errors'].any? { |error| error['detail'].include?(error_detail) }
  end
end

RSpec::Matchers.define :have_error_pointer do |pointer|
  match do |response|
    body = JSON.parse(response.body)
    body['errors'].any? { |error| error['source']['pointer'] == pointer }
  end
end
