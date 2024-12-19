document.addEventListener("turbo:load", function () {
    const features = document.querySelectorAll(".feature");
  
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("fade-in");
          }
        });
      },
      { threshold: 0.5 }
    );
  
    features.forEach((feature) => {
      observer.observe(feature);
    });
  });

  