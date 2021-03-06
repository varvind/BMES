# frozen_string_literal: true

require 'csv'

require 'creek'

# Note: CSV is a built in ruby package, and creek is used to parse Excel files
# This is the reason for two seperate functions for both CSV and XLSX parsing

# rubocop:disable Metrics/BlockLength
ActiveAdmin.register User do
  menu label: 'Create Users'
  permit_params :user_CSV_File, :password, :name, :email, :total_points, :general_meeting_points,
                :social_points, :mentorship_meeting_points, :active_semesters, :outreach_points

  batch_action :add_active_semesters_for do |ids|
    batch_action_collection.find(ids).each do |user|
      years = user.active_semesters + 1
      user.update(active_semesters: years)
    end
    redirect_to collection_path, alert: 'Active Semester Added for Selected Users'
  end

  # Initialize Column
  index do
    selectable_column
    column :name
    column :email
    column :total_points
    column :general_meeting_points
    column :social_points
    column :mentorship_meeting_points
    column :outreach_points
    column :active_semesters
    column :created_at
    column :events
    actions
  end

  filter :name
  filter :current_sign_in_at
  filter :total_points
  filter :created_at

  show do
    attributes_table :name, :email, :total_points, :general_meeting_points,
                     :mentorship_meeting_points, :social_points, :outreach_points, :active_semesters, :events
  end
  # initialize form
  form do |f|
    f.semantic_errors
    text_node javascript_include_tag('user_form.js')
    f.inputs do
      f.li "<button type = 'button' class='label' id = 'switchButton'
              style = 'margin-left:1%;font-weight:bold; margin-top:1%' onclick='changeForm()'>
              Add Individual User</label>".html_safe
      f.li "<label class='label' id ='instructions'
              style = 'margin-left:1%;font-weight:bold; margin-top:10%; position:relative'>
              Use a Spreadsheet with User Information</label>".html_safe
      f.li "<label class='label' id ='columns'
              style = 'margin-left:1%; margin-top:10%; position:relative'>
              Required Columns: Name, Email, Total Points, General Meeting Points,
               Mentorship Meeting Points, Outreach Points, Active Semesters and Social Points</label>".html_safe
      f.input :user_CSV_File, as: :file, accept: :csv, required: true
      f.li "<label class='label hidden' style = 'margin-left:1%;font-weight:bold'>
              or Add Individual Member</label>".html_safe
      f.input :name, as: :hidden
      f.input :email, as: :hidden
      f.input :total_points, as: :hidden
      f.input :general_meeting_points, as: :hidden
      f.input :mentorship_meeting_points, as: :hidden
      f.input :social_points, as: :hidden
      f.input :outreach_points, as: :hidden
      f.input :active_semesters, as: :hidden
      f.li "<label class='label' style = 'margin-left:1%; font-weight:bold'>
              Add User Password (Required) </label>".html_safe
      f.input :password
    end
    f.actions
  end

  # form controller
  controller do
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity

    def create
      attrs = permitted_params[:user]

      if !attrs[:user_CSV_File].nil?
        if attrs[:password] == ''
          redirect_to '/admin/users/new', flash: { error: 'Error: Password Field is Blank' }
          return
        end
        filename = attrs[:user_CSV_File].original_filename
        if filename.include? '.csv'
          create_user_with_csv(attrs)
        elsif filename.include? '.xlsx'
          create_user_with_xlsx(attrs)
        else
          redirect_to '/admin/users/new', flash: { error: 'Error: Invalid File Type.' }
        end
      else

        unless check_for_errors(attrs)
          user = User.create(password: attrs[:password], password_confirmation: attrs[:password], name: attrs[:name],
                             email: attrs[:email], total_points: attrs[:total_points],
                             general_meeting_points: attrs[:general_meeting_points],
                             social_points: attrs[:social_points],
                             mentorship_meeting_points: attrs[:mentorship_meeting_points],
                             outreach_points: attrs[:outreach_points],
                             active_semesters: attrs[:active_semesters])

          if !user.valid?
            redirect_to '/admin/users/new', flash: { error: 'Error: Duplicate Email.' }
          else
            redirect_to '/admin/users', flash: { error: 'Successfully Created User.' }
          end
        end
      end
    end
  end
end

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

