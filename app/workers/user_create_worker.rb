# frozen_string_literal: true

class UserCreateWorker
  include Sidekiq::Worker
  # rubocop:disable Metrics/ParameterLists
  def perform(name, email, password,
              total_points, gen_meet_points,
              mentor_points, social_points, outreach_points, active_semesters)
    User.create(name: name, email: email, password: password, password_confirmation: password,
                total_points: total_points, general_meeting_points: gen_meet_points,
                mentorship_meeting_points: mentor_points, social_points: social_points,
                outreach_points: outreach_points, active_semesters: active_semesters)
  end
  # rubocop:enable Metrics/ParameterLists
end
