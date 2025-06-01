require "prawn"

class BudgetPdf < Prawn::Document
  def initialize(budget, user)
    super()
    @budget = budget
    @user = user
    header
    company_and_client_details
    budget_items
    payment_terms
    footer_section
  end

  # def header
  #   text "Presupuesto Over Road ##{@budget.id}", size: 20, style: :bold, align: :center
  #   move_down 10
  # end

  def company_and_client_details
    y_position = cursor # guardamos la posición vertical actual
  
    # Columna izquierda (datos del cliente)
    bounding_box([0, y_position], width: bounds.width / 2 - 10) do
      text "#{@budget.user.name}", size: 14, style: :bold
      text "Calle y Nro: #{@budget.user.client_info.address}", size: 12
      text "CUIT/CUIL: #{@budget.user.client_info.tax_id}", size: 12
      text "IVA: #{@budget.user.client_info.business_name}", size: 12
      text "Patente del Vehículo: #{@budget.license_plate.upcase}", size: 12
      text "Fecha Presupuesto: #{@budget.date.strftime('%d/%m/%Y')}", size: 12, style: :italic
    end
  
    # Columna derecha (datos de la empresa)
    bounding_box([bounds.width / 2 + 10, y_position], width: bounds.width / 2 - 10) do
      text "OVER ROAD", size: 14, style: :bold, align: :right
      text "Av Velez Sarfield 3685 - Córdoba", size: 12, align: :right
      text "Tel/Fax: +54 9 351 761 5994", size: 12, align: :right
      text "E-mail: info@overroad.com.ar", size: 12, align: :right
    end
    move_down 50
  end
  

  def budget_items
    table_data = [["Nombre", "Precio", "Cant", "Subtotal"]]
    
    @budget.budget_items.each do |item|
      subtotal = item.unit_price * item.quantity * (1 - (item.discount.to_f / 100))
      table_data << [item.item.name, "$#{item.unit_price}", item.quantity, "$#{subtotal.round(2)}"]
    end

    # Ajustamos el ancho total de la tabla
    table_width = bounds.width

    # Distribución proporcional de los anchos de las columnas
    column_widths = {
    0 => table_width * 0.55,  # 50% del ancho total para "Nombre"
    1 => table_width * 0.15, # 15% para "Precio"
    2 => table_width * 0.10, # 15% para "Cantidad"
    3 => table_width * 0.20  # 20% para "Subtotal"
    }

    table(table_data, header: true, width: table_width, column_widths: column_widths) do
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
        self.cell_style = { border_width: 1, padding: [5, 5, 5, 5], size: 10  }
    end

    move_down 10
    text "Total: $#{@budget.total}", size: 14, style: :bold, align: :right
    move_down 5
    text "Son pesos: #{number_to_words(@budget.total)}", size: 12, style: :italic
  end


  def payment_terms
    move_down 20
    text "FORMA DE PAGO", size: 14, style: :bold

    move_down 5
    text "- Débito, crédito en 1 pago o transferencia: precio de lista", size: 12
    text "- Contado efectivo -5%", size: 12
    text "- 3 cuotas: +15% (con todas las tarjetas)", size: 12
    text "- 6 cuotas: +35% (con Visa o MasterCard de banco)", size: 12

    move_down 10
    text "ALIAS: cesark205", size: 8, style: :bold, align: :right
    text "Cuenta: Cesar Krampanis", size: 8, style: :bold, align: :right
    text "Banco: Santander Rio", size: 8, style: :bold, align: :right
  end

  # Nueva sección para agregar la observación final
  def footer_section
    move_down 20
    text "** EL PRESENTE PRESUPUESTO VALIDO POR 7 DIAS DESDE LA FECHA", size: 8, style: :italic, align: :center

    move_down 10
    move_down 10
    stroke_horizontal_rule
    move_down 10
    text "Observaciones:", size: 12, style: :bold
    move_down 5
    move_down 10
    move_down 10
    move_down 10
    stroke_horizontal_rule
    move_down 10

    text "ATENDIDO POR: #{@user.name}", size: 12
    move_down 5

    text "FIRMA", size: 12, align: :center

  end

  def header
    image_path = Rails.root.join("app/assets/images/logo.jpg") # Asegúrate de que el logo esté en esta ruta
    bounding_box([bounds.right - 100, bounds.top], width: 100) do
      image image_path, fit: [100, 100] # Ajusta el tamaño si es necesario
    end
  
    move_down 20
    text "Presupuesto Over Road ##{@budget.id}", size: 20, style: :bold, align: :center
    move_down 10
  end

  private

  # Método para convertir números a palabras (ejemplo: 96,671.72 => "NOVENTA Y SEIS MIL SEISCIENTOS SETENTA Y UNO CON SETENTA Y DOS CENTAVOS")
  def number_to_words(amount)
    require "humanize"
    amount.to_f.humanize(locale: :es).upcase
  end
end