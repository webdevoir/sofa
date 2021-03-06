require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(5) }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should accept_nested_attributes_for :attachments }

  let(:question) { create(:question) }
  let(:user) { create(:user) }

  let(:model) { question }
  it_behaves_like 'Voting'
end
