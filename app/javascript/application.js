import "@hotwired/turbo-rails"
import "./controllers"
import './menu_toggle'
import "./event_card_click";

document.addEventListener('turbo:load', function() {
  const profileButton = document.getElementById('profile-button');
  const dropdownMenu = document.getElementById('dropdown-menu');

  if (profileButton && dropdownMenu) {
    profileButton.addEventListener('click', function() {
      dropdownMenu.classList.toggle('hidden');
    });

    document.addEventListener('click', function(event) {
      if (!profileButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
        dropdownMenu.classList.add('hidden');
      }
    });
  }
});