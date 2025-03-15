document.addEventListener("turbo:load", () => {
    document.removeEventListener("click", toggleSidebar);
    document.addEventListener("click", toggleSidebar);
  });
  
  function toggleSidebar(event) {
    const sidebarToggle = event.target.closest("#sidebarToggle"); // Asegura que el click fue en el botón correcto
    if (sidebarToggle) {
      event.preventDefault();
      document.body.classList.toggle("sb-sidenav-toggled");
      localStorage.setItem("sb|sidebar-toggle", document.body.classList.contains("sb-sidenav-toggled"));
    }
  }