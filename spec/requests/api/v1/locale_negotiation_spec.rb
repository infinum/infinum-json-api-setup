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
  end

  describe 'error handling' do
    it 'responds with 400 Bad Request when Accept-Language header is malformed' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': '123-invalid')

      expect(response).to have_http_status(:bad_request)
      expect(response).to include_error_detail('Invalid locale')
    end

    it 'responds with 400 Bad Request and error message for invalid locale' do
      get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'fr')

      expect(response).to have_http_status(:bad_request)
      expect(response).to include_error_detail('Invalid locale')
    end

    context 'when fallback to default is enabled' do
      around do |example|
        Api::V1::HelloController.fallback_to_default_locale_if_invalid = true
        example.run
        Api::V1::HelloController.fallback_to_default_locale_if_invalid = false
      end

      it 'responds with 200 OK and default locale body' do
        get '/api/v1/hello', headers: default_headers.merge('Accept-Language': 'fr')

        expect(response).to have_http_status(:ok)
        expect(json_response['data']['attributes']['message']).to eq('Hello world')
      end
    end
  end
end
