describe InfinumJsonApiSetup::Rspec::Helpers::ResponseHelper do
  include described_class

  let(:response) { instance_double('Response', body: JSON.dump(payload)) } # rubocop:disable RSpec/RSpec/VerifiedDoubleReference

  describe '#json_response' do
    let(:payload) do
      {
        data: {
          id: '1',
          type: 'locations',
          attributes: { name: 'Downtown HQ' }
        }
      }
    end

    it 'parses the response body with symbolized keys' do
      expect(json_response).to eq(payload)
    end
  end

  describe '#response_item' do
    context 'when the response contains a single resource' do
      let(:payload) do
        {
          data: {
            id: '1',
            type: 'locations',
            attributes: { name: 'Downtown HQ', city: 'Zagreb' }
          }
        }
      end

      it 'returns an OpenStruct built from the resource attributes' do
        expect(response_item).to have_attributes(name: 'Downtown HQ', city: 'Zagreb')
      end
    end

    context 'when the response contains a collection' do
      let(:payload) do
        {
          data: [
            { id: '1', type: 'locations', attributes: { name: 'Downtown HQ' } }
          ]
        }
      end

      it 'raises an informative error' do
        expect { response_item }.to raise_error('json response is not an item')
      end
    end
  end

  describe '#response_collection' do
    context 'when the response contains a collection' do
      let(:payload) do
        {
          data: [
            { id: '1', type: 'locations', attributes: { name: 'Downtown HQ' } },
            { id: '2', type: 'locations', attributes: { name: 'Suburb Office' } }
          ]
        }
      end

      it 'wraps each resource in an OpenStruct including id and type' do
        expect(response_collection).to contain_exactly(
          have_attributes(id: '1', type: 'locations', name: 'Downtown HQ'),
          have_attributes(id: '2', type: 'locations', name: 'Suburb Office')
        )
      end
    end

    context 'when the response contains a single resource' do
      let(:payload) do
        {
          data: {
            id: '1',
            type: 'locations',
            attributes: { name: 'Downtown HQ' }
          }
        }
      end

      it 'raises an informative error' do
        expect { response_collection }.to raise_error('json response is not a collection')
      end
    end
  end

  describe '#response_relationships' do
    context 'when the response contains a single resource' do
      let(:payload) do
        {
          data: {
            relationships: {
              label: { data: { id: '2', type: 'location_labels' } }
            }
          }
        }
      end

      it 'returns the relationships hash for the primary resource' do
        expect(response_relationships).to eq(payload[:data][:relationships])
      end
    end

    context 'when the response contains a collection' do
      let(:payload) do
        {
          data: [
            { relationships: { label: { data: { id: '2', type: 'location_labels' } } } },
            { relationships: { label: { data: { id: '3', type: 'location_labels' } } } }
          ]
        }
      end

      it 'returns the relationships for each resource' do
        expect(response_relationships(response_type: :collection)).to eq(
          payload[:data].pluck(:relationships)
        )
      end
    end

    context 'when an unsupported response type is requested' do
      let(:payload) do
        {
          data: {
            relationships: {
              label: { data: { id: '2', type: 'location_labels' } }
            }
          }
        }
      end

      it 'raises an argument error' do
        expect { response_relationships(response_type: :unknown) }
          .to raise_error(ArgumentError, ':response_type must be one of [:item, :collection]')
      end
    end
  end

  describe '#response_meta' do
    let(:payload) do
      {
        data: {},
        meta: { current_page: 2, total_pages: 5 }
      }
    end

    it 'returns the meta section of the response' do
      expect(response_meta).to eq(payload[:meta])
    end
  end

  describe '#response_included' do
    let(:payload) do
      {
        data: {},
        included: [
          {
            id: '2',
            type: 'location_labels',
            attributes: { name: 'HQ Label' }
          }
        ]
      }
    end

    it 'returns included resources as OpenStruct instances' do
      expect(response_included.first).to have_attributes(id: '2', type: 'location_labels', name: 'HQ Label')
    end
  end

  describe '#response_included_relationship' do
    context 'when the relationship exists in the included section' do
      let(:payload) do
        {
          data: {
            relationships: {
              label: { data: { id: '2', type: 'location_labels' } }
            }
          },
          included: [
            {
              id: '2',
              type: 'location_labels',
              attributes: { name: 'HQ Label' }
            }
          ]
        }
      end

      it 'returns the matching included resource' do
        result = response_included_relationship(:label)

        expect(result).to have_attributes(id: '2', type: 'location_labels', name: 'HQ Label')
      end
    end

    context 'when the relationship data is nil' do
      let(:payload) do
        {
          data: {
            relationships: {
              label: { data: nil }
            }
          },
          included: []
        }
      end

      it 'returns nil' do
        expect(response_included_relationship(:label)).to be_nil
      end
    end

    context 'when no matching included resource is present' do
      let(:payload) do
        {
          data: {
            relationships: {
              label: { data: { id: '99', type: 'location_labels' } }
            }
          },
          included: []
        }
      end

      it 'returns nil' do
        expect(response_included_relationship(:label)).to be_nil
      end
    end
  end
end
