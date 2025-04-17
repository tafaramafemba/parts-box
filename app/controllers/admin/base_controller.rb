class Admin::BaseController < ApplicationController
    layout 'admin'
    before_action :authenticate_admin!

    private

    def after_sign_in_path_for(resource)
      if resource.is_a?(Admin)
        admin_blog_posts_path # Redirect admins to blog_posts#index
      else
        super # Use the default behavior for other users
      end
    end
  end