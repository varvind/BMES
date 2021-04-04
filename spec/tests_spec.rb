# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login page', type: :system do
  describe 'Login' do
    it 'Success' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      expect(page).to have_content('Signed in successfully.')
    end
    it 'Fail' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'p')

      click_button('Login')
      expect(page).to have_content('Invalid Email or password.')
    end
  end
end

RSpec.describe 'Event page', type: :system do
  describe 'Visit Events' do
    before do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
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
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'

      click_on 'Create Event'
    end
    it 'Homepage' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path

      expect(page).to have_selector(:link_or_button, 'Details')
      expect(page).to have_selector(:link_or_button, 'Check-in')

      # expect(page).to have_content('Event Title')
      # expect(page).to have_content('Event Place')
      # expect(page).to have_content('Event Description')
      # expect(page).to have_content('Start Time:')
      # expect(page).to have_content('End Time:')
    end
    it 'Specific event' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path

      click_link('Details')
      expect(page).to have_selector(:link_or_button, 'Back to List')

      expect(page).to have_content('title1')
      expect(page).to have_content('place1')
      expect(page).to have_content('des1')
      expect(page).to have_content('Attendees:')
    end
    it 'Go back to home' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path

      click_link('Details')

      click_link('Back to List')
    end
  end
  describe 'View attendances' do
    before do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
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
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1'

      click_on 'Create Event'
    end
    it 'Submit from Participation page' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')

      click_button('commit')
      visit events_path
      click_link('Details')
      expect(page).to have_content('John')
      expect(page).to have_content('Doe')
      expect(page).to have_content('jdoe@example.com')
    end
  end
end

RSpec.describe 'Participation Page', type: :system do
  describe 'Submit attendance' do
    before do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
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
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1'

      click_on 'Create Event'
    end
    it 'Visit page' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      expect(page).to have_content('Password')
      expect(page).to have_content('UIN')
      expect(page).to have_content('First Name')
      expect(page).to have_content('Last Name')
      expect(page).to have_content('Email')
      expect(page).to have_selector(:link_or_button, 'Sign In')
    end
    it 'Successful Submit' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')

      click_button('commit')

      expect(page).to have_content('You have successfully signed into the event.')
    end
    it 'Failed Submit via Password' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '2')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')

      click_button('commit')

      expect(page).to have_content('Incorrect password, please try again.')
    end
    it 'No such event error' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit new_participation_path(event_id: '300')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')

      click_button('commit')

      expect(page).to have_content('No matching event found, please try again.')
    end
  end
  describe 'Input Validation Fail' do
    before do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
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
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1'

      click_on 'Create Event'
    end
    it 'Password' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      click_button('commit')

      message = page.find('#event_pass').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'First Name' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      click_button('commit')

      message = page.find('#participation_first_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'Last Name' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      fill_in('participation[first_name]', with: 'Bob')
      click_button('commit')

      message = page.find('#participation_last_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'Email' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit events_path
      click_link('Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      fill_in('participation[first_name]', with: 'Bob')
      fill_in('participation[last_name]', with: 'Ross')
      click_button('commit')

      message = page.find('#participation_email').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
  end
end

RSpec.describe 'Admin Create Event', type: :system do
  describe 'Create Event' do
    before do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      click_on 'Events'
      click_on 'New Event'
    end

    it 'Success Create Event' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'

      click_on 'Create Event'

      expect(page).to have_content('Event was successfully created.')
    end

    it 'Success Edit Event' do
      travel_to Time.zone.local(2020, 11, 1, 0o1, 0o4, 44)
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'
      fill_in 'Event Password', with: '1128'
      click_on 'Create Event'
      visit '/admin/events/1'
      click_on 'Edit Event'
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2020', from: 'event[starttime(1i)]'
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2020', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '11128'

      click_on 'Update Event'

      expect(page).to have_content('Event was successfully updated.')
    end

    it 'Success Delete Event' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      select '2025', from: 'event[starttime(1i)]'
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'

      click_on 'Create Event'
      visit '/admin/events/1'
      click_on 'Delete Event'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content('Event was successfully destroyed.')
    end

    it 'Success Delete Event with participants' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place2'
      fill_in 'Description', with: 'des2'

      select '2025', from: 'event[starttime(1i)]'
      select 'November', from: 'event[starttime(2i)]'
      select '2', from: 'event[starttime(3i)]'
      select '10', from: 'event[starttime(4i)]'
      select '00', from: 'event[starttime(5i)]'

      select '2025', from: 'event[endtime(1i)]'
      select 'November', from: 'event[endtime(2i)]'
      select '2', from: 'event[endtime(3i)]'
      select '12', from: 'event[endtime(4i)]'
      select '00', from: 'event[endtime(5i)]'

      fill_in 'Event Password', with: '1128'

      click_on 'Create Event'
      sleep(5)
      eid = Event.maximum(:id)
      visit new_participation_path(event_id: eid)
      sleep(5)

      fill_in 'participation[email]', with: 'test@gmail.com'
      fill_in 'event_pass', with: '1128'
      fill_in 'participation[first_name]', with: 'test'
      fill_in 'participation[last_name]', with: 'guy'
      fill_in 'participation[uin]', with: '111111111'
      click_on 'commit'

      visit admin_event_path(id: eid)

      click_on 'Delete Event'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content('Event was successfully destroyed.')
    end

    it 'Success Create Admin User' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('admin2@example.com')
    end
    it 'Create Admin User Blank fileds' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'New Admin User'
      click_on 'Create Admin user'
      expect(page).to have_content("can't be blank")
      sleep(1)
      fill_in 'Email', with: 'admin2@example.com'
      click_on 'Create Admin user'
      expect(page).to have_content("can't be blank")
      sleep(1)
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('admin2@example.com')
    end

    it 'Create Admin User invalid email' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('is invalid')
    end

    it 'Create Admin User invalid password length' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'p'
      fill_in 'admin_user[password_confirmation]', with: 'p'
      click_on 'Create Admin user'
      expect(page).to have_content('is too short (minimum is 6 characters)')
    end

    it 'Create Admin User invalid password confirmation' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password22'
      click_on 'Create Admin user'
      expect(page).to have_content("doesn't match Password")
    end

    it 'Admin User Page "Created At" Column ' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      click_on 'Admin Users'
      click_on 'Created At'
      expect(page).to have_content('Admin Users')
    end
  end
end

RSpec.describe 'Home Page Date', type: :system do
  describe 'Input Date' do
    it 'Is older than 2 days' do
      travel_to Time.zone.local(2025, 11, 1, 0o1, 0o4, 44)
      event = Event.create!(title: 'Event in the Past', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2010-01-03 00:00:00', endtime: '2010-01-03 00:00:00', eventpass: 'pass3')
      event.save
      visit events_path
      expect(page).not_to have_content('Event in the Past')
      sleep(2)
      event.destroy
    end
    it 'Is in future more than 2 days' do
      travel_to Time.zone.local(2022, 1, 1, 0o1, 0o4, 44)
      event = Event.create!(title: 'Event in the Future', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2022-01-03 00:00:00', endtime: '2022-01-03 00:00:00', eventpass: 'pass3')
      event.save
      visit events_path
      expect(page).to have_content('Event in the Future')
      sleep(2)
      event.destroy
    end
  end
end
