require 'cgi'
require 'uri'

describe 'Serializer options', type: :request do
  it 'adds meta with pagination information' do
    get '/api/v1/locations', params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    expect(json_response).to have_key('meta')
    expect(json_response['meta'].keys).to include(
      'current_page', 'total_pages', 'total_count', 'padding', 'page_size', 'max_page_size'
    )
  end

  it 'adds links' do
    get '/api/v1/locations', params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    expect(json_response).to have_key('links')
    expect(json_response['links'].keys).to include('self', 'first', 'last')
  end

  it 'adds client requested fields information to links' do
    q = { fields: { locations: 'latitude' } }
    get "/api/v1/locations?#{q.to_query}", params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    self_link = json_response.dig('links', 'self')
    expect(parse_query(self_link)).to have_key('fields[locations]')
  end

  it 'adds client requested include information to links' do
    q = { include: 'labels' }
    get "/api/v1/locations?#{q.to_query}", params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    self_link = json_response.dig('links', 'self')
    expect(parse_query(self_link)).to have_key('include')
  end

  private

  def parse_query(link)
    CGI.parse(URI(link).query)
  end
end
