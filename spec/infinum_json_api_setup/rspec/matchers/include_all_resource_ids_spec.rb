describe InfinumJsonApiSetup::RSpec::Matchers::IncludeAllResourceIds do
  describe 'usage' do
    context "when ID's match" do
      it 'matches' do
        response = response_with_ids([1, 2])

        expect(response).to include_all_resource_ids([1, 2])
      end

      it "doesn't consider ordering" do
        response = response_with_ids([1, 2, 3])

        expect(response).to include_all_resource_ids([3, 2, 1])
      end
    end

    context "when ID's don't match" do
      it 'fails and describes failure reason' do
        response = response_with_ids([1, 2, 3])

        expect do
          expect(response).to include_all_resource_ids([4])
        end.to fail_with("Expected response ID's([1, 2, 3]) to match [4]")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to include_all_resource_ids([1])
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to include_all_resource_ids([1])
        end.to fail_with('Failed to extract data from response body')
      end
    end
  end

  def response_with_ids(ids)
    response_with_body(JSON.dump(data: ids.map { |id| { 'id' => id } }))
  end

  def response_with_body(body)
    ActionDispatch::TestResponse.new(200, {}, body)
  end
end
