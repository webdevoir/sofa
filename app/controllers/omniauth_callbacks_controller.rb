class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_auth(request.env['omniauth.auth']) 
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_messege(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end
end