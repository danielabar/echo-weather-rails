module Weather
  class ApiError < StandardError
    attr_reader :code

    def initialize(code, message)
      super(message)
      @code = code
    end
  end
end
