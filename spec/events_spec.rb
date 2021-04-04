# frozen_string_literal: true

require 'rails_helper'

# tests test out New Event Page
RSpec.describe 'New Event Page', type: :system do
  describe 'Create Event' do
    # this process will happen everytime a test begins
    before(:each) do
      # go to log in page, fill in the info, then Login
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
    end

    # tests to see if JSON downloads properly
    it 'Download JSON - Success' do
      visit '/admin/events' # go to the events page
      click_on('JSON')
      # JSON file should have Title on page
      expect(page).to have_content('Title')
    end

    # tests to see if an event's details page loads properly
    it 'View Event (Details) - Success' do
      travel_to Time.zone.local(2025, 3, 13, 0o1, 0o4, 44)
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')

      visit events_path # go to the event's path
      click_on('Details')
      # Details of the event should be on page
      expect(page).to have_content('Test_Title')
    end

    # tests to see if an event's view page loads properly
    it 'View Event (View) - Success' do
      visit '/admin/events/1' # go to the event's page
      # Details of the event should be on page
      expect(page).to have_content('Event Title')
    end

    # tests whether creating a single event will succeed
    it 'Single Event - Success' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this date
      expect(page).to have_content('March 21, 2025')
    end

    # tests whether creating multiple events will succeed
    it 'Repeating Event - Success' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have events from March 21 to March 28, 2025
      expect(page).to have_content('March 21, 2025 10:00')
      expect(page).to have_content('March 22, 2025 10:00')
      expect(page).to have_content('March 23, 2025 10:00')
      expect(page).to have_content('March 24, 2025 10:00')
      expect(page).to have_content('March 25, 2025 10:00')
      expect(page).to have_content('March 26, 2025 10:00')
      expect(page).to have_content('March 27, 2025 10:00')
      expect(page).to have_content('March 28, 2025 10:00')
    end

    # tests whether or not app will detect an invalid single event with missing all fields
    it 'Single Event (Missing All Fields) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      # missing all fields
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing all fields
      expect(page).to have_content('Error: Please Enter Values in All Fields.')
    end

    # tests whether or not app will detect an invalid single event with missing title
    it 'Single Event (Missing Title) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      # missing title
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing a title
      expect(page).to have_content('Error: Please Enter an Event Title.')
    end

    # tests whether or not app will detect an invalid single event with missing place
    it 'Single Event (Missing Place) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      # missing place
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing a place
      expect(page).to have_content('Error: Please Enter an Event Place.')
    end

    # tests whether or not app will detect an invalid single event with missing description
    it 'Single Event (Missing Description) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      # missing description
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing a description
      expect(page).to have_content('Error: Please Enter an Event Description.')
    end

    # tests whether or not app will detect an invalid single event with missing password
    it 'Single Event (Missing Password) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      # missing password
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing a password
      expect(page).to have_content('Error: Please Enter an Event Password.')
    end

    # tests whether or not app will detect an invalid single event with missing starttime
    it 'Single Event (Missing Starttime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[eventpass]', with: 'Password')
      # missing starttime
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('10', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing starttime
      expect(page).to have_content('Error: Invalid Date Entry.')
    end

    # tests whether or not app will detect an invalid single event with missing starttime
    it 'Single Event (Missing Endtime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[eventpass]', with: 'Password')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      # missing endtime
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because the event is missing endtime
      expect(page).to have_content('Error: Invalid Date Entry.')
    end

    # tests to see if endtime is before starttime
    it 'Single Event (Endtime < Starttime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('20', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because an event needs their endtime > starttime
      expect(page).to have_content('Error: End Time is earlier than Start Time.')
    end

    # tests to see if starttime is in the past
    it 'Single Event (Starttime in the Past) - Failure' do
      travel_to Time.zone.local(2025, 2, 13, 0o1, 0o4, 44)
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2023', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('20', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      # make sure the event is not repeating
      click_button('Non-Repeating Event')
      click_on('commit')
      # page should have this error because events cannot be created in the past
      expect(page).to have_content('Error: Start Time cannot be in the past.')
    end

    # tests whether or not app will detect an invalid repeating event with missing all fields
    it 'Repeating Event (Missing All Fields) - Failure' do
      travel_to Time.zone.local(2025, 3, 13, 0o1, 0o4, 44)
      visit '/admin/events' # go to the events page
      click_link('New Event')
      # missing all fields
      click_on('commit')
      # page should have this error because the event is missing all fields
      expect(page).to have_content('Error: Please Enter Values in All Fields.')
    end

    # tests whether or not app will detect invalid repeating events with missing title
    it 'Repeating Event (Missing Title) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      # missing title
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because event needs a title
      expect(page).to have_content('Error: Please Enter an Event Title.')
    end

    # tests whether or not app will detect invalid repeating events with missing place
    it 'Repeating Event (Missing Place) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      # missing place
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because event needs a place
      expect(page).to have_content('Error: Please Enter an Event Place.')
    end

    # tests whether or not app will detect invalid repeating events with missing description
    it 'Repeating Event (Missing Description) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      # missing description
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because event needs a description
      expect(page).to have_content('Error: Please Enter an Event Description.')
    end

    # tests whether or not app will detect invalid repeating events with missing password
    it 'Repeating Event (Missing Password) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      # missing password
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because event needs a password
      expect(page).to have_content('Error: Please Enter an Event Password.')
    end

    # tests whether or not app will detect invalid repeating events with missing starttime
    it 'Repeating Event (Missing Starttime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[eventpass]', with: 'Password')
      # missing starttime
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('10', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because the event is missing starttime
      expect(page).to have_content('Error: Invalid Date Entry.')
    end

    # tests whether or not app will detect invalid repeating events with missing endtime
    it 'Repeating Event (Missing Endtime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      fill_in('event[eventpass]', with: 'Password')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      # missing endtime
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because the event is missing endtime
      expect(page).to have_content('Error: Invalid Date Entry.')
    end

    # tests whether or not app will detect invalid repeating events with missing weeks value
    it 'Repeating Event (Missing Weeks Value) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # missing weeks value
      click_on('commit')
      # page should have this error because the event is missing endtime
      expect(page).to have_content('Error: Weeks cannot be zero/negative for repeat events.')
    end

    # tests to see if endtime is before starttime for repeating events
    it 'Repeating Event (Endtime < Starttime) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('20', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because an event needs their endtime > starttime
      expect(page).to have_content('Error: End Time is earlier than Start Time.')
    end

    # tests to see if starttime is in the past for repeating events
    it 'Repeating Event (Starttime in the Past) - Failure' do
      travel_to Time.zone.local(2025, 2, 13, 0o1, 0o4, 44)
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2023', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('20', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because events cannot be created in the past
      expect(page).to have_content('Error: Start Time cannot be in the past.')
    end

    # tests to see if app detects invalid weeks value (0) for repeating events
    it 'Repeating Event (Weeks = 0) - Failure' do
      travel_to Time.zone.local(2025, 3, 13, 0o1, 0o4, 44)
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # invalid weeks value: weeks = 0
      fill_in('event[repeatweeks]', with: '0')
      click_on('commit')
      # page should have this error because weeks != 0 or negative number
      expect(page).to have_content('Error: Weeks cannot be zero/negative for repeat events.')
    end

    # tests to see if app detects invalid weeks value (-1) for repeating events
    it 'Repeating Event (Weeks = -1) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeatmonday') # event will repeat on mondays
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatwednesday') # event will repeat on wednesdays
      check('event_repeatthursday') # event will repeat on thursdays
      check('event_repeatfriday') # event will repeat on fridays
      check('event_repeatsaturday') # event will repeat on saturdays
      check('event_repeatsunday') # event will repeat on sundays
      # invalid weeks value: weeks = -1
      fill_in('event[repeatweeks]', with: '-1')
      click_on('commit')
      # page should have this error because weeks != 0 or negative number
      expect(page).to have_content('Error: Weeks cannot be zero/negative for repeat events.')
    end

    # tests whether or not app will detect invalid date for repeating events
    it 'Repeating Event (Weekday not part of Repeating Process) - Failure' do
      visit '/admin/events' # go to the events page
      click_link('New Event')
      fill_in('event[title]', with: 'Test_Title')
      fill_in('event[place]', with: 'Test_Place')
      fill_in('event[description]', with: 'Test_Description')
      select('2025', from: 'event[starttime(1i)]') # starttime year
      select('March', from: 'event[starttime(2i)]') # starttime month
      select('21', from: 'event[starttime(3i)]') # starttime day
      select('10', from: 'event[starttime(4i)]') # starttime hour
      select('00', from: 'event[starttime(5i)]') # starttime minute
      select('2025', from: 'event[endtime(1i)]') # endtime year
      select('March', from: 'event[endtime(2i)]') # endtime month
      select('21', from: 'event[endtime(3i)]') # endtime day
      select('11', from: 'event[endtime(4i)]') # endtime hour
      select('00', from: 'event[endtime(5i)]') # endtime minute
      fill_in('event[eventpass]', with: 'Password')
      check('event_repeattuesday') # event will repeat on tuesdays
      check('event_repeatthursday') # event will repeat on thursdays
      # event will repeat for one week
      fill_in('event[repeatweeks]', with: '1')
      click_on('commit')
      # page should have this error because event starts on a weekday that is not a part of repeating process
      expect(page).to have_content('Error: Weekday not a part of Repeating Process.')
    end
  end
end
