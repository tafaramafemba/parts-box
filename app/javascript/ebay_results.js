document.addEventListener("DOMContentLoaded", () => {
    const toggleButton = document.getElementById("toggle-ebay-results");
    const resultsContainer = document.getElementById("ebay-results-container");
  
    toggleButton.addEventListener("click", () => {
      if (resultsContainer.style.display === "none") {
        resultsContainer.style.display = "block";
        toggleButton.textContent = "Click to collapse eBay results";
      } else {
        resultsContainer.style.display = "none";
        toggleButton.textContent = "Click to expand eBay results";
      }
    });
  });
  
  
  