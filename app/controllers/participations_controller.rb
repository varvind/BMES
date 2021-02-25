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
