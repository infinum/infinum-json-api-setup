describe InfinumJsonApiSetup::RSpec::Matchers::IncludeAllResourceIdsSorted do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context "when ID's match" do
      it 'matches' do
        response = response_with_ids([1, 2])

        expect(response).to include_all_resource_ids_sorted([1, 2])
      end
    end

    context "when ID's don't match" do
      it 'fails and describes failure reason' do
        response = response_with_ids([1, 2, 3])

        expect do
          expect(response).to include_all_resource_ids_sorted([4])
        end.to fail_with("Expected response ID's([1, 2, 3]) to match [4]")
      end
    end

    context "when ID's aren't correctly ordered" do
      it 'fails and describes failure reason' do
        response = response_with_ids([2, 1])

        expect do
          expect(response).to include_all_resource_ids_sorted([1, 2])
        end.to fail_with("Expected response ID's([2, 1]) to match [1, 2]")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to include_all_resource_ids_sorted([1])
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to include_all_resource_ids_sorted([1])
        end.to fail_with('Failed to extract data from response body')
      end
    end
  end
end
