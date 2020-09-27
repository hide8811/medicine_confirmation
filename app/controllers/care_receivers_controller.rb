class CareReceiversController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery prepend: true

  def new; end

  def create; end

  def show; end
end
