document.addEventListener("DOMContentLoaded", function() {
    const phoneInput = document.querySelector("#phone");
    window.intlTelInput(phoneInput, {
      initialCountry: "ca",  // Set Canada as default
      preferredCountries: [ "ca", "us"],
      separateDialCode: true,
    });
  });
  