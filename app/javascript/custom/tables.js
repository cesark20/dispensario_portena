document.addEventListener("turbo:load", () => {
  if (!$.fn.DataTable.isDataTable("#expensesTable")) {
    $("#expensesTable").DataTable({
      responsive: true,
      language: {
        url: "/locales/es-ES.json"
      }
    });
  }
});