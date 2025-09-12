describe InfinumJsonApiSetup::RSpec::Matchers::HaveEmptyData do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context 'when data is empty' do
      it 'matches' do
        response = response_with_body(JSON.dump(data: {}))

        expect(response).to have_empty_data
      end
    end

    context "when data isn't empty" do
      it 'fails and describes failure reason' do
        data = { 'a' => 1 }
        response = response_with_body(JSON.dump(data:))

        expect do
          expect(response).to have_empty_data
        end.to fail_with("Expected response data(#{data}) to be empty, but isn't")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to have_empty_data
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to have_empty_data
        end.to fail_with('Failed to extract data from response body')
      end
    end
  end
end
