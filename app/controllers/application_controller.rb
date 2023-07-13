class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request_response

  def not_found_response(error)
    render json: ErrorSerializer.new(error, "404").serialized_json, status: 404
  end

  def bad_request_response(error)
    render json: ErrorSerializer.new(error, "400").serialized_json, status: 400
  end
end
