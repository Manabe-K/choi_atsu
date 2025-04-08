// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import './menu_toggle'

document.addEventListener('turbo:load', function() {
  const profileButton = document.getElementById('profile-button');
  const dropdownMenu = document.getElementById('dropdown-menu');

  // プロフィールボタンがクリックされたとき
  profileButton.addEventListener('click', function() {
    dropdownMenu.classList.toggle('hidden');
  });

  // メニュー外をクリックしたときにメニューを閉じる
  document.addEventListener('click', function(event) {
    if (!profileButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
      dropdownMenu.classList.add('hidden');
    }
  });
});