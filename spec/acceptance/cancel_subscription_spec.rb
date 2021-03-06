require_relative 'acceptance_helper'

feature 'User can cancel subscription on question answers', %q{
  In order to information rules the world
  As an owner question
  I want to be able cancel subscription on answer for question
} do
  let(:user) { create :user }
  let(:question) { create :question }

  context 'guest user' do
    scenario 'could not cancel subscription' do
      visit question_path(question)
      expect(page).not_to have_link('cancel subscription')
    end
  end
  context 'authenticated user' do
    let(:subscription) { create(:subscription, question: question) }

    before do
      user.subscriptions << subscription
      sign_in(user)
    end
    scenario 'could cancel subscription if user already subscribed', js: true do
      visit question_path(question)
      click_link('cancel subscription')
      expect(page).not_to have_link('cancel subscription')
      expect(page).to have_button('subscribe')
      expect(page).not_to have_content('subscribed')
    end
  end
end