document.addEventListener("turbo:load", () => {
    console.log("turbo:load submit event fired");
    const form = document.querySelector("#message-form");
    form.addEventListener("ajax:success", () => {
      form.reset();
    });
  });
  