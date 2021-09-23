RSpec::Matchers.define :include_related_resource do |type, id|
  match do |response|
    body = JSON.parse(response.body)
    body['included'].one? do |resource|
      resource['type'] == type && resource['id'].to_i == id
    end
  end
end
