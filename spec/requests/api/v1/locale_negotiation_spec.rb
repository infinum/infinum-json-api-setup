describe 'Locale negotiation' do
  describe 'with localized content' do
    it 'returns English hello message when Accept-Language is en' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'en')

      expect(response).to have_http_status(:ok)

      expect(json_response['data']['attributes']['message']).to eq('Hello world')
    end

    it 'returns German hello message when Accept-Language is de' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'de')

      expect(response).to have_http_status(:ok)

      expect(json_response['data']['attributes']['message']).to eq('Hallo Welt')
    end

    it 'returns German hello message when Accept-Language is de-DE (region variant)' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'de-DE')

      expect(response).to have_http_status(:ok)

      expect(json_response['data']['attributes']['message']).to eq('Hallo Welt')
    end

    it 'returns default English message when no Accept-Language header provided' do
      get '/api/v1/hello', headers: default_headers

      expect(response).to have_http_status(:ok)

      expect(json_response['data']['attributes']['message']).to eq('Hello world')
    end

    it 'prioritizes first valid locale from complex Accept-Language header' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'de-DE,de;q=0.9,en;q=0.8')

      expect(response).to have_http_status(:ok)

      expect(json_response['data']['attributes']['message']).to eq('Hallo Welt')
    end

    it 'falls back to default locale when Accept-Language header is malformed' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': '123-invalid')

      expect(response).to have_http_status(:ok)

      response_body = JSON.parse(response.body)
      expect(response_body['data']['attributes']['message']).to eq('Hello world')
    end
  end

  describe 'error handling with localized messages' do
    it 'responds with 400 Bad Request and English error message for invalid locale' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'fr')

      expect(response).to have_http_status(:bad_request)
      expect(response).to include_error_detail('"fr" is not a valid locale')
    end
  end
end
