describe InfinumJsonApiSetup::RSpec::Matchers::HaveErrorPointer do
  include TestHelpers::Matchers::Response

  describe 'usage' do
    context 'when body includes error pointer' do
      it 'matches' do
        response = response_with_body(JSON.dump(errors: [{ source: { pointer: 'name' } }]))

        expect(response).to have_error_pointer('name')
      end
    end

    context "when body doesn't include specified error detail" do
      it 'fails and describes failure reason' do
        response = response_with_body(JSON.dump(errors: []))

        expect do
          expect(response).to have_error_pointer('name')
        end.to fail_with("Expected error pointers to include 'name', but didn't")
      end
    end

    context "when response isn't valid JSON" do
      it 'fails and describes failure reason' do
        response = response_with_body('')

        expect do
          expect(response).to have_error_pointer('name')
        end.to fail_with('Failed to parse response body')
      end
    end

    context "when response doesn't contain data attribute" do
      it 'fails and describes failure reason' do
        response = response_with_body('{}')

        expect do
          expect(response).to have_error_pointer('name')
        end.to fail_with('Failed to extract errors from response body')
      end
    end
  end
end
