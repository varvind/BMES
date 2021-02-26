class UserCreateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(name, email, password,
    total_points, gen_meet_points,
    mentor_points, social_points)
    User.create(name: name, email: email, password: password, password_confirmation: password,
                total_points: total_points, general_meeting_points: gen_meet_points,
                mentorship_meeting_points: mentor_points, social_points: social_points)
    
  end
end
