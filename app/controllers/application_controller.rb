class ApplicationController < ActionController::API
  after_action { pagy_headers_merge(@pagy) if @pagy }
  after_action { pagy_headers_merge(@pagy_a) if @pagy_a }
end
