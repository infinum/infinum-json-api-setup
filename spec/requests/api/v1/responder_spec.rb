describe 'Responder', type: :request do
  context 'when GET request' do
    it 'responds with 200 OK' do
      get '/api/v1/locations', headers: default_headers

      expect(response).to have_http_status(:ok)
    end
  end

  context 'when POST request' do
    context 'without errors' do
      it 'responds with 201 Created' do
        params = { latitude: 1, longitude: 1 }

        post '/api/v1/locations', params: { location: params }.to_json, headers: default_headers

        expect(response).to have_http_status(:created)
      end
    end

    context 'with errors' do
      it 'responds with 400 BadRequest' do
        post '/api/v1/locations', params: {}, headers: default_headers

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  context 'when PUT request' do
    context 'without errors' do
      it 'responds with 200 OK' do
        location = create(:location, latitude: 1, longitude: 1)
        params = { latitude: 2 }

        put "/api/v1/locations/#{location.id}", params: { location: params }.to_json,
                                                headers: default_headers

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with errors' do
      it 'responds with 422 UnprocessableEntity' do
        location = create(:location, latitude: 1, longitude: 1)
        params = { latitude: 999 }

        put "/api/v1/locations/#{location.id}", params: { location: params }.to_json,
                                                headers: default_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'when PATCH request' do
    context 'without errors' do
      it 'responds with 200 OK' do
        location = create(:location, latitude: 1, longitude: 1)
        params = { latitude: 2 }

        patch "/api/v1/locations/#{location.id}", params: { location: params }.to_json,
                                                  headers: default_headers

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with errors' do
      it 'responds with 422 UnprocessableEntity' do
        location = create(:location, latitude: 1, longitude: 1)
        params = { latitude: 999 }

        patch "/api/v1/locations/#{location.id}", params: { location: params }.to_json,
                                                  headers: default_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'when DELETE request' do
    it 'responds with 204 NoContent' do
      location = create(:location, latitude: 1, longitude: 1)

      delete "/api/v1/locations/#{location.id}", headers: default_headers

      expect(response).to have_http_status(:no_content)
    end
  end
end
