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
                starttime: '2020-12-01 00:00:00', endtime: '2020-12-01 01:00:00', eventpass: '1')
  Participation.create!(uin: 123, first_name: 'Joe', event_id: 1)
  Participation.create!(uin: 456, first_name: 'Joanna', event_id: 1)
end

if Rails.env.test?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
  Event.create!(title: 'Event Title', place: 'Event Place', description: 'Event Description',
                starttime: '2025-01-01 00:00:00', endtime: '2025-01-01 01:00:00', eventpass: '1')
  Participation.create!(uin: 123_456_789, first_name: 'Bob', last_name: 'Ross',
                        email: 'happylittletrees@example.com', event_id: 1)
end
