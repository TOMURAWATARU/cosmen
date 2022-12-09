class CosmesController < ApplicationController
  before_action :logged_in_user

  def new
    @cosme = Cosme.new
  end
end
