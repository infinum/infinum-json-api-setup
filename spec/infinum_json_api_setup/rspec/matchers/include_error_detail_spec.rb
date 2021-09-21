describe InfinumJsonApiSetup::RSpec::Matchers::IncludeErrorDetail do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context 'when body includes error detail' do
      it 'matches' do
        response = response_with_body(JSON.dump(errors: [{ detail: 'a failure' }]))

        expect(response).to include_error_detail('a failure')
      end
    end

    context "when body doesn't include specified error detail" do
      it 'fails and describes failure reason' do
        response = response_with_body(JSON.dump(errors: []))

        expect do
          expect(response).to include_error_detail('a failure')
        end.to fail_with("Expected error details to include 'a failure', but didn't")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to include_error_detail('a failure')
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to include_error_detail('a failure')
        end.to fail_with('Failed to extract errors from response body')
      end
    end
  end
end
