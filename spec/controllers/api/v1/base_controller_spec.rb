describe Api::V1::BaseController do
  it 'sets responder' do
    expect(described_class.responder).to eq(InfinumJsonApiSetup::JsonApi::Responder)
  end

  it 'sets respond_to' do
    expect(described_class.respond_to).to have_key(:json_api)
  end
end
