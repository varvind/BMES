require 'rails_helper'
RSpec.describe 'Create Users Page', type: :system do
    describe 'Create User' do
        it 'Add single user' do
            visit '/admin/users'
            click_link('New User')
            click_on('Add Individual User')
            fill_in('user[name]', with: 'test')
            fill_in('user[email]', with: 'test@user.com')
            fill_in('user[total_points]', with: 1)
            fill_in('user[general_meeting_points]', with: 1)
            fill_in('user[mentorship_meeting_points]', with: 1)
            fill_in('user[social_points]', with: 1)
            fill_in('user[password]', with: '1')
            click_on('commit')
            expect(page).to have_content('test')
            expect(page).to have_content('test@user.com')
            expect(page).to have_content('1')
        end
    end
end
