# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  Event.create!(title: 'Title', place: 'Zach 310', description: 'Description',
                starttime: '2020-12-01 00:00:00', endtime: '2020-12-01 01:00:00',
                eventpass: '1', eventtype: 'General Meeting')
end

if Rails.env.test?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  Event.create!(title: 'Event Title', place: 'Event Place', description: 'Event Description',
                starttime: '2025-01-01 00:00:00', endtime: '2025-01-01 01:00:00',
                eventpass: '1', eventtype: 'General Meeting')
  User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password',
               name: 'test user', total_points: 3, general_meeting_points: 1,
               mentorship_meeting_points: 1, social_points: 1)
end

if Rails.env.production?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  Event.create!(title: 'Title', place: 'Zach 310', description: 'Description',
                starttime: '2020-12-01 00:00:00', endtime: '2020-12-01 01:00:00',
                eventpass: '1', eventtype: 'General Meeting')
end
