document.addEventListener("DOMContentLoaded", function() {
  const phoneInput = document.querySelector("#phone_number");
  const form = phoneInput.closest("form");
  const iti = window.intlTelInput(phoneInput, {
    initialCountry: "zw",  // Set Zimbabwe as default
    preferredCountries: ["zw"],
    separateDialCode: true,
  });

  form.addEventListener("submit", function(event) {
    const countryCode = iti.getSelectedCountryData().dialCode;
    phoneInput.value = `+${countryCode}${phoneInput.value}`;
  });
});
  