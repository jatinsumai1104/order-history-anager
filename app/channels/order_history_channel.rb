class OrderHistoryChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'order_history_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
