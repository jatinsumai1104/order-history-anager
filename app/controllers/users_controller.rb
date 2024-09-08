class UsersController < ApplicationController
  def index
    @users = User.all
    @current_user_token = '123'
  end

  def download_orders
    CsvGenerationWorker.perform_async(params[:email])
  end

  def csv
    file_path = params[:file_path]
    send_file file_path, type: 'text/csv', disposition: 'attachment'
  end
end
