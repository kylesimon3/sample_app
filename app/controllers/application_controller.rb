class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def start
    render html: "SAMPLE APP START"
  end

end
