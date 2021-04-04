# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login page', type: :system do
  describe 'Login' do
    it 'Success' do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      expect(page).to have_content('Signed in successfully.')
    end
    it 'Fail' do
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
    it 'Homepage' do
      visit events_path

      expect(page).to have_selector(:link_or_button, 'Details')
      expect(page).to have_selector(:link_or_button, 'Event Check-in')

      expect(page).to have_content('Event Title')
      expect(page).to have_content('Event Place')
      expect(page).to have_content('Event Description')
      expect(page).to have_content('Start Time:')
      expect(page).to have_content('End Time:')
    end
    it 'Specific event' do
      visit events_path

      click_link('Details')
      expect(page).to have_selector(:link_or_button, 'Back to List')

      expect(page).to have_content('Event Title')
      expect(page).to have_content('Event Place')
      expect(page).to have_content('Event Description')
      expect(page).to have_content('Attendees:')
    end
    it 'Go back to home' do
      visit events_path

      click_link('Details')

      click_link('Back to List')
    end
  end
  describe 'View attendances' do
    it 'Submit from Participation page' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '666666666')
      fill_in('signin[first_name]', with: 'John')
      fill_in('signin[last_name]', with: 'Doe')
      fill_in('signin[email]', with: 'jdoe@example.com')

      click_button('commit')
      visit events_path
      click_link('Details')

      expect(page).to have_content('John')
      expect(page).to have_content('Doe')
    end
  end
end

