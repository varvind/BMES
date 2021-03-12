# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create Users Page', type: :system do
  # integration tests
  describe 'User Integration Tests' do
    it 'Valid Login Page' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
    end
    it 'Valid Login' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      expect(page).to have_content('3/5 Points')
    end
    it 'invalid Login' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'wrongpassword')
      click_button('Login')
      expect(page).to have_content('Invalid email or password')
    end
    it 'Valid Logout' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      post '/user/logout'
      expect(page).to have_content('BMES Participation Tracker')
    end
    it 'Valid Password Reset' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      visit '/user/settings'
      fill_in('current_password[]', with: 'password')
      fill_in('new_password[]', with: 'newPassword')
      fill_in('confirmation_password[]', with: 'newPassword')
      click_button('Change Password')
      expect(page).to have_content('Password reset successfully')
      post '/user/logout'
      visit '/user/login'
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'newPassword')
      click_button('Login')
      expect(page).to have_content('test user')
    end

    it 'Invalid Password Reset-Wrong Original Password' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      visit '/user/settings'
      fill_in('current_password[]', with: 'wrongpassword')
      fill_in('new_password[]', with: 'newPassword')
      fill_in('confirmation_password[]', with: 'newPassword')
      click_button('Change Password')
      expect(page).to have_content('Wrong Password Entered, Try Again')
    end

    it 'Invalid Password Reset-Passwords Don\'t match' do
      visit '/user/login'
      expect(page).to have_content('Email*')
      expect(page).to have_content('Password*')
      fill_in('user[email]', with: 'user@example.com')
      fill_in('user[password]', with: 'password')
      click_button('Login')
      expect(page).to have_content('test user')
      visit '/user/settings'
      fill_in('current_password[]', with: 'password')
      fill_in('new_password[]', with: 'newPassword1')
      fill_in('confirmation_password[]', with: 'newPassword')
      click_button('Change Password')
      expect(page).to have_content('Passwords do not match!')
    end
  end

  describe 'User Unit Tests' do
    it 'test login function' do
      get '/user/login'
      expect(response).to have_http_status(:ok)
    end

    it 'test login_action function' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 3, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1)

      allow(User).to receive(:find_by).with(any_args).and_return(user)
      allow(User).to receive(:try).with(any_args).and_return(user)

      post '/user/login', params: { 'user' => { 'email' => 'user@example.com', 'password' => 'password' } }
      expect(response).to have_http_status(302)
    end

    it 'test login_action function' do
      post '/user/login', params: { 'user' => { 'email' => 'invalid', 'password' => 'invlid' } }
      expect(response).to have_http_status(302)
    end

    it 'test profile function' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 3, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1)

      allow(User).to receive(:find_by).with(any_args).and_return(user)
      allow(user).to receive(:events) { Array.new(1) }
      get '/user_profile'
      expect(response).to have_http_status(:ok)
    end

    it 'test invalid profile function' do
      get '/user_profile'
      expect(response).to have_http_status(302)
    end

    it 'test logout function' do
      post '/user/logout'
      expect(response).to have_http_status(302)
    end

    it 'test valid settings route' do
      get '/user/settings'
      expect(response).to have_http_status(:ok)
    end

    it 'test valid change password route' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 3, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      allow(user).to receive(:authenticate).with(any_args).and_return(user)
      allow(user).to receive(:update).with(any_args).and_return(user)

      post '/update_password', params: { 'current_password' => 'password', 'new_password' => 'newPassword',
                                         'confirmation_password' => 'newPassword' }
      expect(response).to have_http_status(302)
    end

    it 'test invalid change password route - current password incorrect' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 3, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      allow(user).to receive(:authenticate).with(any_args).and_return(false)

      post '/update_password', params: { 'current_password' => 'wrongPassword',
                                         'new_password' => 'newPassword', 'confirmation_password' => 'newPassword' }
      expect(response).to have_http_status(302)
    end

    it 'test invalid change password route - new passwords don\'t match' do
      user = instance_double('User', email: 'user@example.com', password: 'password', password_confirmation: 'password',
                                     name: 'test user', total_points: 3, general_meeting_points: 1,
                                     mentorship_meeting_points: 1, social_points: 1)
      allow(User).to receive(:find_by).with(any_args).and_return(user)
      allow(user).to receive(:authenticate).with(any_args).and_return(true)

      post '/update_password', params: { 'current_password' => 'wrongPassword',
                                         'new_password' => 'wrong', 'confirmation_password' => 'newPassword' }
      expect(response).to have_http_status(302)
    end

    it 'test invalid change password route - new passwords don\'t match' do
      allow(User).to receive(:find_by).with(any_args).and_return(nil)

      post '/update_password', params: { 'current_password' => 'wrongPassword',
                                         'new_password' => 'wrong', 'confirmation_password' => 'newPassword' }
      expect(response).to have_http_status(302)
    end
  end
end
