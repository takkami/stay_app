document.addEventListener("turbo:load", () => {
  const menu = document.querySelector("[data-user-menu]");
  if (!menu) return;

  const button = menu.querySelector("[data-user-menu-button]");
  const dropdown = menu.querySelector("[data-user-menu-dropdown]");
  if (!button || !dropdown) return;

  const open = () => {
    dropdown.hidden = false;
    button.setAttribute("aria-expanded", "true");
  };

  const close = () => {
    dropdown.hidden = true;
    button.setAttribute("aria-expanded", "false");
  };

  const toggle = () => {
    if (dropdown.hidden) open();
    else close();
  };

  button.addEventListener("click", (e) => {
    e.preventDefault();
    toggle();
  });

  document.addEventListener("click", (e) => {
    if (!menu.contains(e.target)) close();
  });
});