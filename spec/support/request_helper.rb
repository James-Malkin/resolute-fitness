# frozen_string_literal: true

shared_examples 'successful response' do
  it { expect(response).to have_http_status(:ok) }
end

shared_examples 'turbo stream response' do
  it 'returns a turbo stream response' do
    expect(response.media_type).to eq Mime[:turbo_stream]
  end
end
