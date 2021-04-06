# frozen_string_literal: true

module Api
  class V1Controller < ActionController::API
    def events
      @events = Event.all
      render json: {
        events: @events
      }, status: :ok
    end

    def event
      @event =
        begin
          Event.find(params[:id])
        rescue StandardError
          nil
        end
      if @event.nil?
        render json: {}, status: :bad_request
      else
        render json: {
          id: @event.id,
          name: @event.title,
          start_time: @event.starttime,
          attendees: @event.users,
          guests: @event.guests
        }, status: :ok
      end
    end
  end
end
