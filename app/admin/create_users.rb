# frozen_string_literal: true

require 'csv'

require 'creek'

# Note: CSV is a built in ruby package, and creek is used to parse Excel files
# This is the reason for two seperate functions for both CSV and XLSX parsing

# rubocop:disable Metrics/BlockLength
ActiveAdmin.register User do
  menu label: 'Create Users'
  batch_action :destroy, false
  permit_params :user_CSV_File, :password, :name, :email, :total_points, :general_meeting_points,
                :social_points, :mentorship_meeting_points

  # Initialize Column
  index do
    selectable_column
    column :name
    column :email
    column :total_points
    column :general_meeting_points
    column :social_points
    column :mentorship_meeting_points
    column :created_at
    actions
  end

  filter :name
  filter :current_sign_in_at
  filter :total_points
  filter :created_at

  # initialize form
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    text_node javascript_include_tag('user_form.js')
    f.inputs do
      f.li "<button type = 'button' class='label' id = 'switchButton'
              style = 'margin-left:1%;font-weight:bold; margin-top:1%' onclick='changeForm()'>
              Add Individual User</label>".html_safe
      f.li "<label class='label' id ='instructions'
              style = 'margin-left:1%;font-weight:bold; margin-top:10%; position:relative'>
              Use a Spreadsheet with User Information</label>".html_safe
      f.input :user_CSV_File, as: :file, accept: :csv, required: true
      f.li "<label class='label hidden' style = 'margin-left:1%;font-weight:bold'>
              or Add Individual Member</label>".html_safe
      f.input :name, as: :hidden
      f.input :email, as: :hidden
      f.input :total_points, as: :hidden
      f.input :general_meeting_points, as: :hidden
      f.input :mentorship_meeting_points, as: :hidden
      f.input :social_points, as: :hidden
      f.li "<label class='label' style = 'margin-left:1%; font-weight:bold'>
              Add User Password (Required) </label>".html_safe
      f.input :password
    end
    f.actions
  end

  # form controller
  controller do
    def create
      attrs = permitted_params[:user]
      if !attrs[:user_CSV_File].nil?
        filename = attrs[:user_CSV_File].original_filename
        if filename.include? '.csv'
          create_user_with_csv(attrs)
        elsif filename.include? '.xlsx'
          create_user_with_xlsx(attrs)
        end
      else
        User.create(password: attrs[:password], name: attrs[:name], email: attrs[:email],
                    total_points: attrs[:total_points], general_meeting_points: attrs[:general_meeting_points],
                    social_points: attrs[:social_points],
                    mentorship_meeting_points: attrs[:mentorship_meeting_points])
      end
      redirect_to '/admin/users'
    end
  end
end

# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
def find_table_index(header_name, table, filetype)
  if filetype == 'csv'
    (0..table[0].length - 1).each do |i|
      return i if header_name == table[0][i].downcase
    end
  else
    sheets = table.sheets
    worksheet = sheets[0]
    worksheet.rows.each do |row|
      (0..row.length).each do |j|
        return j if !row.values[j].nil? && header_name == row.values[j].downcase
      end
    end
  end
  -1
end

# rubocop:disable Metrics/MethodLength
def create_user_with_csv(attrs)
  table = CSV.parse(attrs[:user_CSV_File].read)
  name_index = find_table_index('name', table, 'csv')
  email_index = find_table_index('email', table, 'csv')
  t_points_index = find_table_index('total points', table, 'csv')
  gen_points_index = find_table_index('general meeting points', table, 'csv')
  men_points_index = find_table_index('mentorship meeting points', table, 'csv')
  soc_points_index = find_table_index('social points', table, 'csv')
  if name_index == -1 || email_index == -1 || t_points_index == -1
    gen_points_index == -1 || men_points_index == -1 || soc_points_index == -1
    return
  end
  (0..table.length - 1).each do |i|
    name = table[i][name_index]
    next unless name != 'Name' && !name.nil?

    email = table[i][email_index]
    total_points = table[i][t_points_index]
    gen_meet_points = table[i][gen_points_index]
    social_points = table[i][soc_points_index]
    mentor_points = table[i][men_points_index]
    password = attrs[:password]
    User.create(name: name, email: email, password: password,
                total_points: total_points, general_meeting_points: gen_meet_points,
                mentorship_meeting_points: mentor_points, social_points: social_points)
  end
end

def create_user_with_xlsx(attrs)
  table = Creek::Book.new attrs[:user_CSV_File].path
  name_index = find_table_index('name', table, 'xlsx')
  email_index = find_table_index('email', table, 'xlsx')
  t_points_index = find_table_index('total points', table, 'xlsx')
  gen_points_index = find_table_index('general meeting points', table, 'xlsx')
  men_points_index = find_table_index('mentorship meeting points', table, 'xlsx')
  soc_points_index = find_table_index('social points', table, 'xlsx')
  if name_index == -1 || email_index == -1 || t_points_index == -1
    gen_points_index == -1 || men_points_index == -1 || soc_points_index == -1
    return
  end
  sheets = table.sheets
  worksheet = sheets[0]
  worksheet.rows.each do |row|
    name = row.values[name_index]
    next unless name != 'Name' && !name.nil?

    email = row.values[email_index]
    total_points = row.values[t_points_index]
    gen_meet_points = row.values[gen_points_index]
    social_points = row.values[soc_points_index]
    mentor_points = row.values[men_points_index]
    password = attrs[:password]
    User.create(name: name, email: email, password: password,
                total_points: total_points, general_meeting_points: gen_meet_points,
                mentorship_meeting_points: mentor_points, social_points: social_points)
  end
  # rubocop:enable Metrics/MethodLength
end

# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
