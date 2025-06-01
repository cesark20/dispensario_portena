document.addEventListener("turbo:load", () => {
  if (!$.fn.DataTable.isDataTable("#expensesTable")) {
    $("#expensesTable").DataTable({
      responsive: true,
      language: {
        url: "/locales/es-ES.json"
      }
    });
  }

  if (!$.fn.DataTable.isDataTable("#generalTable")) {
    $("#generalTable").DataTable({
      responsive: true,
      language: {
        url: "/locales/es-ES.json"
      }
    });
  }
});