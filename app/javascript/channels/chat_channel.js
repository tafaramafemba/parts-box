import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  console.log("turbo:load event fired");
  if (consumer.subscriptions.subscriptions.length === 0) {
    const chatId = document.querySelector("#messages")?.dataset.chatId;
    if (chatId) {
      consumer.subscriptions.create(
        { channel: "ChatChannel", chat_id: chatId }, 
        {
          received(data) {
            console.log("Message received: ", data);
            const messagesContainer = document.querySelector("#messages");
            messagesContainer.insertAdjacentHTML("beforeend", data);
          }
        }
      );
    }
  }
});
