describe 'Content negotiation', type: :request do
  it 'passes through requests demanding JSON:API compliant response' do
    get '/api/v1/locations', headers: { accept: 'application/vnd.api+json' }

    expect(response).to have_http_status(:ok)
  end

  it 'responds with 406 NotAcceptable to requests demanding non JSON:API compliant reponse' do
    get '/api/v1/locations', headers: { accept: 'application/json' }

    expect(response).to have_http_status(:not_acceptable)
  end

  it 'responds with 415 UnsupportedMediaType to requests containing non JSON:API compliant body' do
    post '/api/v1/locations', params: { user: { name: 'Harry' } },
                              headers: { accept: 'application/vnd.api+json',
                                         'content-type': 'application/x-www-form-urlencoded' }

    expect(response).to have_http_status(:unsupported_media_type)
  end

  it 'skips Content-Type check when request has empty body' do
    get '/api/v1/locations', params: { user: { name: 'Harry' } },
                             headers: { accept: 'application/vnd.api+json',
                                        'content-type': 'application/x-www-form-urlencoded' }

    expect(response).to have_http_status(:ok)
  end
end
