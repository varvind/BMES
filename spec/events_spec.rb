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
      select('2021', from: 'event[starttime(1i)]')
      select('March', from: 'event[starttime(2i)]')
      select('21', from: 'event[starttime(3i)]')
      select('10', from: 'event[starttime(4i)]')
      select('00', from: 'event[starttime(5i)]')
      select('2021', from: 'event[endtime(1i)]')
      select('March', from: 'event[endtime(2i)]')
      select('21', from: 'event[endtime(3i)]')
      select('11', from: 'event[endtime(4i)]')
      select('00', from: 'event[endtime(5i)]')
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
      select('2021', from: 'event[starttime(1i)]')
      select('March', from: 'event[starttime(2i)]')
      select('21', from: 'event[starttime(3i)]')
      select('10', from: 'event[starttime(4i)]')
      select('00', from: 'event[starttime(5i)]')
      select('2021', from: 'event[endtime(1i)]')
      select('March', from: 'event[endtime(2i)]')
      select('21', from: 'event[endtime(3i)]')
      select('11', from: 'event[endtime(4i)]')
      select('00', from: 'event[endtime(5i)]')
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday')
      check('event_repeattuesday')
      check('event_repeatwednesday')
      check('event_repeatthursday')
      check('event_repeatfriday')
      check('event_repeatsaturday')
      check('event_repeatsunday')
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('March 21, 2021')
      expect(page).to have_content('March 28, 2021')
      expect(page).to have_content('March 29, 2021')
      expect(page).to have_content('March 30, 2021')
      expect(page).to have_content('March 31, 2021')
      expect(page).to have_content('April 01, 2021')
      expect(page).to have_content('April 02, 2021')
      expect(page).to have_content('April 03, 2021')
    end

    it 'Single Event - Faliure' do
      visit '/admin/events'
      click_link('New Event')
      # fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2021', from: 'event[starttime(1i)]')
      select('March', from: 'event[starttime(2i)]')
      select('21', from: 'event[starttime(3i)]')
      select('10', from: 'event[starttime(4i)]')
      select('00', from: 'event[starttime(5i)]')
      select('2021', from: 'event[endtime(1i)]')
      select('March', from: 'event[endtime(2i)]')
      select('21', from: 'event[endtime(3i)]')
      select('11', from: 'event[endtime(4i)]')
      select('00', from: 'event[endtime(5i)]')
      fill_in('event[eventpass]', with: 'Password')
      click_button('Non-Repeating Event')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('Error.')
    end

    it 'Repeating Event - Faliure' do
      visit '/admin/events'
      click_link('New Event')
      # fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2021', from: 'event[starttime(1i)]')
      select('March', from: 'event[starttime(2i)]')
      select('21', from: 'event[starttime(3i)]')
      select('10', from: 'event[starttime(4i)]')
      select('00', from: 'event[starttime(5i)]')
      select('2021', from: 'event[endtime(1i)]')
      select('March', from: 'event[endtime(2i)]')
      select('21', from: 'event[endtime(3i)]')
      select('11', from: 'event[endtime(4i)]')
      select('00', from: 'event[endtime(5i)]')
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday')
      check('event_repeattuesday')
      check('event_repeatwednesday')
      check('event_repeatthursday')
      check('event_repeatfriday')
      check('event_repeatsaturday')
      check('event_repeatsunday')
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      sleep(5)
      expect(page).to have_content('Error.')
    end

    it 'View Event - Success' do
      visit '/admin/events'
      page.execute_script("$('#col col-actions').trigger('mouseenter')")
      sleep(5)
      click_on('View')
      sleep(5)
      expect(page).to have_content('Title')
    end

    it 'Download JSON - Success' do
      visit '/admin/events'
      click_on('JSON')
      sleep(5)
      expect(page).to have_content('Title')
    end
  end
end
