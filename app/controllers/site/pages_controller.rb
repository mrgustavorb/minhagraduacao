class Site::PagesController < Site::ApplicationController

  before_filter :authenticate_user!, only: [:choice_scholarity, :choice_scholarity_save]

  def index
    @evaluations_graduations = EvaluationGraduation.limit(3).order('created_at DESC')
  end

  def choice_scholarity
    if current_user.answered && current_user.user_profile.scholarity != 0
      redirect_to choice_scholarity_path      
    end
  end

  def choice_scholarity_save
    if !current_user.answered && current_user.user_profile.scholarity == 0
      current_user.user_profile.scholarity = params[:id]
      current_user.save!

      redirect_to which_user_research?
    else
      redirect_to root_path  
    end  
  end

  def contact
    @contact = Contact.new
  end

  def contact_send
    @contact = Contact.new params.require(:contact).permit(:name, :email, :message)
    if @contact.valid? && UserMailer.contact_email(@contact.name, @contact.email, @contact.message).deliver
      flash[:notice] = "E-mail enviado com sucesso, obrigado."
      redirect_to action: :contact
    else
      flash[:error] = @contact.errors.full_messages.to_sentence
      render :contact
    end
  end

  def term_of_use; end

end
