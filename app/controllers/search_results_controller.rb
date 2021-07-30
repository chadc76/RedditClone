class SearchResultsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def show
    @search = search_input
    @results = search_subs

    render :results
  end

  private

  def search_subs
    Sub.where("upper (subs.title) LIKE upper (?) OR subs.description = ?", search_input_with_percent, search_input_with_percent)
  end

  def search_input
    params[:search][:search_input]
  end

  def search_input_with_percent
    "%" + search_input + "%"
  end
end