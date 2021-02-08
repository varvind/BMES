# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login page', type: :system do
  describe 'Login' do
    it 'Success' do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      # sleep(2)
      click_button('Login')
      expect(page).to have_content('Signed in successfully.')
      # sleep(2)
    end
    it 'Fail' do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'p')
      # sleep(2)
      click_button('Login')
      expect(page).to have_content('Invalid Email or password.')
      # sleep(2)
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

      # sleep(2)
    end
    it 'Specific event' do
      visit events_path
      # sleep(2)
      click_link('Details')
      expect(page).to have_selector(:link_or_button, 'Back to List')

      # expect(page).to have_content('Show event')

      expect(page).to have_content('Event Title')
      expect(page).to have_content('Event Place')
      expect(page).to have_content('Event Description')
      expect(page).to have_content('Attendees:')
      # sleep(2)
    end
    it 'Go back to home' do
      visit events_path
      # sleep(2)
      click_link('Details')
      # sleep(2)
      click_link('Back to List')
      # sleep(2)
    end
  end
  describe 'View attendances' do
    it 'Submit from Participation page' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
      # sleep(2)

      click_button('commit')
      visit events_path
      click_link('Details')
      # expect(page).to have_content('666666666')
      expect(page).to have_content('John')
      expect(page).to have_content('Doe')
      expect(page).to have_content('jdoe@example.com')
      # sleep(2)
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
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
      # sleep(2)

      click_button('commit')
      # sleep(2)
      expect(page).to have_content('You have successfully signed into the event.')
      # sleep(2)
    end
    it 'Failed Submit via Password' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '2')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
      # sleep(2)

      click_button('commit')
      # sleep(2)
      expect(page).to have_content('Incorrect password, please try again.')
      # sleep(2)
    end
    it 'No such event error' do
      visit new_participation_path(event_id: '300')
      # participations/new?event_id=300
      # click_link('Sign in to event')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
      # sleep(2)

      click_button('commit')
      # sleep(2)
      expect(page).to have_content('No matching event found, please try again.')
      # sleep(2)
    end
  end
  describe 'Input Validation Fail' do
    it 'Password' do
      visit events_path
      click_link('Event Check-in')

      click_button('commit')

      message = page.find('#event_pass').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
      # sleep(2)
    end
    it 'First Name' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      click_button('commit')

      message = page.find('#participation_first_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
      # sleep(2)
    end
    it 'Last Name' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      fill_in('participation[first_name]', with: 'Bob')
      click_button('commit')

      message = page.find('#participation_last_name').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
      # sleep(2)
    end
    it 'Email' do
      visit events_path
      click_link('Event Check-in')

      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '999999999')
      fill_in('participation[first_name]', with: 'Bob')
      fill_in('participation[last_name]', with: 'Ross')
      click_button('commit')

      message = page.find('#participation_email').native.attribute('validationMessage')
      expect(message).to eq 'Please fill out this field.'
      # sleep(2)
    end
  end
