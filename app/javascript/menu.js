document.addEventListener('turbo:load', () => {
  const menuIconLabel = document.getElementById('menu-icon-label');
  const navMenu = document.getElementById('nav-menu');

  if (menuIconLabel && navMenu) {
    menuIconLabel.addEventListener('click', () => {
      menuIconLabel.classList.toggle('open');
      navMenu.classList.toggle('open');
    });
  }
});
