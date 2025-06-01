document.addEventListener("turbo:load", () => {
    const addVehicleBtn = document.getElementById("add-vehicle");
    const vehiclesTable = document.querySelector("table tbody");
  
    if (!addVehicleBtn || !vehiclesTable) return;
  
    addVehicleBtn.addEventListener("click", () => {
      const timestamp = new Date().getTime();
      const newRow = `
        <tr>
          <td><input type="text" name="user[vehicles_attributes][${timestamp}][license_plate]" class="form-control" /></td>
          <td><input type="text" name="user[vehicles_attributes][${timestamp}][brand]" class="form-control" /></td>
          <td><input type="text" name="user[vehicles_attributes][${timestamp}][model]" class="form-control" /></td>
          <td><input type="number" name="user[vehicles_attributes][${timestamp}][year]" class="form-control" /></td>
          <td>
            <input type="hidden" name="user[vehicles_attributes][${timestamp}][_destroy]" value="false" />
            <button type="button" class="btn btn-danger remove-vehicle">Eliminar</button>
          </td>
        </tr>
      `;
      vehiclesTable.insertAdjacentHTML("beforeend", newRow);
      attachRemoveHandlers();
    });
  
    function attachRemoveHandlers() {
      document.querySelectorAll(".remove-vehicle").forEach((btn) => {
        btn.addEventListener("click", (e) => {
          const row = e.target.closest("tr");
          row.querySelector("input[type='hidden']").value = "1";
          row.style.display = "none";
        });
      });
    }
  
    attachRemoveHandlers();
  });