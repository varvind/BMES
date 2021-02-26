# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      #   span class: "blank_slate" do
      #     span I18n.t("active_admin.dashboard_welcome.welcome")
      #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
      #   end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      #   column do
      #     panel "Recent Posts" do
      #       ul do
      #         Post.recent(5).map do |post|
      #           li link_to(post.title, admin_post_path(post))
      #         end
      #       end
      #     end
      #   end

      column do
        panel 'Welcome to the BMES Officer Area!' do
        panel 'Our organization is committed to Advancing Human Health and Well Being' do
	panel "To get started, select the 'Events' tab from the Navigation Bar to create a new event, or select 'Participations' to view member sign ins!"
        li link_to('Click here to view the full instruction manual', '/help.html')
		    
        end
        end
      end
    end
  end
  # content
end
