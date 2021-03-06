# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create New Event', type: :system do
  describe 'Create event' do
    it 'test am event' do
      travel_to Time.zone.local(2020, 3, 13, 1, 0, 0)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')

      travel_to Time.zone.local(2025, 4, 1, 9, 50, 0)
      visit '/'
      expect(page).to have_css '.simple-calendar'

      expect(page).to have_content('title1')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title1')

      click_on 'Back to List'

      click_on 'Check-in'
    end

    it 'test am event (early) - failure' do
      travel_to Time.zone.local(2020, 3, 13, 1, 0, 0)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')

      travel_to Time.zone.local(2025, 4, 1, 9, 39, 0o0)
      visit '/'
      expect(page).to have_css '.simple-calendar'

      expect(page).to have_content('title1')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title1')

      click_on 'Back to List'

      expect(page).to_not have_link('Check-in')
    end

    it 'test am event (late) - failure' do
      travel_to Time.zone.local(2020, 3, 13, 1, 0, 0)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')

      travel_to Time.zone.local(2025, 4, 1, 12, 0o1, 0o0)
      visit '/'
      expect(page).to have_css '.simple-calendar'

      expect(page).to have_content('title1')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title1')

      click_on 'Back to List'

      expect(page).to_not have_link('Check-in')
    end

    it 'test pm event' do
      # set local time to mar 13th, 2020
      travel_to Time.zone.local(2020, 3, 13, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '18', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '19', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
      # set local time to mar 13th, 2021
      travel_to Time.zone.local(2025, 4, 1, 17, 50, 0o0)
      visit '/'
      expect(page).to have_css '.simple-calendar'
      expect(page).to have_content('title2')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title2')

      click_on 'Back to List'

      click_on 'Check-in'
    end

    it 'test pm event (early) - failure' do
      # set local time to mar 13th, 2020
      travel_to Time.zone.local(2020, 3, 13, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '18', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '19', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
      # set local time to mar 13th, 2021
      travel_to Time.zone.local(2025, 4, 1, 17, 49, 0o0)
      visit '/'
      expect(page).to have_css '.simple-calendar'
      expect(page).to have_content('title2')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title2')

      click_on 'Back to List'

      expect(page).to_not have_link('Check-in')
    end

    it 'test pm event (late) - failure' do
      # set local time to mar 13th, 2020
      travel_to Time.zone.local(2020, 3, 13, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '18', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '19', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
      # set local time to mar 13th, 2021
      travel_to Time.zone.local(2025, 4, 1, 19, 0o1, 0o0)
      visit '/'
      expect(page).to have_css '.simple-calendar'
      expect(page).to have_content('title2')

      within('.simple-calendar') do
        click_on('Details')
      end

      expect(page).to have_content('title2')

      click_on 'Back to List'

      expect(page).to_not have_link('Check-in')
    end

    it 'test event check in (calendar) - failure' do
      # set local time to April 1st, 2025
      travel_to Time.zone.local(2025, 4, 1, 17, 59, 0)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '18', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '19', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
      visit '/'
      travel_to Time.zone.local(2025, 4, 1, 19, 0o1, 0o0)
      expect(page).to have_css '.simple-calendar'
      expect(page).to have_content('title2')

      within('.simple-calendar') do
        click_on('Check-in')
      end

      expect(page).to have_content('Can not check into Event earlier than 20 minutes or after Event endtime.')
    end

    it 'test event check in (url) - failure' do
      # set local time to April 1st, 2025
      travel_to Time.zone.local(2025, 4, 1, 17, 59, 0)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'April', from: 'event[starttime(2i)]'
      select '1', from: 'event[starttime(3i)]'
      select '18', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'April', from: 'event[endtime(2i)]'
      select '1', from: 'event[endtime(3i)]'
      select '19', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'
      click_on 'Non-Repeating Event'
      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
      visit '/'
      travel_to Time.zone.local(2025, 4, 1, 19, 0o1, 0o0)
      expect(page).to have_css '.simple-calendar'
      expect(page).to have_content('title2')

      eid = Event.maximum(:id)
      visit new_event_path(event_id: eid)
      expect(page).to have_content('Can not check into Event earlier than 20 minutes or after Event endtime.')
    end
  end
end
