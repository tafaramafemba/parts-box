document.addEventListener('DOMContentLoaded', function () {
  const steps = document.querySelectorAll('.step');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('show');
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0 });

  steps.forEach((step) => observer.observe(step));
});

  


document.addEventListener("DOMContentLoaded", () => {
  const scrollTopBtn = document.getElementById("scrollTopBtn");

  if (!scrollTopBtn) {
    console.error("scrollTopBtn not found in the DOM");
    return;
  }

  // Show or hide the button based on scroll position
  document.addEventListener("scroll", () => {
    if (window.scrollY > 200) {
      scrollTopBtn.classList.add("show");
    } else {
      scrollTopBtn.classList.remove("show");
    }
  });

  // Scroll to the top when the button is clicked
  scrollTopBtn.addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
});
  
  