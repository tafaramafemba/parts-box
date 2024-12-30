document.addEventListener("DOMContentLoaded", function() {
    const shippingFeeType = document.getElementById("product_shipping_fee_type");
    const flatRateFields = document.getElementById("flat-rate-fields");
    const calculatedFields = document.getElementById("calculated-fields");
  
    function toggleFields() {
      if (shippingFeeType.value === "flat_rate") {
        flatRateFields.style.display = "block";
        calculatedFields.style.display = "none";
      } else if (shippingFeeType.value === "calculated") {
        flatRateFields.style.display = "none";
        calculatedFields.style.display = "block";
      } else {
        flatRateFields.style.display = "none";
        calculatedFields.style.display = "none";
      }
    }
  
    shippingFeeType.addEventListener("change", toggleFields);
    toggleFields(); // Run on page load
  });
  
  document.addEventListener("turbo:load", function() {
    const shippingFeeType = document.getElementById("product_shipping_fee_type");
    const flatRateFields = document.getElementById("flat-rate-fields");
    const calculatedFields = document.getElementById("calculated-fields");
  
    function toggleFields() {
      if (shippingFeeType.value === "flat_rate") {
        flatRateFields.style.display = "block";
        calculatedFields.style.display = "none";
      } else if (shippingFeeType.value === "calculated") {
        flatRateFields.style.display = "none";
        calculatedFields.style.display = "block";
      } else {
        flatRateFields.style.display = "none";
        calculatedFields.style.display = "none";
      }
    }
  
    shippingFeeType.addEventListener("change", toggleFields);
    toggleFields(); // Run on page load
  });