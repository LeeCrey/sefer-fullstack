import consumer from "channels/consumer"

var chat = consumer.subscriptions.create({channel: "ChatChannel", id: 1 }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
  }
});

export default { chat };
