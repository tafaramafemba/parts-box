import consumer from "./consumer";
document.addEventListener("turbo:load", () => {
  console.log("ChatChannel: DOMContentLoaded");
  const chatContainer = document.getElementById("messages");
  const chatId = chatContainer?.dataset.chatId;

  if (chatId) {
    console.log("ChatChannel: Subscribing to chat", chatId);

    consumer.subscriptions.create(
      { channel: "ChatChannel", chat_id: chatId },
      {
        received(data) {
          chatContainer.insertAdjacentHTML("beforeend", data);
          chatContainer.scrollTop = chatContainer.scrollHeight;
        },
      }
    );
  } else {
    console.log("ChatChannel: No chat ID found.");
  }
});


