# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event page', type: :system do
  describe 'Check Urls' do
    it 'View event with different url ids' do
      # set local time to jan 2nd, 2025
      travel_to Time.zone.local(2025, 1, 2, 9, 40, 00)
      puts Time.zone.local(2025, 1, 2, 9, 40, 00)
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 10:00:00', endtime: '2025-01-02 11:00:00',
                             eventpass: 'pass2', eventtype: 'General Meeting')
      event1.save
      # event2.save
      visit events_path

      path1 = "//a[@href='/events/new?event_id=" + event1.id.to_s + "']"
      find(:xpath, path1)

      sleep(2)
      event1.destroy
    end
    it 'Visit event with different url ids' do
      # set local time to jan 1st, 2025
      travel_to Time.zone.local(2025, 1, 2, 9, 40, 00)
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 10:00:00', endtime: '2025-01-02 12:00:00',
                             eventpass: 'pass2', eventtype: 'General Meeting')
      # event2 = Event.create!(title: 'Event Test 2', place: 'Zach 222', description: 'Not Saved',
      #                        starttime: '2025-01-03 00:00:00', endtime: '2025-01-03 00:00:00',
      #                        eventpass: 'pass3', eventtype: 'General Meeting')
      event1.save
      # event2.save
      visit events_path

      path1 = "//a[@href='/events/new?event_id=" + event1.id.to_s + "']"
      # path2 = "//a[@href='/events/new?event_id=" + event2.id.to_s + "']"
      find(:xpath, path1).click
      sleep(2)
      click_link('Back to List')
      sleep(2)
      # find(:xpath, path2).click
      # click_link('Back to List')

      sleep(2)
      event1.destroy
      # event2.destroy
    end
  end
end

RSpec.describe 'Participation Page', type: :system do
  describe 'Has Url' do
    it 'Checks the url parameters' do
      # set local time to jan 1st, 2025
      travel_to Time.zone.local(2024, 12, 31, 23, 40, 0)
      visit events_path
      click_link('Check-in')
      # expect(page).to have_current_path(new_participation_path(event_id: '1'))
      sleep(2)
    end
  end
  describe 'Keeps Url' do
    it 'With wrong password' do
      # set local time to jan 1st, 2025
      travel_to Time.zone.local(2024, 12, 31, 23, 40, 0)
      visit events_path
      click_link('Check-in')
      # expect(page).to have_current_path(new_participation_path(event_id: '1'))
      sleep(2)
      fill_in('event_pass', with: '2')
      fill_in('signin[uin]', with: '666666666')
      fill_in('signin[first_name]', with: 'John')
      fill_in('signin[last_name]', with: 'Doe')
      fill_in('signin[email]', with: 'jdoe@example.com')
      sleep(2)

      click_button('commit')
      sleep(2)
      expect(page).to have_content('Incorrect password')
      # expect(page).to have_current_path(new_participation_path(event_id: '1'))
      sleep(2)
    end
  end
  describe 'Does not log in to Url' do
    it 'With other events password' do
      # set local time to jan 1st, 2025
      travel_to Time.zone.local(2025, 1, 2, 9, 40, 0)
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 10:00:00', endtime: '2025-01-02 12:00:00',
                             eventpass: 'pass2', eventtype: 'General Meeting')
      event1.save
      visit events_path
      path1 = "//a[@href='/events/new?event_id=" + event1.id.to_s + "']"
      find(:xpath, path1).click
      expect(page).to have_current_path(new_event_path(event_id: event1.id.to_s))
      sleep(2)
      fill_in('event_pass', with: '1')
      fill_in('signin[uin]', with: '666666666')
      fill_in('signin[first_name]', with: 'John')
      fill_in('signin[last_name]', with: 'Doe')
      fill_in('signin[email]', with: 'jdoe@example.com')
      sleep(2)

      click_button('commit')
      sleep(2)
      expect(page).to have_content('Incorrect password')
      expect(page).to have_current_path(new_event_path(event_id: event1.id.to_s))
      event1.destroy
      sleep(2)
    end
  end
end
