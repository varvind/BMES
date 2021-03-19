# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Create New Event', type: :system do
  describe 'Create User' do
    it 'rw' do
      travel_to Time.zone.local(2020, 3, 13, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('commit')
      click_on 'Events'
      click_on 'New Event'

      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2021', from: 'event[starttime(1i)]'
      select 'March', from: 'event[starttime(2i)]'
      select '22', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2021', from: 'event[endtime(1i)]'
      select 'March', from: 'event[endtime(2i)]'
      select '22', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Eventpass', with: '1128'

      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')

      travel_to Time.zone.local(2021, 3, 13, 0o1, 0o4, 44)
      visit '/'
      expect(page).to have_css '.simple-calendar'
      sleep(5)
      expect(page).to have_content('title1', count: 2)
      sleep(10)
    end
  end
end
