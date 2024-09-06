class CsvGenerationWorker
  include Sidekiq::Worker

  HEADING = %w(USERNAME USER_EMAIL PRODUCT_CODE PRODUCT_NAME PRODUCT_CATEGORY ORDER_DATE).freeze

  def perform(email)
    file_path = Rails.root.join('tmp', 'user_csv', "#{email}_orders.csv")

    unless File.exist?(file_path)
      user = User.includes(:orders, :products).find_by!(email: email)
      csv_data = CSV.generate(headers: true) do |csv|
        csv << HEADING
        user.orders.each do |order|
          csv << [
            user.name, user.email,
            order.product.code, order.product.name, order.product.category,
            order.order_date.strftime("%Y-%m-%d")
          ]
        end
      end
      File.write(file_path, csv_data)
    end
    ActionCable.server.broadcast('order_history_channel', { message: 'CSV is ready', file_path: file_path.to_s })
  end
end
