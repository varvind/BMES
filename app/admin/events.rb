# frozen_string_literal: true

ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :place, :description, :starttime, :endtime, :eventpass
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :place, :description, :starttime, :endtime, :eventpass]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
