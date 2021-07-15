describe 'Error handling', type: :request do
  context "when request doesn't contain required parameters" do
    it 'responds with 400 BadRequest' do
      post '/api/v1/locations', params: {}, headers: default_headers

      expect(response).to have_http_status(:bad_request)
      error = json_response['errors'].first
      expect(error['title']).to eq('Bad Request')
      expect(error['detail']).to match('param is missing or the value is empty: location')
    end
  end

  context "when ActiveRecord can't find requested record" do
    it 'responds with 404 NotFound' do
      get '/api/v1/locations/0', headers: default_headers

      expect(response).to have_http_status(:not_found)
      expect(json_response['errors'].first['title']).to eq('Not found')
      expect(json_response['errors'].first['detail']).to eq('Resource not found')
    end
  end

  context 'when client is not authorized to perform requested action' do
    it 'responds with 403 Forbidden' do
      loc = create(:location, :fourth_quadrant)
      get "/api/v1/locations/#{loc.id}", headers: default_headers

      expect(response).to have_http_status(:forbidden)
      expect(json_response['errors'].first['title']).to eq('Forbidden')
      expect(json_response['errors'].first['detail'])
        .to eq('You are not allowed to perform this action')
    end
  end

  context 'when request contains unpermitted sort params' do
    let(:bugsnag) { class_double('Bugsnag', notify: nil) }

    before do
      stub_const('Bugsnag', bugsnag)
    end

    it 'notifies Bugsnag about the incident' do
      get '/api/v1/locations?sort=-title', headers: default_headers

      expect(bugsnag).to have_received(:notify)
    end

    it 'responds with 400 BadRequest' do
      get '/api/v1/locations?sort=-title', headers: default_headers

      expect(response).to have_http_status(:bad_request)
      error = json_response['errors'].first
      expect(error['title']).to eq('Bad Request')
      expect(error['detail']).to eq('title is not a permitted sort attribute')
    end
  end

  context 'when action processing causes PG::Error' do
    let(:location_model) { class_double('Location') }
    let(:bugsnag) { class_double('Bugsnag', notify: nil) }

    before do
      stub_const('Bugsnag', bugsnag)
      stub_const('Location', location_model)
      allow(location_model).to receive(:find) { raise PG::Error }
    end

    it 'notifies Bugsnag about the incident' do
      get '/api/v1/locations/0', headers: default_headers

      expect(bugsnag).to have_received(:notify)
    end

    it 'responds with 500 InternalServerError' do
      get '/api/v1/locations/0', headers: default_headers

      expect(response).to have_http_status(:internal_server_error)
      expect(json_response['errors'].first['title']).to eq('Internal Server Error')
      expect(json_response['errors'].first['detail']).to eq('Something went wrong')
    end
  end

  context 'when client requests invalid locale' do
    it 'responds with 500 InternalServerError' do
      get '/api/v1/locations?locale=--', headers: default_headers

      expect(response).to have_http_status(:bad_request)
      expect(json_response['errors'].first['title']).to eq('Bad Request')
    end
  end

  context 'when client request contains unparsable params' do
    it 'responds with 400 BadRequest' do
      post '/api/v1/locations', params: '{', headers: default_headers

      expect(response).to have_http_status(:bad_request)
      expect(json_response['errors'].first['title']).to eq('Bad Request')
    end
  end
end
