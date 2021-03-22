# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'New Event Page', type: :system do
  describe 'Create Event' do
    before(:each) do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
    end

    it 'Single Event - Success' do
      visit '/admin/events'
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[starttime(1i)]', with: '2021')
      fill_in('event[starttime(2i)]', with: '3')
      fill_in('event[starttime(3i)]', with: '21')
      fill_in('event[starttime(4i)]', with: '10')
      fill_in('event[starttime(5i)]', with: '00')
      fill_in('event[endtime(1i)]', with: '2021')
      fill_in('event[endtime(2i)]', with: '3')
      fill_in('event[endtime(3i)]', with: '21')
      fill_in('event[endtime(4i)]', with: '11')
      fill_in('event[endtime(5i)]', with: '00')
      fill_in('event[eventpass]', with: 'Password')
      click_button('Non-Repeating Event')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('March 21, 2021')
    end

    it 'Repeating Event - Success' do
      visit '/admin/events'
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[starttime(1i)]', with: '2021')
      fill_in('event[starttime(2i)]', with: '3')
      fill_in('event[starttime(3i)]', with: '21')
      fill_in('event[starttime(4i)]', with: '10')
      fill_in('event[starttime(5i)]', with: '00')
      fill_in('event[endtime(1i)]', with: '2021')
      fill_in('event[endtime(2i)]', with: '3')
      fill_in('event[endtime(3i)]', with: '21')
      fill_in('event[endtime(4i)]', with: '11')
      fill_in('event[endtime(5i)]', with: '00')
      fill_in('event[eventpass]', with: 'Password')
      click_on('event[repeatmonday]', with: '1')
      click_on('event[repeattuesday]', with: '1')
      click_on('event[repeatwednesday]', with: '1')
      click_on('event[repeatthursday]', with: '1')
      click_on('event[repeatfriday]', with: '1')
      click_on('event[repeatsaturday]', with: '1')
      click_on('event[repeatsunday]', with: '1')
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('March 21, 2021')
      expect(page).to have_content('March 22, 2021')
      expect(page).to have_content('March 23, 2021')
      expect(page).to have_content('March 24, 2021')
      expect(page).to have_content('March 25, 2021')
      expect(page).to have_content('March 26, 2021')
      expect(page).to have_content('March 27, 2021')
      expect(page).to have_content('March 28, 2021')
    end

    it 'Single Event - Faliure' do
      visit '/admin/events'
      click_link('New Event')
      # fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[starttime(1i)]', with: '2021')
      fill_in('event[starttime(2i)]', with: '3')
      fill_in('event[starttime(3i)]', with: '21')
      fill_in('event[starttime(4i)]', with: '10')
      fill_in('event[starttime(5i)]', with: '00')
      fill_in('event[endtime(1i)]', with: '2021')
      fill_in('event[endtime(2i)]', with: '3')
      fill_in('event[endtime(3i)]', with: '21')
      fill_in('event[endtime(4i)]', with: '11')
      fill_in('event[endtime(5i)]', with: '00')
      fill_in('event[eventpass]', with: 'Password')
      click_button('Non-Repeating Event')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('March 21, 2021')
    end

    it 'Repeating Event - Faliure' do
      visit '/admin/events'
      click_link('New Event')
      # fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[starttime(1i)]', with: '2021')
      fill_in('event[starttime(2i)]', with: '3')
      fill_in('event[starttime(3i)]', with: '21')
      fill_in('event[starttime(4i)]', with: '10')
      fill_in('event[starttime(5i)]', with: '00')
      fill_in('event[endtime(1i)]', with: '2021')
      fill_in('event[endtime(2i)]', with: '3')
      fill_in('event[endtime(3i)]', with: '21')
      fill_in('event[endtime(4i)]', with: '11')
      fill_in('event[endtime(5i)]', with: '00')
      fill_in('event[eventpass]', with: 'Password')
      click_on('event[repeatmonday]', with: '1')
      click_on('event[repeattuesday]', with: '1')
      click_on('event[repeatwednesday]', with: '1')
      click_on('event[repeatthursday]', with: '1')
      click_on('event[repeatfriday]', with: '1')
      click_on('event[repeatsaturday]', with: '1')
      click_on('event[repeatsunday]', with: '1')
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('March 21, 2021')
      expect(page).to have_content('March 22, 2021')
      expect(page).to have_content('March 23, 2021')
      expect(page).to have_content('March 24, 2021')
      expect(page).to have_content('March 25, 2021')
      expect(page).to have_content('March 26, 2021')
      expect(page).to have_content('March 27, 2021')
      expect(page).to have_content('March 28, 2021')
    end
  end
end
