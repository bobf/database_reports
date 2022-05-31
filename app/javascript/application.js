// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "controllers";

import { Turbo } from "@hotwired/turbo-rails";
Turbo.session.drive = true;

document.querySelectorAll('input.schedule-type').forEach((item) => {
  item.onclick = () => {
    const scheduleTime = document.querySelector('input.schedule-time');
    const scheduleDay = document.querySelector('select.schedule-day');

    switch (item.value) {
      case 'weekly':
        scheduleTime.disabled = false;
        scheduleDay.disabled = false;
        return;
      case 'daily':
        scheduleTime.disabled = false;
        scheduleDay.disabled = true;
        return;
      case 'none':
        scheduleTime.disabled = true;
        scheduleDay.disabled = true;
        return;
    };
  };
});
