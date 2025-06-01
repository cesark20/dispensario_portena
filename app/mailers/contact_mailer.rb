class ContactMailer < ApplicationMailer
    default to: "info@overroad.com.ar"
    # default to: "cesark20@gmail.com"
  
    def contact_message(name, email, message)
      @name = name
      @email = email
      @message = message
      
      hash = Time.now.to_i

      mail(
        from: email,
        subject: "📩 Nuevo mensaje desde el sitio web - #{hash}"
      )
    end
  end