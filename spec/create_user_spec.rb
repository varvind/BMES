# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe 'Create Users Page', type: :system do
  describe 'Create User' do
    before(:each) do
      visit new_admin_user_session_path
      fill_in('admin_user[email]', with: 'admin@example.com')
      fill_in('admin_user[password]', with: 'password')
      click_button('Login')
    end

    it 'With XLSX' do
      Sidekiq::Worker.clear_all
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.xlsx'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      sleep(5)
      Sidekiq::Worker.drain_all
      visit '/admin/users'
      expect(page).to have_content('Zachary Mendoza')
    end

    it 'With XLSX - No Password' do
      Sidekiq::Worker.clear_all
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.xlsx'))
      click_on('commit')
      expect(page).to have_content('Error: Password Field is Blank')
    end

    it 'With CSV' do
      Sidekiq::Worker.clear_all
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.csv'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      sleep(5)
      Sidekiq::Worker.drain_all
      visit '/admin/users'
      expect(page).to have_content('Abigail Leon')
    end

    it 'With CSV - No Password' do
      Sidekiq::Worker.clear_all
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.csv'))
      click_on('commit')
      expect(page).to have_content('Error: Password Field is Blank')
    end

    it 'With invalid file type' do
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.txt'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Error: Invalid File Type.')
    end

    it 'With invalid columns (CSV)' do
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'BadMemberInformation.csv'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Error Missing Columns: Name')
    end

    it 'With invalid columns (XLSX)' do
      visit '/admin/users'
      click_link('New User')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'BadMemberInformation.xlsx'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Error Missing Columns: Name')
    end

    it 'Test Add Year to Users' do
      visit '/admin/users'
      find('#collection_selection_toggle_all').click
      click_on('Batch Actions')
      click_on('Add Active Semesters For Selected')
      expect(User.find_by(id: 1).active_semesters).to eq(2)
    end

    it 'Add single user' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: 1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('test')
      expect(page).to have_content('test@user.com')
      expect(page).to have_content('1')
    end

    it 'Add single user twice with same email' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: 1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('test')
      expect(page).to have_content('test@user.com')
      expect(page).to have_content('1')

      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test 2')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: 1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Duplicate Email.')
    end

    it 'Add single user - No Fields Entered' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Name Field Blank, Email Field Blank, '\
      'Entered Non-number or Blank in Active Semesters Field, Entered Non-number or Blank in Points Field')
    end

    it 'Add single user - Password Field Not Entered' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: 1)
      click_on('commit')
      expect(page).to have_content('Error: Password Field is Blank')
    end

    it 'Add single user - Total Points Less than Sum of Points' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 2)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: 1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Total Points less than Sum of all other Points')
    end

    it 'Add single user - Active Semester Less than 0' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: -1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Entered Negative Number for Active Semesters Field')
    end

    it 'Add single user - General Meeting Points less than 0' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: -1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[outreach_points]', with: 1)
      fill_in('user[active_semesters]', with: -1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Entered Negative Number for Active Semesters Field')
    end

    it 'Add single user - All Points less than 0' do
      visit '/admin/users'
      click_link('New User')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 4)
      fill_in('user[general_meeting_points]', with: -1)
      fill_in('user[mentorship_meeting_points]', with: -1)
      fill_in('user[social_points]', with: -1)
      fill_in('user[outreach_points]', with: -1)
      fill_in('user[active_semesters]', with: -1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('Error: Entered Negative Number for Active Semesters Field')
    end

    it 'View User' do
      visit '/admin/users/1'
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('test user')
      expect(page).to have_content('4')
    end
  end

  describe 'Test User Route' do
    it 'Check Successful' do
      post '/admin/login', params: { admin_user: { email: 'admin@example.com', password: 'password' } }
      get '/admin/users'
      expect(response).to have_http_status(:ok)
      get '/admin/users/new'
      expect(response).to have_http_status(:ok)
    end

    it 'Test create individual user route' do
      post '/admin/login', params: { admin_user: { email: 'admin@example.com', password: 'password' } }
      get '/admin/users'
      expect(response).to have_http_status(:ok)
      get '/admin/users/new'
      expect(response).to have_http_status(:ok)
      user = instance_double('User', name: 'test', email: 'test@user.com', total_points: 1, password: 1)
      allow(User).to receive(:create).with(any_args).and_return(user)
      allow(user).to receive(:valid?).with(any_args).and_return(true)
      post '/admin/users', params: { 'user' => { 'password' => '1', 'name' => 'test user', 'email' => 'test@user.com',
                                                 'total_points' => '1', 'general_meeting_points' => '1',
                                                 'social_points' => '1', 'mentorship_meeting_points' => '1',
                                                 'outreach_points' => '1', 'active_semesters' => '1' } }
      expect(response).to have_http_status(302)
    end
  end
end
