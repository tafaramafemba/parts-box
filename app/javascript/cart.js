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

  


  document.addEventListener("scroll", () => {
    const scrollTopBtn = document.getElementById("scrollTopBtn");
    if (window.scrollY > 200) {
      scrollTopBtn.classList.add("show");
    } else {
      scrollTopBtn.classList.remove("show");
    }
  });
  
  document.getElementById("scrollTopBtn").addEventListener("click", () => {
    window.scrollTo({ top: 0, behavior: "smooth" });
  });
  
  