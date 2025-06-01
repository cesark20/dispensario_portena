document.addEventListener("turbo:load", () => {
  const searchInput = document.getElementById("search-input");
  const searchResults = document.getElementById("search-results");
  const itemsTable = document.getElementById("selected-items");
  const removedItemsInput = document.getElementById("removed-items");

  if (!searchInput || !searchResults || !itemsTable || !removedItemsInput) return;

  let removedItems = [];

  // Eliminar ítems existentes (guardados en la base de datos)
  document.querySelectorAll(".remove-item").forEach(button => {
    button.addEventListener("click", function () {
      const row = this.closest("tr");
      const itemId = this.dataset.itemId;

      if (itemId) {
        removedItems.push(itemId);
        removedItemsInput.value = removedItems.join(",");
      }

      row.remove();
    });
  });

  searchInput.addEventListener("input", function () {
    const query = this.value.trim();

    if (query.length > 2) {
      fetch(`/budgets/search_items?query=${query}`)
        .then(response => response.json())
        .then(data => {
          searchResults.innerHTML = "";
          searchResults.style.display = "none";

          if (data.length === 0) return;

          searchResults.style.display = "block";

          data.forEach(item => {
            const li = document.createElement("li");
            li.classList.add("list-group-item", "list-group-item-action");
            li.textContent = `${item.name} - $${parseFloat(item.price || 0).toFixed(2)} (${item.category})`;
            li.dataset.item = JSON.stringify(item);

            li.addEventListener("click", function () {
              addItemToTable(JSON.parse(this.dataset.item));
              searchResults.style.display = "none";
              searchInput.value = "";
            });

            searchResults.appendChild(li);
          });
        })
        .catch(error => console.error("❌ Error fetching items:", error));
    } else {
      searchResults.style.display = "none";
    }
  });

  function addItemToTable(item) {
    const row = document.createElement("tr");
    const rowIndex = document.querySelectorAll("#selected-items tr").length;

    row.innerHTML = `
      <td>
          ${item.name}
          <input type="hidden" name="budget[items][${rowIndex}][id]" value="${item.id}">
          <input type="hidden" name="budget[items][${rowIndex}][name]" value="${item.name}">
          <input type="hidden" name="budget[items][${rowIndex}][category]" value="${item.category}">
          <input type="hidden" name="budget[items][${rowIndex}][price]" value="${item.price}">
      </td>
      <td>${item.category}</td>
      <td>$${parseFloat(item.price || 0).toFixed(2)}</td>
      <td><input type="number" name="budget[items][${rowIndex}][quantity]" min="1" value="1" class="form-control quantity"></td>
      <td style="text-align: center">
        <button class="btn btn-danger btn-sm remove-item"><i class="fa-solid fa-trash"></i></button>
      </td>
    `;

    itemsTable.appendChild(row);

    row.querySelector(".remove-item").addEventListener("click", function () {
      row.remove();
    });
  }
});