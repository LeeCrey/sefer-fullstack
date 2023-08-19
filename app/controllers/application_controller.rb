# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :update_last_seen_at

  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.json { render_json_error(exception.message, :not_found) }
      format.html { redirect_to root_path }
    end
  end

  rescue_from Pundit::NotAuthorizedError,
              ActionController::InvalidAuthenticityToken do |ex|
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url) }
      format.json { render_json_error(ex.message, :unauthorized) }
    end
  end

  def not_found
    respond_to do |format|
      format.html { render_404_page }
      format.json { render_json_error("Page not found", :not_found) }
    end
  end

  protected

  include Pundit::Authorization

  def render_created(msg)
    render json: { okay: true }.merge(msg), status: :created
  end

  def render_json_error(msg, status)
    render json: { okay: false, reason: msg }, status: status
  end

  private

  def render_404_page
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end

  def update_last_seen_at
    if user_signed_in?
      current_user.touch :last_seen_at unless current_user.online?
    end
  end

  def raise_if_blank(resource, name)
    if resource.blank?
      msg = "#{name} not found"
      raise ActiveRecord::RecordNotFound.new msg
    end
  end
end
