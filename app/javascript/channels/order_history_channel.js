import consumer from "./consumer"

consumer.subscriptions.create("OrderHistoryChannel", {
  connected() {
    console.log("OrderHistoryChannel Socket Connected")
  },

  disconnected() {
    console.log("OrderHistoryChannel Socket Disconnected");
  },

  received(data) {
    console.log("Data received on OrderHistoryChannel Socket", data);
    window.location.href = `/download_path?file_path=${data.file_path}`;
  }
});
