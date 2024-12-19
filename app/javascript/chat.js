document.addEventListener("turbo:load", () => {
  const openChatButton = document.getElementById("open-chat");
  const closeChatButton = document.getElementById("close-chat");
  const chatModal = document.getElementById("chat-modal");
  const chatMessages = document.getElementById("messages");
  const messageForm = document.getElementById("message-form");
  console.log("modal js loaded");

  const chatId = chatMessages.dataset.chatId;

  if (openChatButton) {
    openChatButton.addEventListener("click", () => {
      chatModal.classList.remove("hidden");
      chatModal.classList.add("show");
    });
  }

  if (closeChatButton) {
    closeChatButton.addEventListener("click", () => {
      chatModal.classList.remove("show");
      setTimeout(() => chatModal.classList.add("hidden"), 300);
    });
  }

  if (messageForm) {
    messageForm.addEventListener("submit", (e) => {
      e.preventDefault();
      const formData = new FormData(messageForm);

      
      fetch(`/chats/${chatId}/messages`, {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
        },
        body: formData,
      });
      messageForm.reset();
    });
  }
});


  