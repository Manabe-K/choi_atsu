document.addEventListener('DOMContentLoaded', function() {
  const menuToggleBtn = document.getElementById('menu-toggle');
  const sideMenu = document.getElementById('side-menu');

  if (menuToggleBtn && sideMenu) {
    menuToggleBtn.addEventListener('click', function() {
      sideMenu.classList.toggle('hidden');
    });
  }
});