class UsersController < ApplicationController
  def index
    @users = User.all
    @current_user_token = '123'
  end

  def download_orders
    # send_file Rails.root.join('tmp', 'user_csv', "#{params[:email]}_orders.csv"), type: 'text/csv', disposition: 'attachment'
    CsvGenerationWorker.perform_async(params[:email])
    flash[:notice] = "CSV generation started. You'll be notified when it's ready."
    redirect_to root_path
  end

  def csv
    file_path = params[:file_path]
    send_file file_path, type: 'text/csv', disposition: 'attachment'
  end
end
