# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard Page', type: :system do
  describe 'Check' do
    before(:each) do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
    end

    it 'for capitalization' do
      visit '/admin/dashboard'
      expect(page).to have_content('BMES')
    end

    it 'for text' do
      visit '/admin/dashboard'
      expect(page).to have_content('Welcome to the BMES Officer Area!')
      expect(page).to have_content('Our organization is committed to Advancing Human Health and Well Being')
      # rubocop:disable Layout/LineLength
      expect(page).to have_content('To get started, select the \'Events\' tab from the Navigation Bar to create a new event, or select \'Participations\' to view member sign ins!')
      # rubocop:enable Layout/LineLength
    end
  end
end
