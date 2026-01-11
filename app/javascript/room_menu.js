document.addEventListener("turbo:load", () => {
  const menus = document.querySelectorAll("[data-room-menu]");
  if (!menus.length) return;

  const closeAll = () => {
    menus.forEach((menu) => {
      const dropdown = menu.querySelector("[data-room-menu-dropdown]");
      const button = menu.querySelector("[data-room-menu-button]");
      if (!dropdown || !button) return;

      dropdown.hidden = true;
      button.setAttribute("aria-expanded", "false");
    });
  };

  menus.forEach((menu) => {
    const button = menu.querySelector("[data-room-menu-button]");
    const dropdown = menu.querySelector("[data-room-menu-dropdown]");
    if (!button || !dropdown) return;

    const open = () => {
      closeAll();
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
      e.stopPropagation();
      toggle();
    });

    // dropdown.addEventListener("click", (e) => {
    //   e.stopPropagation();
    // });
  });

  document.addEventListener("click", (e) => {
    const clickedInsideAnyMenu = Array.from(menus).some((menu) => menu.contains(e.target));
    if (!clickedInsideAnyMenu) closeAll();
  });

  // document.addEventListener("click", () => {
  //   closeAll();
  // });
});