end
# above is alex below is wang
RSpec.describe 'Admin Create Event', type: :system do
  describe 'Create Event' do
    before do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      # #sleep(2)
      click_button('Login')
      click_on 'Events'
      click_on 'New Event'
    end

    it 'Success Create Event' do
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      # sleep(4)
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

      fill_in 'Eventpass', with: '1128'

      click_on 'Create Event'
      # sleep(2)
      expect(page).to have_content('Event was successfully created.')
      # #sleep(2)
    end

    it 'Success Edit Event' do
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      # sleep(4)
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
      fill_in 'Eventpass', with: '1128'
      click_on 'Create Event'

      # edit
      click_on 'Edit Event'
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      # sleep(4)
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

      fill_in 'Eventpass', with: '11128'

      click_on 'Update Event'

      # sleep(2)
      expect(page).to have_content('Event was successfully updated.')
      # #sleep(2)
    end

    it 'Success Delete Event' do
      fill_in 'Title', with: 'title1'
      fill_in 'Place', with: 'place1'
      fill_in 'Description', with: 'des1'

      # sleep(4)
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

      fill_in 'Eventpass', with: '1128'

      click_on 'Create Event'
      click_on 'Delete Event'
      page.driver.browser.switch_to.alert.accept
      # sleep(2)
      expect(page).to have_content('Event was successfully destroyed.')
      # #sleep(2)
    end

    it 'Success Delete Event with participants' do
      fill_in 'Title', with: 'title2'
      fill_in 'Place', with: 'place2'
      fill_in 'Description', with: 'des2'

      # sleep(4)
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

      fill_in 'Eventpass', with: '1128'

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
      # sleep(2)
      expect(page).to have_content('Event was successfully destroyed.')
      # #sleep(2)
    end
    # it 'Success Add Comments' do
    #   fill_in 'Title', with: 'title1'
    #   fill_in 'Place', with: 'place1'
    #   fill_in 'Description', with: 'des1'

    #   # sleep(4)
    #   select '2015', from: 'event[starttime(1i)]'
    #   select 'November', from: 'event[starttime(2i)]'
    #   select '2', from: 'event[starttime(3i)]'
    #   select '10', from: 'event[starttime(4i)]'
    #   select '00', from: 'event[starttime(5i)]'

    #   select '2015', from: 'event[endtime(1i)]'
    #   select 'November', from: 'event[endtime(2i)]'
    #   select '2', from: 'event[endtime(3i)]'
    #   select '12', from: 'event[endtime(4i)]'
    #   select '00', from: 'event[endtime(5i)]'

    #   fill_in 'Eventpass', with: '1128'

    #   click_on 'Create Event'
    #   fill_in 'active_admin_comment[body]', with: 'comment1'
    #   click_on 'Add Comment'
    #   # sleep(2)
    #   expect(page).to have_content('Comment was successfully created.')
    #   # #sleep(2)
    # end

    # it 'Success Delete Comments' do
    #   fill_in 'Title', with: 'title1'
    #   fill_in 'Place', with: 'place1'
    #   fill_in 'Description', with: 'des1'

    #   # sleep(4)
    #   select '2015', from: 'event[starttime(1i)]'
    #   select 'November', from: 'event[starttime(2i)]'
    #   select '2', from: 'event[starttime(3i)]'
    #   select '10', from: 'event[starttime(4i)]'
    #   select '00', from: 'event[starttime(5i)]'

    #   select '2015', from: 'event[endtime(1i)]'
    #   select 'November', from: 'event[endtime(2i)]'
    #   select '2', from: 'event[endtime(3i)]'
    #   select '12', from: 'event[endtime(4i)]'
    #   select '00', from: 'event[endtime(5i)]'

    #   fill_in 'Eventpass', with: '1128'

    #   click_on 'Create Event'
    #   fill_in 'active_admin_comment[body]', with: 'comment1'
    #   click_on 'Add Comment'
    #   click_on 'Delete Comment'
    #   page.driver.browser.switch_to.alert.accept
    #   # sleep(2)
    #   expect(page).to have_content('Comment was successfully destroyed.')
    #   # #sleep(2)
    # end

    it 'Success Create Admin User' do
      click_on 'Admin Users'
      # sleep(2)
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('admin2@example.com')

      # sleep(2)
    end
    it 'Create Admin User Blank fileds' do
      click_on 'Admin Users'
      # sleep(2)
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
      # message = page.find('#participation_email').native.attribute('validationMessage')
      # expect(message).to eq 'Admin user was successfully created.'
      expect(page).to have_content('admin2@example.com')

      # sleep(2)
    end

    it 'Create Admin User invalid email' do
      click_on 'Admin Users'
      # sleep(2)
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password2'
      click_on 'Create Admin user'
      expect(page).to have_content('is invalid')

      # sleep(2)
    end

    it 'Create Admin User invalid password length' do
      click_on 'Admin Users'
      # sleep(2)
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'p'
      fill_in 'admin_user[password_confirmation]', with: 'p'
      click_on 'Create Admin user'
      expect(page).to have_content('is too short (minimum is 6 characters)')

      # sleep(2)
    end

    it 'Create Admin User invalid password confirmation' do
      click_on 'Admin Users'
      # sleep(2)
      click_on 'New Admin User'
      fill_in 'Email', with: 'admin2@example.com'
      fill_in 'admin_user[password]', with: 'password2'
      fill_in 'admin_user[password_confirmation]', with: 'password22'
      click_on 'Create Admin user'
      expect(page).to have_content("doesn't match Password")

      # sleep(2)
    end

    # it 'Success Delete Admin User' do
    #     click_on 'Admin Users'
    #     #sleep(2)
    #     click_on 'New Admin User'
    #     fill_in 'Email', with: "admin2@example.com"
    #     fill_in 'admin_user[password]', with: 'password2'
    #     fill_in 'admin_user[password_confirmation]', with: 'password2'
    #     click_on 'Create Admin user'
    #     click_on 'Admin Users'
    #     click_on
    #     expect(page).to have_content('Admin user was successfully destroyed.')

    #     #sleep(2)
    # end

    it 'Admin User Page "Created At" Column ' do
      click_on 'Admin Users'
      click_on 'Created At'
      expect(page).to have_content('Admin Users')

      # sleep(2)
    end
  end
end

RSpec.describe 'Home Page Date', type: :system do
  describe 'Input Date' do
    it 'Is older than 2 days' do
      event = Event.create!(title: 'Event in the Past', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2010-01-03 00:00:00', endtime: '2010-01-03 00:00:00', eventpass: 'pass3')
      event.save
      visit events_path
      expect(page).not_to have_content('Event in the Past')
      sleep(2)
      event.destroy
    end
    it 'Is in future more than 2 days' do
      event = Event.create!(title: 'Event in the Future', place: 'Zach 222', description: 'Not Saved',
                            starttime: '2021-01-03 00:00:00', endtime: '2021-01-03 00:00:00', eventpass: 'pass3')
      event.save
      visit events_path
      expect(page).to have_content('Event in the Future')
      sleep(2)
      event.destroy
    end
  end
end
