# frozen_string_literal: true

require 'rails_helper'
require 'selenium-webdriver'
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
      click_link('Create one')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.csv'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      sleep(5)
      Sidekiq::Worker.drain_all
      visit '/admin/users'
      expect(page).to have_content('Aaryan Sharma')
    end

    it 'With CSV' do
      Sidekiq::Worker.clear_all
      visit '/admin/users'
      click_link('Create one')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.xlsx'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      sleep(5)
      Sidekiq::Worker.drain_all
      visit '/admin/users'
      expect(page).to have_content('Zachary Mendoza')
    end

    it 'With invalid file type' do
      visit '/admin/users'
      click_link('Create one')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'MemberInformation.txt'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Create one')
    end

    it 'With invalid columns (CSV)' do
      visit '/admin/users'
      click_link('Create one')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'BadMemberInformation.csv'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Create one')
    end

    it 'With invalid columns (XLSX)' do
      visit '/admin/users'
      click_link('Create one')
      attach_file('user[user_CSV_File]', Rails.root.join('test', 'BadMemberInformation.xlsx'))
      fill_in('user[password]', with: 'test')
      click_on('commit')
      expect(page).to have_content('Create one')
    end

    it 'Add single user' do
      visit '/admin/users'
      click_link('Create one')
      click_on('Add Individual User')
      fill_in('user[name]', with: 'test user')
      fill_in('user[email]', with: 'test@user.com')
      fill_in('user[total_points]', with: 1)
      fill_in('user[general_meeting_points]', with: 1)
      fill_in('user[mentorship_meeting_points]', with: 1)
      fill_in('user[social_points]', with: 1)
      fill_in('user[password]', with: '1')
      click_on('commit')
      expect(page).to have_content('test user')
      expect(page).to have_content('test@user.com')
      expect(page).to have_content('1')
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
      post '/admin/users', params: { 'user' => { 'password' => '1', 'name' => 'test user', 'email' => 'test@user.com',
                                                 'total_points' => '1', 'general_meeting_points' => '1',
                                                 'social_points' => '1', 'mentorship_meeting_points' => '1' } }
      expect(response).to have_http_status(302)
    end
  end
end
