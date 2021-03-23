# frozen_string_literal: true

class ParticipationsController < ApplicationController
  # belongs_to: EventsController

  def new
    @participation = Participation.new
  end

  # rubocop:disable Metrics/MethodLength
  def create
    @event_id = params['participation']['event_id']
    @event = begin
               Event.find(@event_id)
             rescue StandardError
               nil
             end
    if @event.nil?
      redirect_to new_participation_path(event_id: @event_id), flash: { danger: 'No matching event found, please try '\
        'again.' }
    elsif @event.eventpass == params[:event_pass]
      @verification = Participation.find_by email: participation_params[:email],
                                            event_id: participation_params[:event_id]
      unless @verification.nil?
        redirect_to events_path, flash: { danger: 'You have already signed into the event' }
        return
      end
      user = User.find_by(email: params['participation']['email'])

      if user && !session[:user_id] # indicates the user has an account, and should sign in
        redirect_to new_participation_path(event_id: @event_id), flash: { danger: 'Please sign in to your account before checking in.'}
        return
      elsif user
        user.events << @event
        case @event.eventtype
        when 'General Meeting'
          user.general_meeting_points = user.general_meeting_points + 1
        when 'Mentorship Meeting'
          user.mentorship_meeting_points = user.mentorship_meeting_points + 1
        else
          user.social_points = user.social_points + 1
        end
        user.total_points = user.total_points + 1
        user.save
      end

      @participation = Participation.new(participation_params)
      @participation.save
      redirect_to events_path, flash: { success: 'You have successfully signed into the event.' }
    else
      redirect_to new_participation_path(event_id: @event_id), flash: { danger: 'Incorrect password, please try '\
        'again.' }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def participation_params
    params.require(:participation).permit(:uin, :first_name, :last_name, :email, :event_pass, :event_id)
  end
end
