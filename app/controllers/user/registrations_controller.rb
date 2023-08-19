# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  protected

  # Overriding
  def sign_up_params
    hash = params.require(:user).permit(
      :first_name, :last_name, :gender, :country,
      :email, :password, :password_confirmation
    )
    hash[:gender] = hash[:gender].to_i
    hash
  end

  def update_resource(resource, params)
    params[:gender] = params[:gender].to_i
    super(resource, params)
  end

  def configure_permitted_parameters
    up_keys = %i[biography current_password first_name last_name gender country
                 password password_confirmation martial_status]
    devise_parameter_sanitizer.permit(:account_update, keys: up_keys)
  end
end
