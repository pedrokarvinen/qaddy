ActiveAdmin.setup do |config|

  # == Load directories
  #
  config.load_paths = [
    File.expand_path('app/active_admin', Rails.root)
  ]

  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "LaComparto.com"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Recommended image height is 21px to properly fit in the header
  #
  # config.site_title_image = "/images/logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.
  config.default_namespace = :admin

  config.namespace :admin do |admin|
    admin.site_title = "LaComparto Admin Portal"
    admin.build_menu :utility_navigation do |menu|
      menu.add id: 'current_user_menu_item', label: proc{ display_name current_active_admin_user }, url: proc{ user_path current_active_admin_user }
      admin.add_logout_button_to_menu menu # can also pass priority & html_options for link_to to use
    end
  end

  config.namespace :retailer do |retailer|
    retailer.site_title = "LaComparto Retailer Portal"
    retailer.build_menu :utility_navigation do |menu|
      menu.add id: 'current_user_menu_item', label: proc{ display_name current_active_admin_user }, url: proc{ user_path current_active_admin_user }
      retailer.add_logout_button_to_menu menu # can also pass priority & html_options for link_to to use
    end
  end

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  # config.authentication_method = :authenticate_admin_user!
  # config.authentication_method = false
  config.namespace :admin do |admin|
    admin.authentication_method = :authenticate_admin_user!
  end

  config.namespace :retailer do |retailer|
    retailer.authentication_method = :authenticate_regular_user!
  end


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  # config.current_user_method = :current_admin_user
  # config.current_user_method = false
  config.namespace :admin do |admin|
    admin.current_user_method = :current_admin_user
  end

  config.namespace :retailer do |retailer|
    retailer.current_user_method = :current_regular_user
  end


  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  # config.logout_link_path = :destroy_admin_user_session_path
  config.logout_link_path = :signout_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  config.logout_link_method = :delete

  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  # config.root_to = 'dashboard#index'

  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use.
  # Admin comments are enabled by default.
  #
  # Default:
  # config.allow_comments = true
  #
  # You can turn them on and off for any given namespace by using a
  # namespace config block.
  #
  # Eg:
  #   config.namespace :without_comments do |without_comments|
  #     without_comments.allow_comments = false
  #   end
  config.namespace :retailer do |retailer|
    retailer.allow_comments = false
  end

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  # config.before_filter :do_something_awesome


  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'

  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', :media => :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # == Export links
  #config.download_links = false
  #config.download_links = [:csv, :xml, :json, :pdf] - PDF is not working
  config.download_links = [:csv, :xml, :json]

  # == CSV options
  #
  # Set the CSV builder separator (default is ",")
  # config.csv_column_separator = ','
  #
  # Set the CSV builder options (default is {})
  # config.csv_options = {}

  config.default_per_page = 20
end


module ActiveAdmin
  module Views
    module Pages

      class Base < Arbre::HTML::Document
        # override footer
        def build_footer
          div :id => "footer" do
            hr
            para "#{link_to "LaComparto.com", root_path} &copy; #{Date::today.year}".html_safe
          end
        end
      end

    end
  end
end
