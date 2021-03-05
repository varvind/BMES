# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
    end

    columns do
      column do
        panel 'Welcome to the BMES Officer Area!' do
          panel 'Our organization is committed to Advancing Human Health and Well Being' do
            panel "To get started, select the 'Events' tab from the Navigation Bar to create
                  a new event, or select 'Participations' to view member sign ins!"
            li link_to('Click here to view the full instruction manual', '/help.html')
          end
        end
      end
    end
  end
end
