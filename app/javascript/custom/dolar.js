document.addEventListener("turbo:load", () => {
    const dolarAmount = document.getElementById("dolar-amount");
    const refreshIcon = document.getElementById("refresh-dollar");
  
    if (!dolarAmount || !refreshIcon) return;
  
    function fetchDolar() {
      
  
      fetch("/exchange_rate/dolar")
        .then(res => res.json())
        .then(data => {
          if (data.blue) {
            dolarAmount.textContent = `u$d ${data.blue.toFixed(2)}`;
          } else {
            dolarAmount.textContent = "Error";
          }
        })
        .catch(() => {
          dolarAmount.textContent = "Error";
        })
        .finally(() => {
          refreshIcon.classList.remove("fa-spin");
        });
    }
  
    // Actualiza al cargar la página
    fetchDolar();
  
    // Delegación global: escucha clicks en todo el body
    document.body.addEventListener("click", (e) => {
      dolarAmount.textContent = "Cargando..."
      if (e.target && (e.target.id === "refresh-dollar" || e.target.closest("#refresh-dollar"))) {
        fetchDolar();
      }
    });
  });