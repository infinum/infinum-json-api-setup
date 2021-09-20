describe InfinumJsonApiSetup::RSpec::Matchers::IncludeAllResourceStringIds do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context "when ID's match" do
      it 'matches' do
        response = response_with_ids(['1', '2'])

        expect(response).to include_all_resource_string_ids(['1', '2'])
      end

      it "doesn't consider ordering" do
        response = response_with_ids(['1', '2', '3'])

        expect(response).to include_all_resource_string_ids(['3', '2', '1'])
      end
    end

    context "when ID's don't match" do
      it 'fails and describes failure reason' do
        response = response_with_ids(['1', '2', '3'])

        expect do
          expect(response).to include_all_resource_string_ids(['4'])
        end.to fail_with('Expected response ID\'s(["1", "2", "3"]) to match ["4"]')
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to include_all_resource_string_ids(['1'])
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to include_all_resource_string_ids(['1'])
        end.to fail_with('Failed to extract data from response body')
      end
    end
  end
end
