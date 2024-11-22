// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "../assets/javascripts/sidebar"
import * as bootstrap from "bootstrap"

import jQuery from "jquery"

// document.addEventListener('DOMContentLoaded', () => {
//     const filterButtons = document.querySelectorAll('.filter-btn');
//     const items = document.querySelectorAll('.item-card');
//
//     filterButtons.forEach(button => {
//         button.addEventListener('click', () => {
//             const filter = button.getAttribute('data-filter');
//             items.forEach(item => {
//                 if (filter === 'all' || item.getAttribute('data-category') === filter) {
//                     item.style.display = 'block';
//                 } else {
//                     item.style.display = 'none';
//                 }
//             });
//         });
//     });
// });

window.jQuery = jQuery
window.$ = jQuery