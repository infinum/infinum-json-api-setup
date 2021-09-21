describe InfinumJsonApiSetup::RSpec::Matchers::IncludeRelatedResource do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context 'when body includes related resource' do
      it 'matches' do
        response = response_with_body(JSON.dump(included: [{ type: 'user', id: '1' }]))

        expect(response).to include_related_resource('user', 1)
      end
    end

    context "when body doesn't include specified error detail" do
      it 'fails and describes failure reason' do
        response = response_with_body(JSON.dump(included: []))

        expect do
          expect(response).to include_related_resource('user', 1)
        end.to fail_with("Expected included items to include (type = user, id = 1), but didn't")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to include_related_resource('user', 1)
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to include_related_resource('user', 1)
        end.to fail_with('Failed to extract included from response body')
      end
    end
  end
end
