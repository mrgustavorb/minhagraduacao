class Site::Researchs::ProfessionalsController < Site::ApplicationController

  before_filter :authenticate_user!
  before_filter :user_answered_research?
  before_filter :set_states

  def research
  end

  def save
    unless validation_params_professional
      render action: 'research'
      return false
    end

    #Profile
    current_user.user_profile.institution_id = params[:professional][:user_profile][:institution_id]
    current_user.user_profile.graduation_id  = params[:professional][:user_profile][:graduation_id]
    current_user.user_profile.city           = params[:professional][:user_profile][:city]
    current_user.user_profile.gender         = params[:professional][:user_profile][:gender]
    current_user.user_profile.job_title      = params[:professional][:user_profile][:job_title]

    # Get id graduation group
    graduation = Graduation.find current_user.user_profile.graduation_id

    # Evaluation Graduation
    evaluation_graduations                         = EvaluationGraduation.new
    evaluation_graduations.user_id                 = current_user.id
    evaluation_graduations.graduation_group_id     = graduation.graduation_group.id    
    evaluation_graduations.graduation_professional = params[:professional][:evaluation_graduations][:graduation_professional]
    evaluation_graduations.social_recognition      = params[:professional][:evaluation_graduations][:social_recognition]
    evaluation_graduations.graduation_difficulty   = params[:professional][:evaluation_graduations][:graduation_difficulty]
    evaluation_graduations.renumbered_training     = params[:professional][:evaluation_graduations][:renumbered_training]
    evaluation_graduations.first_job               = params[:professional][:evaluation_graduations][:first_job]
    evaluation_graduations.job_most_areas          = params[:professional][:evaluation_graduations][:job_most_areas]
    evaluation_graduations.tendering               = params[:professional][:evaluation_graduations][:tendering]
    evaluation_graduations.starting_salary         = params[:professional][:evaluation_graduations][:starting_salary]
    evaluation_graduations.professional_salary     = params[:professional][:evaluation_graduations][:professional_salary]
    evaluation_graduations.advantage               = params[:professional][:evaluation_graduations][:advantage]
    evaluation_graduations.disadvantage            = params[:professional][:evaluation_graduations][:disadvantage]
    evaluation_graduations.recommendation          = params[:professional][:evaluation_graduations][:recommendation]
    evaluation_graduations.save!

    # Evaluation Institution
    evaluation_institutions                         = EvaluationInstitution.new
    evaluation_institutions.institution_id          = params[:professional][:user_profile][:institution_id]
    evaluation_institutions.user_id                 = current_user.id
    evaluation_institutions.accreditation           = params[:professional][:evaluation_institutions][:accreditation]
    evaluation_institutions.website_academic        = params[:professional][:evaluation_institutions][:website_academic]
    evaluation_institutions.professor               = params[:professional][:evaluation_institutions][:professor]
    evaluation_institutions.level_students          = params[:professional][:evaluation_institutions][:level_students]
    evaluation_institutions.money                   = params[:professional][:evaluation_institutions][:money]
    evaluation_institutions.student_organizations   = params[:professional][:evaluation_institutions][:student_organizations]
    evaluation_institutions.sector_stage            = params[:professional][:evaluation_institutions][:sector_stage]
    evaluation_institutions.security                = params[:professional][:evaluation_institutions][:security]
    evaluation_institutions.pratical_activities     = params[:professional][:evaluation_institutions][:pratical_activities]
    evaluation_institutions.infrastructure          = params[:professional][:evaluation_institutions][:infrastructure]
    evaluation_institutions.academic_exchange       = params[:professional][:evaluation_institutions][:academic_exchange]
    evaluation_institutions.advantage               = params[:professional][:evaluation_institutions][:advantage]
    evaluation_institutions.disadvantage            = params[:professional][:evaluation_institutions][:disadvantage]
    evaluation_institutions.recommendation          = params[:professional][:evaluation_institutions][:recommendation]
    evaluation_institutions.save!
    
    current_user.answered = true  
    current_user.save!

    respond_to do |format|
      format.html{ redirect_to graduation_evaluations_path(graduation.graduation_group.url_friendly), notice: 'Muito Obrigado!' }
    end
  end

  private

    def set_states
      @states = Uf.order(:sigla)
    end

    def validation_params_professional

      #Profile
      if params[:professional][:user_profile][:institution_id].blank?
        flash.now[:alert] = "Selecione a faculdade que você estudou."
        return false
      end

      if params[:professional][:user_profile][:graduation_id].blank?
        flash.now[:alert] = "Qual graduação você cursou?"
        return false
      end

      if params[:professional][:user_profile][:city].blank?
        flash.now[:alert] = "Onde você mora atualmente?"
        return false
      end

      if params[:professional][:user_profile][:gender].blank?
        flash.now[:alert] = "Informe o seu genero."
        return false
      end

      if params[:professional][:user_profile][:job_title].blank?
        flash.now[:alert] = "Nos Informe o seu cargo."
        return false
      end

      #Evaluation Graduation
      if params[:professional][:evaluation_graduations][:graduation_professional].blank? or !params[:professional][:evaluation_graduations][:graduation_professional].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.graduation_professional')            
          return false
      end

      if params[:professional][:evaluation_graduations][:social_recognition].blank? or !params[:professional][:evaluation_graduations][:social_recognition].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.social_recognition')
          return false    
      end

      if params[:professional][:evaluation_graduations][:graduation_difficulty].blank? or !params[:professional][:evaluation_graduations][:graduation_difficulty].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.graduation_difficulty')
          return false
      end

      if params[:professional][:evaluation_graduations][:renumbered_training].blank? or !params[:professional][:evaluation_graduations][:renumbered_training].to_i.between?(0,10)
         flash.now[:alert] = t('research.forms.academics_professionals.renumbered_training')
         return false
      end

      if params[:professional][:evaluation_graduations][:first_job].blank? or !params[:professional][:evaluation_graduations][:first_job].to_i.between?(0,10)
         flash.now[:alert] = t('research.forms.academics_professionals.first_job')
         return false
      end

      if params[:professional][:evaluation_graduations][:job_most_areas].blank? or !params[:professional][:evaluation_graduations][:job_most_areas].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.job_most_areas')
          return false
      end

      if params[:professional][:evaluation_graduations][:tendering].blank? or !params[:professional][:evaluation_graduations][:tendering].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.tendering')
          return false
      end

      if params[:professional][:evaluation_graduations][:starting_salary].blank?
          flash.now[:alert] = "Qual, em média, é o salário inicial no seu curso?"
          return false
      end

      if params[:professional][:evaluation_graduations][:professional_salary].blank?
          flash.now[:alert] = "Qual o salário, em média, de um profissional que ocupa um cargo parecido com o seu?"
          return false
      end

      if params[:professional][:evaluation_graduations][:advantage].blank?
          flash.now[:alert] = "Informe os pontos positivos."
          return false
      end

      if params[:professional][:evaluation_graduations][:disadvantage].blank?
          flash.now[:alert] = "Informe os pontos negativos."
          return false
      end

      if params[:professional][:evaluation_graduations][:recommendation].blank? or !params[:professional][:evaluation_graduations][:recommendation].to_i.between?(0,10)
          flash.now[:alert] = "O quanto você recomendaria a sua graduação a um amigo?"
          return false
      end


      # #Evaluation Institutions
      if params[:professional][:evaluation_institutions][:accreditation].blank? or !params[:professional][:evaluation_institutions][:accreditation].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.accreditation')
          return false
      end

      if params[:professional][:evaluation_institutions][:website_academic].blank? or !params[:professional][:evaluation_institutions][:website_academic].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.website_academic')
          return false
      end

      if params[:professional][:evaluation_institutions][:professor].blank? or !params[:professional][:evaluation_institutions][:professor].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.professor')
          return false
      end

      if params[:professional][:evaluation_institutions][:level_students].blank? or !params[:professional][:evaluation_institutions][:level_students].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.level_students')
          return false
      end

      if params[:professional][:evaluation_institutions][:money].blank? or !params[:professional][:evaluation_institutions][:money].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.money')
          return false
      end

      if params[:professional][:evaluation_institutions][:student_organizations].blank? or !params[:professional][:evaluation_institutions][:student_organizations].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.student_organizations')
          return false
      end

      if params[:professional][:evaluation_institutions][:sector_stage].blank? or !params[:professional][:evaluation_institutions][:sector_stage].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.sector_stage')
          return false
      end

      if params[:professional][:evaluation_institutions][:security].blank? or !params[:professional][:evaluation_institutions][:security].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.security')
          return false
      end

      if params[:professional][:evaluation_institutions][:pratical_activities].blank? or !params[:professional][:evaluation_institutions][:pratical_activities].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.pratical_activities')
          return false
      end

      if params[:professional][:evaluation_institutions][:infrastructure].blank? or !params[:professional][:evaluation_institutions][:infrastructure].to_i.between?(0,10)
         flash.now[:alert] = t('research.forms.academics_professionals.infrastructure')
         return false
      end

      if params[:professional][:evaluation_institutions][:academic_exchange].blank? or !params[:professional][:evaluation_institutions][:academic_exchange].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.academic_exchange')
          return false
      end

      if params[:professional][:evaluation_institutions][:advantage].blank?
         flash.now[:alert] = "Informe os pontos positivos."
          return false
      end

      if params[:professional][:evaluation_institutions][:disadvantage].blank?
         flash.now[:alert] = "Informe os pontos negativos."
         return false
      end

      if params[:professional][:evaluation_institutions][:recommendation].blank? or !params[:professional][:evaluation_institutions][:recommendation].to_i.between?(0,10)
         flash.now[:alert] = "O quanto você recomendaria a sua faculdade a um amigo?"
         return false
      end

      return true
    end
end