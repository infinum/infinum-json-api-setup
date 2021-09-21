describe InfinumJsonApiSetup::RSpec::Matchers::HaveResourceCountOf do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context 'when data has correct number of items' do
      it 'matches' do
        response = response_with_body(JSON.dump(data: [1, 2]))

        expect(response).to have_resource_count_of(2)
      end
    end

    context 'when data has wrong number of items' do
      it 'fails and describes failure reason' do
        response = response_with_body(JSON.dump(data: [1, 2]))

        expect do
          expect(response).to have_resource_count_of(3)
        end.to fail_with('Expected response data to have 3 items, but had 2')
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to have_resource_count_of(1)
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to have_resource_count_of(1)
        end.to fail_with('Failed to extract data from response body')
      end
    end
  end
end
