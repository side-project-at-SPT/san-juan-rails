class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :reject_if_not_json_request

  private

  def reject_if_not_json_request
    # TODO: Consider multipart/form-data since it's a common format for file uploads
    unless request.content_type == "application/json"
      head :unsupported_media_type
    end
  end
end
