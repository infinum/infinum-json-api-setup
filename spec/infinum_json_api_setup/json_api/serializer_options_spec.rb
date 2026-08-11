# frozen_string_literal: true

describe InfinumJsonApiSetup::JsonApi::SerializerOptions do
  subject(:built_options) do
    described_class.new(
      params: params,
      pagination_details: pagination_details,
      extra_meta: extra_meta
    ).build
  end

  let(:params) { {} }
  let(:extra_meta) { nil }
  let(:pagination_details) do
    instance_double(
      Pagy,
      page: 1,
      pages: 2,
      count: 10,
      last: 2,
      prev: nil,
      next: 2,
      vars: { outset: 0, items: 20 }
    )
  end

  before do
    allow(Rails.application.routes.url_helpers).to receive(:url_for).and_return('http://example.com')
  end

  it 'includes pagination meta' do
    expect(built_options[:meta]).to include(
      current_page: 1,
      total_pages: 2,
      total_count: 10,
      padding: 0,
      page_size: 20,
      max_page_size: Pagy::DEFAULT[:max_items]
    )
  end

  context 'when extra meta is present' do
    let(:extra_meta) { { total_unread: 5 } }

    it 'merges extra meta into pagination meta' do
      expect(built_options[:meta]).to include(
        current_page: 1,
        total_unread: 5
      )
    end
  end

  context 'when extra meta is an empty hash' do
    let(:extra_meta) { {} }

    it 'keeps pagination meta' do
      expect(built_options[:meta]).to include(current_page: 1, total_pages: 2)
    end
  end

  context 'when pagination details are absent' do
    let(:pagination_details) { nil }
    let(:extra_meta) { { custom_count: 3 } }

    it 'returns only extra meta' do
      expect(built_options[:meta]).to eq(custom_count: 3)
    end
  end
end
