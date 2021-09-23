RSpec::Matchers.define :include_related_resource do |type, id|
  match do |response|
    body = JSON.parse(response.body)
    body['included'].one? do |resource|
      resource['type'] == type && resource['id'].to_i == id
    end
  end
end

RSpec::Matchers.define :have_error_pointer do |pointer|
  match do |response|
    body = JSON.parse(response.body)
    body['errors'].any? { |error| error['source']['pointer'] == pointer }
  end
end
