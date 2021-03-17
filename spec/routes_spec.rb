# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event page', type: :system do
  describe 'Check Urls' do
    it 'View event with different url ids' do
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00', eventpass: 'pass2')
      event2 = Event.create!(title: 'Event Test 2', place: 'Zach 222', description: 'Not Saved',
                             starttime: '2025-01-03 00:00:00', endtime: '2025-01-03 00:00:00', eventpass: 'pass3')
      event1.save
      event2.save
      visit events_path

      path1 = "//a[@href='/participations/new?event_id=" + event1.id.to_s + "']"
      path2 = "//a[@href='/participations/new?event_id=" + event2.id.to_s + "']"
      find(:xpath, path1)
      find(:xpath, path2)

      sleep(2)
      event1.destroy
      event2.destroy
    end
    it 'Visit event with different url ids' do
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00', eventpass: 'pass2')
      event2 = Event.create!(title: 'Event Test 2', place: 'Zach 222', description: 'Not Saved',
                             starttime: '2025-01-03 00:00:00', endtime: '2025-01-03 00:00:00', eventpass: 'pass3')
      event1.save
      event2.save
      visit events_path

      path1 = "//a[@href='/participations/new?event_id=" + event1.id.to_s + "']"
      path2 = "//a[@href='/participations/new?event_id=" + event2.id.to_s + "']"
      find(:xpath, path1).click
      sleep(2)
      click_link('Back to List')
      sleep(2)
      find(:xpath, path2).click
      click_link('Back to List')

      sleep(2)
      event1.destroy
      event2.destroy
    end
  end
end

RSpec.describe 'Participation Page', type: :system do
  describe 'Has Url' do
    it 'Checks the url parameters' do
      visit events_path
      click_link('Event Check-in')
      # expect(page).to have_current_path(new_participation_path(event_id: '1'))
      sleep(2)
    end
  end
  describe 'Keeps Url' do
    it 'With wrong password' do
      visit events_path
      click_link('Event Check-in')
      # expect(page).to have_current_path(new_participation_path(event_id: '1'))
      sleep(2)
      fill_in('event_pass', with: '2')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
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
      event1 = Event.create!(title: 'Event Test 1', place: 'Zach 111', description: 'Not Saved',
                             starttime: '2025-01-02 00:00:00', endtime: '2025-01-02 00:00:00', eventpass: 'pass2')
      event1.save
      visit events_path
      path1 = "//a[@href='/participations/new?event_id=" + event1.id.to_s + "']"
      find(:xpath, path1).click
      expect(page).to have_current_path(new_participation_path(event_id: event1.id.to_s))
      sleep(2)
      fill_in('event_pass', with: '1')
      fill_in('participation[uin]', with: '666666666')
      fill_in('participation[first_name]', with: 'John')
      fill_in('participation[last_name]', with: 'Doe')
      fill_in('participation[email]', with: 'jdoe@example.com')
      sleep(2)

      click_button('commit')
      sleep(2)
      expect(page).to have_content('Incorrect password')
      expect(page).to have_current_path(new_participation_path(event_id: event1.id.to_s))
      event1.destroy
      sleep(2)
    end
  end
end
