class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize

  def authorize
    unless valid_signature?
      render nothing: true, status: 401
    end
  end

  def valid_signature?
    if params[:challenge].present?
      request.headers['X-Dropbox-Signature'] == sign('dbx')
    else
      request.headers['X-Dropbox-Signature'] == sign(request.body.read)
    end
  end

  def sign(data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha1'), ENV['DROPBOX_SECRET'], data)
  end
end