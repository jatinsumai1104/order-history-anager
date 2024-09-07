namespace :import do
  desc 'Import data from CSV'
  task csv: :environment do
    require 'csv'

    csv_path = Rails.root.join('tmp/input csv') # Replace with actual path
    FileUtils.rm_rf("#{Rails.root.join('tmp', 'user_csv')}/.", secure: true)

    users = {}
    products = []
    orders = []

    ActiveRecord::Base.transaction do
      Order.delete_all
      User.delete_all
      Product.delete_all

      puts 'Importing Users'
      CSV.foreach("#{csv_path}/users.csv", headers: true) do |row|
        if row['USERNAME'].present? && row['EMAIL'].present? && row['PHONE'].present?
          users[row['EMAIL']] = User.new(name: row['USERNAME'], email: row['EMAIL'], phone: row['PHONE'])
        end
      end
      User.import(users.values)
      user_ids = User.pluck(:email, :id).to_h

      puts 'Importing Products'
      CSV.foreach("#{csv_path}/products.csv", headers: true) do |row|
        products << Product.new(code: row['CODE'], name: row['NAME'], category: row['CATEGORY'])
      end
      Product.import(products)
      product_ids = Product.pluck(:code, :id).to_h

      puts 'Importing Orders'
      CSV.foreach("#{csv_path}/order_details.csv", headers: true) do |row|
        orders << Order.new(
          user_id: user_ids[row['USER_EMAIL']],
          product_id: product_ids[row['PRODUCT_CODE']],
          order_date: Date.parse(row['ORDER_DATE'])
        )
      end
      Order.import(orders)
    rescue => e
      puts "Import failed: #{e.message}"
    end
  end
end