def create_user_with_csv(attrs)
  table = CSV.parse(attrs[:user_CSV_File].read)
  name_index = find_table_index('name', table, 'csv')
  email_index = find_table_index('email', table, 'csv')
  t_points_index = find_table_index('total points', table, 'csv')
  gen_points_index = find_table_index('general meeting points', table, 'csv')
  men_points_index = find_table_index('mentorship meeting points', table, 'csv')
  soc_points_index = find_table_index('social points', table, 'csv')
  out_points_index = find_table_index('outreach points', table, 'csv')
  active_semesters_index = find_table_index('active semesters', table, 'csv')
  if name_index == -1 || email_index == -1 || t_points_index == -1 ||
     gen_points_index == -1 || men_points_index == -1 ||
     soc_points_index == -1 || active_semesters_index == -1 ||
     out_points_index == -1

    error = 'Error Missing Columns: '
    error += 'Name, ' if name_index == -1
    error += 'Email, ' if email_index == -1
    error += 'Total Points, ' if t_points_index == -1
    error += 'General Meeting Points, ' if gen_points_index == -1
    error += 'Mentorship Meeting Points, ' if men_points_index == -1
    error += 'Social Points, ' if soc_points_index == -1
    error += 'Outreach Points, ' if out_points_index == -1
    error += 'Active Semesters, ' if active_semesters_index == -1
    error = error[0..-3]

    redirect_to '/admin/users/new', flash: { error: error }
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
    outreach_points = table[i][out_points_index]
    active_semesters = table[i][active_semesters_index]
    password = attrs[:password]
    UserCreateWorker.perform_async(name, email, password,
                                   total_points, gen_meet_points,
                                   mentor_points, social_points, outreach_points, active_semesters)
  end
  redirect_to '/admin/users', flash: { error: 'Successfully Created Users.' }
end

def create_user_with_xlsx(attrs)
  table = Creek::Book.new attrs[:user_CSV_File].path
  name_index = find_table_index('name', table, 'xlsx')
  email_index = find_table_index('email', table, 'xlsx')
  t_points_index = find_table_index('total points', table, 'xlsx')
  gen_points_index = find_table_index('general meeting points', table, 'xlsx')
  men_points_index = find_table_index('mentorship meeting points', table, 'xlsx')
  soc_points_index = find_table_index('social points', table, 'xlsx')
  out_points_index = find_table_index('outreach points', table, 'xlsx')
  active_semesters_index = find_table_index('active semesters', table, 'xlsx')
  if name_index == -1 || email_index == -1 || t_points_index == -1 ||
     gen_points_index == -1 || men_points_index == -1 ||
     soc_points_index == -1 || active_semesters_index == -1 ||
     out_points_index == -1
    error = 'Error Missing Columns: '
    error += 'Name, ' if name_index == -1
    error += 'Email, ' if email_index == -1
    error += 'Total Points, ' if t_points_index == -1
    error += 'General Meeting Points, ' if gen_points_index == -1
    error += 'Mentorship Meeting Points, ' if men_points_index == -1
    error += 'Social Points, ' if soc_points_index == -1
    error += 'Outreach Points, ' if out_points_index == -1
    error += 'Active Semesters, ' if active_semesters_index == -1
    error = error[0..-3]
    redirect_to '/admin/users/new', flash: { error: error }
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
    outreach_points = row.values[out_points_index]
    active_semesters = row.values[active_semesters_index]
    password = attrs[:password]
    UserCreateWorker.perform_async(name, email, password,
                                   total_points, gen_meet_points,
                                   mentor_points, social_points, outreach_points, active_semesters)
  end

  redirect_to '/admin/users', flash: { error: 'Successfully Created Users.' }
end

def check_for_errors(attrs)
  error = 'Error: '

  error += 'Password Field is Blank, ' if attrs[:password] == ''

  error += 'Name Field Blank, ' if attrs[:name] == ''

  error += 'Email Field Blank, ' if attrs[:email] == ''

  if attrs[:total_points].to_i < attrs[:general_meeting_points].to_i +
                                 attrs[:social_points].to_i +
                                 attrs[:mentorship_meeting_points].to_i +
                                 attrs[:outreach_points].to_i
    error += 'Total Points less than Sum of all other Points, '
  end

  if attrs[:active_semesters].to_i.to_s != attrs[:active_semesters]
    error += 'Entered Non-number or Blank in Active Semesters Field, '
  end

  error += 'Entered Negative Number for Active Semesters Field, ' if attrs[:active_semesters].to_i.negative?

  if attrs[:total_points].to_i.to_s != attrs[:total_points] ||
     attrs[:general_meeting_points].to_i.to_s != attrs[:general_meeting_points] ||
     attrs[:mentorship_meeting_points].to_i.to_s != attrs[:mentorship_meeting_points] ||
     attrs[:social_points].to_i.to_s != attrs[:social_points] ||
     attrs[:outreach_points].to_i.to_s != attrs[:outreach_points]
    error += 'Entered Non-number or Blank in Points Field, '
  end

  if attrs[:total_points].to_i.negative? ||
     attrs[:general_meeting_points].to_i.negative? ||
     attrs[:mentorship_meeting_points].to_i.negative? ||
     attrs[:social_points].to_i.negative? ||
     attrs[:outreach_points].to_i.negative?
    error += 'Entered Negative Number for Points Field, '
  end
  if error == 'Error: '
    false
  else
    error = error[0..-3]
    redirect_to '/admin/users/new', flash: { error: error }
    true
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
