class ErrorSerializer
  # def initialize(error_object)
  #   @error_object
  # end

  # def serialized_json
  #   {
  #     message: error_object.message,
  #     errors: [
  #       "#{error_object.status_code}"
  #     ]
  #   }
  # end

  def self.format_error(error_object)
    {
      message: error_object.message,
      errors: [
        "#{error_object.status_code}"
      ]
    }
  end
end