RSpec.describe 'Participation Page', type: :system do
  describe 'Submit attendance' do
    it 'Visit page' do
      visit events_path
      click_link('Event Check-in')

      expect(page).to have_content('Password')
      expect(page).to have_content('UIN')
      expect(page).to have_content('First Name')
      expect(page).to have_content('Last Name')
      expect(page).to have_content('Email')
      expect(page).to have_selector(:link_or_button, 'Sign In')
    end
    it 'Successful Submit' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '666666666')
      fill_in('signin[first_name]', with: 'John')
      fill_in('signin[last_name]', with: 'Doe')
      fill_in('signin[email]', with: 'jdoe@example.com')

      click_button('commit')

      expect(page).to have_content('You have successfully signed into the event.')
    end
    it 'Failed Submit via Password' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '2')
      fill_in('signin[uin]', with: '666666666')
      fill_in('signin[first_name]', with: 'John')
      fill_in('signin[last_name]', with: 'Doe')
      fill_in('signin[email]', with: 'jdoe@example.com')

      click_button('commit')

      expect(page).to have_content('Incorrect password, please try again.')
    end
    it 'No such event error' do
      visit new_event_path(event_id: '300')

      expect(page).to have_content('Event Does Not Exist!')
    end
  end
  describe 'Input Validation Fail' do
    it 'Password' do
      visit events_path
      click_link('Event Check-in')

      click_button('commit')

      message = page.find('#event_pass').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'First Name' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '999999999')
      click_button('commit')

      message = page.find('#signin_first_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'Last Name' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '999999999')
      fill_in('signin[first_name]', with: 'Bob')
      click_button('commit')

      message = page.find('#signin_last_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
    it 'Email' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '999999999')
      fill_in('signin[first_name]', with: 'Bob')
      fill_in('signin[last_name]', with: 'Ross')
      click_button('commit')

      message = page.find('#signin_email').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
    end
  end
end

RSpec.describe 'Admin Create Event', type: :system do
  describe 'Create Event' do
    before do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      click_on 'Events'
      click_on 'New Event'
    end

    it 'Success Create Event' do
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
      visit new_event_path(event_id: eid)
      sleep(5)

      fill_in 'signin[email]', with: 'test@gmail.com'
      fill_in 'event_pass', with: '1128'
      fill_in 'signin[first_name]', with: 'test'
      fill_in 'signin[last_name]', with: 'guy'
      fill_in 'signin[uin]', with: '111111111'
      click_on 'commit'

      visit admin_event_path(id: eid)

      click_on 'Delete Event'
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content('Event was successfully destroyed.')
    end

    it 'Success Create Admin User' do
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('admin2@example.com')
    end
    it 'Create Admin User Blank fileds' do
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
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('is invalid')
    end

    it 'Create Admin User invalid password length' do
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'p'
      fill_in 'admin_user[password_confirmation]', with: 'p'
      click_on 'Create Admin user'
      expect(page).to have_content('is too short (minimum is 6 characters)')
    end

    it 'Create Admin User invalid password confirmation' do
      click_on 'Admin Users'
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password22'
      click_on 'Create Admin user'
      expect(page).to have_content("doesn't match Password")
    end

    it 'Admin User Page "Created At" Column ' do
      click_on 'Admin Users'
      click_on 'Created At'
      expect(page).to have_content('Admin Users')
    end
  end
end

RSpec.describe 'Home Page Date', type: :system do
  describe 'Input Date' do
    it 'Is older than 2 days' do
      event = Event.create!(title: 'Event in the Past', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2010-01-03 00:00:00', endtime: '2010-01-03 00:00:00',
                            eventpass: 'pass3', eventtype: 'General')
      event.save
      visit events_path
      expect(page).not_to have_content('Event in the Past')
      sleep(2)
      event.destroy
    end
    it 'Is in future more than 2 days' do
      event = Event.create!(title: 'Event in the Future', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2022-01-03 00:00:00', endtime: '2022-01-03 00:00:00',
                            eventpass: 'pass3', eventtype: 'General')
      event.save
      visit events_path
      expect(page).to have_content('Event in the Future')
      sleep(2)
      event.destroy
    end
  end
end

RSpec.describe 'User Event Sign in', type: :system do
  describe 'Sign in and update points' do
    it 'Registered user attempts to sign in without logging in' do
      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      fill_in 'signin[first_name]', with: 'test'
      fill_in 'signin[last_name]', with: 'guy'
      fill_in 'signin[uin]', with: '111111111'
      click_on 'commit'

      expect(page).to have_content('Please sign in to your account before checking in.')
    end

    it 'Registered user attempts to sign in after loggin in - Mentorship Meeting' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('4/5 Points')

      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      expect(page).to have_content('Signed in successfully.')

      visit '/admin/events/1'
      click_on 'Edit Event'
      select 'Mentorship Meeting', from: 'event[eventtype]'
      click_on 'commit'

      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have successfully signed into the event.')

      visit '/user_profile'

      expect(page).to have_content('Mentorship Meeting Points: 2')
      expect(page).to have_content('5/5 Points')
    end

    it 'Registered user attempts to sign in after loggin in - Social Meeting' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('4/5 Points')

      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      expect(page).to have_content('Signed in successfully.')

      visit '/admin/events/1'
      click_on 'Edit Event'
      select 'Social Meeting', from: 'event[eventtype]'
      click_on 'commit'

      visit events_path

      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have successfully signed into the event.')

      visit '/user_profile'

      expect(page).to have_content('Social Meeting Points: 2')
      expect(page).to have_content('5/5 Points')
    end

    it 'Registered user attempts to sign in after loggin in - Outreach Event' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('4/5 Points')

      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')

      click_button('Login')
      expect(page).to have_content('Signed in successfully.')

      visit '/admin/events/1'
      click_on 'Edit Event'
      select 'Outreach Event', from: 'event[eventtype]'
      click_on 'commit'

      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have successfully signed into the event.')

      visit '/user_profile'

      expect(page).to have_content('Outreach Points: 2')
      expect(page).to have_content('5/5 Points')
    end

    it 'Registered user attempts to sign in after loggin in - General Meeting' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('4/5 Points')

      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have successfully signed into the event.')

      visit '/user_profile'

      expect(page).to have_content('General Meeting Points: 2')
      expect(page).to have_content('5/5 Points')
    end

    it 'Registered user attempts to sign in after loggin in twice' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('4/5 Points')

      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have successfully signed into the event.')

      visit events_path
      click_on('Event Check-in')
      fill_in 'signin[email]', with: 'user@example.com'
      fill_in 'event_pass', with: '1'
      click_on 'commit'

      expect(page).to have_content('You have already signed into the event')
    end
  end
end

RSpec.describe 'Sign In Unit Tests', type: :system do
  describe 'Sign in Unit Tests' do
    it 'Sign in to social event' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 4, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1, outreach_points: 1)

      allow(user).to receive(:events).with(any_args).and_return(Array.new(0))
      allow(user).to receive(:update).with(any_args).and_return(user)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      event1 = instance_double('Event', title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                                        starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00',
                                        eventpass: 'pass2', eventtype: 'Social Meeting')
      allow(Event).to receive(:find).with(any_args).and_return(event1)
      allow(event1).to receive(:users).with(any_args).and_return(Array.new(0))
      allow(event1).to receive(:guests).with(any_args).and_return(Array.new(0))
      post '/events/new', params: { 'signin' => { 'event_id' => '100' }, 'event_pass' => 'pass2' }

      expect(response).to have_http_status(302)
    end

    it 'Sign in to mentorship event' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 4, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1, outreach_points: 1)

      allow(user).to receive(:events).with(any_args).and_return(Array.new(0))
      allow(user).to receive(:update).with(any_args).and_return(user)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      event1 = instance_double('Event', title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                                        starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00',
                                        eventpass: 'pass2', eventtype: 'Mentorship Meeting')
      allow(Event).to receive(:find).with(any_args).and_return(event1)
      allow(event1).to receive(:users).with(any_args).and_return(Array.new(0))
      allow(event1).to receive(:guests).with(any_args).and_return(Array.new(0))
      post '/events/new', params: { 'signin' => { 'event_id' => '100' }, 'event_pass' => 'pass2' }

      expect(response).to have_http_status(302)
    end

    it 'Sign in to General event' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 4, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1, outreach_points: 1)

      allow(user).to receive(:events).with(any_args).and_return(Array.new(0))
      allow(user).to receive(:update).with(any_args).and_return(user)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      event1 = instance_double('Event', title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                                        starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00',
                                        eventpass: 'pass2', eventtype: 'General Meeting')
      allow(Event).to receive(:find).with(any_args).and_return(event1)
      allow(event1).to receive(:users).with(any_args).and_return(Array.new(0))
      allow(event1).to receive(:guests).with(any_args).and_return(Array.new(0))
      post '/events/new', params: { 'signin' => { 'event_id' => '100' }, 'event_pass' => 'pass2' }

      expect(response).to have_http_status(302)
    end

    it 'Sign in to Outreach event' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 4, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1, outreach_points: 1)

      allow(user).to receive(:events).with(any_args).and_return(Array.new(0))
      allow(user).to receive(:update).with(any_args).and_return(user)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      event1 = instance_double('Event', title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                                        starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00',
                                        eventpass: 'pass2', eventtype: 'Outreach Event')
      allow(Event).to receive(:find).with(any_args).and_return(event1)
      allow(event1).to receive(:users).with(any_args).and_return(Array.new(0))
      allow(event1).to receive(:guests).with(any_args).and_return(Array.new(0))
      post '/events/new', params: { 'signin' => { 'event_id' => '100' }, 'event_pass' => 'pass2' }

      expect(response).to have_http_status(302)
    end

    it 'invalid sign in post request' do
      post '/events/new', params: { 'signin' => { 'event_id' => '100' } }

      expect(response).to have_http_status(302)
    end
  end
end
