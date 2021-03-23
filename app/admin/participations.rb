# frozen_string_literal: true

ActiveAdmin.register Participation do
  permit_params :uin, :first_name, :last_name, :email, :event_id
end
