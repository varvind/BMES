# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API v1', type: :system do
  describe 'Get All Events' do
    it 'get' do
      get api_v1_events_path
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq({
                                                'events' => [
                                                  {
                                                    'id' => 1,
                                                    'name' => 'Event Title',
                                                    'start_time' => '2025-01-01T00:00:00.000Z'
                                                  }
                                                ]
                                              })
    end
    it 'get after new event' do
      n_event = Event.create!(title: 'Event Numba 2', place: 'Place Number 2', description: 'Some Description',
                              starttime: '2020-01-01 00:00:00', endtime: '2020-01-01 01:00:00', eventpass: '2', eventtype: 'General')

      get api_v1_events_path
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq({
                                                'events' => [
                                                  {
                                                    'id' => 1,
                                                    'name' => 'Event Title',
                                                    'start_time' => '2025-01-01T00:00:00.000Z'
                                                  },
                                                  {
                                                    'id' => 2,
                                                    'name' => 'Event Numba 2',
                                                    'start_time' => '2020-01-01T00:00:00.000Z'
                                                  }
                                                ]
                                              })

      n_event.destroy
    end
  end
  describe 'Get Specific Event' do
    it 'Valid' do
      get api_v1_event_path(id: 1)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq({
                                                'attendees' => [],
                                                'guests' => [],
                                                'id' => 1,
                                                'name' => 'Event Title',
                                                'start_time' => '2025-01-01T00:00:00.000Z'
                                              })
    end
    it 'Invalid' do
      get api_v1_event_path(id: 100)
      expect(response).to have_http_status(:bad_request)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(JSON.parse(response.body)).to eq({})
    end
  end
end
