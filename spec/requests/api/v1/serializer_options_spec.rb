require 'cgi'
require 'uri'

describe 'Serializer options', type: :request do
  it 'adds meta with pagination information' do # rubocop:disable RSpec/MultipleExpectations
    get '/api/v1/locations', params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    expect(json_response).to have_key('meta')
    meta = json_response['meta']
    expect(meta).to have_key('current_page')
    expect(meta).to have_key('total_pages')
    expect(meta).to have_key('total_count')
    expect(meta).to have_key('padding')
    expect(meta).to have_key('page_size')
    expect(meta).to have_key('max_page_size')
  end

  it 'adds links' do
    get '/api/v1/locations', params: {}, headers: default_headers

    expect(response).to have_http_status(:ok)
    expect(json_response).to have_key('links')
    links = json_response['links']
    expect(links).to have_key('self')
    expect(links).to have_key('first')
    expect(links).to have_key('last')
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
