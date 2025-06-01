class BudgetMailer < ApplicationMailer
    default from: 'overload.argentina@gmail.com' # Podés cambiarlo por lo que uses
  
    def send_budget(budget, user)
        @budget = budget
      
        pdf = BudgetPdf.new(@budget, user).render
      
        attachments["Presupuesto_#{@budget.id}.pdf"] = {
          mime_type: 'application/pdf',
          content: pdf
        }
      
        mail(
          to: @budget.user.email,
          subject: "Presupuesto ##{@budget.id} de Over Road"
        )
    end
  end