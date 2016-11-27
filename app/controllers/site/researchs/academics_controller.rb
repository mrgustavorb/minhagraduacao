class Site::Researchs::AcademicsController < Site::ApplicationController

  before_filter :authenticate_user!
  before_filter :user_answered_research?
  before_filter :set_states

  def research
  end

  def save
    unless validation_params_academic
      render action: 'research'
      return false
    end

    #Profile
    current_user.user_profile.institution_id = params[:academic][:user_profile][:institution_id]
    current_user.user_profile.graduation_id  = params[:academic][:user_profile][:graduation_id]
    current_user.user_profile.semester       = params[:academic][:user_profile][:semester]
    current_user.user_profile.gender         = params[:academic][:user_profile][:gender]

    # Get id graduation group
    graduation = Graduation.find current_user.user_profile.graduation_id

    # Evaluation Graduation
    evaluation_graduations                       = EvaluationGraduation.new
    evaluation_graduations.user_id               = current_user.id
    evaluation_graduations.graduation_group_id   = graduation.graduation_group.id
    evaluation_graduations.social_recognition    = params[:academic][:evaluation_graduations][:social_recognition]  
    evaluation_graduations.graduation_difficulty = params[:academic][:evaluation_graduations][:graduation_difficulty] 
    evaluation_graduations.renumbered_training   = params[:academic][:evaluation_graduations][:renumbered_training] 
    evaluation_graduations.first_job             = params[:academic][:evaluation_graduations][:first_job] 
    evaluation_graduations.job_most_areas        = params[:academic][:evaluation_graduations][:job_most_areas] 
    evaluation_graduations.tendering             = params[:academic][:evaluation_graduations][:tendering] 
    evaluation_graduations.advantage             = params[:academic][:evaluation_graduations][:advantage] 
    evaluation_graduations.disadvantage          = params[:academic][:evaluation_graduations][:disadvantage] 
    evaluation_graduations.recommendation        = params[:academic][:evaluation_graduations][:recommendation] 
    evaluation_graduations.save!

    # Evaluation Institution
    evaluation_institutions                          = EvaluationInstitution.new
    evaluation_institutions.institution_id           = params[:academic][:user_profile][:institution_id]
    evaluation_institutions.user_id                  = current_user.id
    evaluation_institutions.accreditation            = params[:academic][:evaluation_institutions][:accreditation] 
    evaluation_institutions.website_academic         = params[:academic][:evaluation_institutions][:website_academic] 
    evaluation_institutions.professor                = params[:academic][:evaluation_institutions][:professor] 
    evaluation_institutions.level_students           = params[:academic][:evaluation_institutions][:level_students] 
    evaluation_institutions.money                    = params[:academic][:evaluation_institutions][:money] 
    evaluation_institutions.student_organizations    = params[:academic][:evaluation_institutions][:student_organizations] 
    evaluation_institutions.sector_stage             = params[:academic][:evaluation_institutions][:sector_stage] 
    evaluation_institutions.security                 = params[:academic][:evaluation_institutions][:security] 
    evaluation_institutions.pratical_activities      = params[:academic][:evaluation_institutions][:pratical_activities] 
    evaluation_institutions.infrastructure           = params[:academic][:evaluation_institutions][:infrastructure] 
    evaluation_institutions.academic_exchange        = params[:academic][:evaluation_institutions][:academic_exchange] 
    evaluation_institutions.advantage                = params[:academic][:evaluation_institutions][:advantage] 
    evaluation_institutions.disadvantage             = params[:academic][:evaluation_institutions][:disadvantage] 
    evaluation_institutions.recommendation           = params[:academic][:evaluation_institutions][:recommendation] 
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

    def validation_params_academic

      # Profile
      if params[:academic][:user_profile][:institution_id].blank?
        flash.now[:alert] = "Selecione a faculdade que você estuda."
        return false
      end

      if params[:academic][:user_profile][:graduation_id].blank?
        flash.now[:alert] = "Qual graduação você está cursando?"
        return false
      end

      if params[:academic][:user_profile][:semester].blank?
        flash.now[:alert] = "Informe o seu semestre."
        return false
      end

      if params[:academic][:user_profile][:gender].blank?
        flash.now[:alert] = "Informe o seu genero."
        return false
      end
      
      #Evaluation Graduation
      if params[:academic][:evaluation_graduations][:social_recognition].blank? or !params[:academic][:evaluation_graduations][:social_recognition].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.social_recognition')
          return false    
      end

      if params[:academic][:evaluation_graduations][:graduation_difficulty].blank? or !params[:academic][:evaluation_graduations][:graduation_difficulty].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.graduation_difficulty')
          return false
      end

      if params[:academic][:evaluation_graduations][:renumbered_training].blank? or !params[:academic][:evaluation_graduations][:renumbered_training].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.renumbered_training')
          return false
      end
      
      if params[:academic][:evaluation_graduations][:first_job].blank? or !params[:academic][:evaluation_graduations][:first_job].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.first_job')
          return false
      end

      if params[:academic][:evaluation_graduations][:job_most_areas].blank? or !params[:academic][:evaluation_graduations][:job_most_areas].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.job_most_areas')
          return false
      end

      if params[:academic][:evaluation_graduations][:tendering].blank? or !params[:academic][:evaluation_graduations][:tendering].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.tendering')
          return false
      end

      if params[:academic][:evaluation_graduations][:advantage].blank?
          flash.now[:alert] = "Informe os pontos positivos."
          return false
      end

      if params[:academic][:evaluation_graduations][:disadvantage].blank?
          flash.now[:alert] = "Informe os pontos negativos."
          return false
      end

      if params[:academic][:evaluation_graduations][:recommendation].blank? or !params[:academic][:evaluation_graduations][:recommendation].to_i.between?(0,10)
          flash.now[:alert] = "O quanto você recomendaria a sua graduação a um amigo?"
          return false
      end


      # #Evaluation Institutions
      if params[:academic][:evaluation_institutions][:accreditation].blank? or !params[:academic][:evaluation_institutions][:accreditation].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.accreditation')
          return false
      end

      if params[:academic][:evaluation_institutions][:website_academic].blank? or !params[:academic][:evaluation_institutions][:website_academic].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.website_academic')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:professor].blank? or !params[:academic][:evaluation_institutions][:professor].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.professor')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:level_students].blank? or !params[:academic][:evaluation_institutions][:level_students].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.level_students')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:money].blank? or !params[:academic][:evaluation_institutions][:money].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.money')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:student_organizations].blank? or !params[:academic][:evaluation_institutions][:student_organizations].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.student_organizations')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:sector_stage].blank? or !params[:academic][:evaluation_institutions][:sector_stage].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.sector_stage')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:security].blank? or !params[:academic][:evaluation_institutions][:security].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.security')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:pratical_activities].blank? or !params[:academic][:evaluation_institutions][:pratical_activities].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.pratical_activities')
          return false
      end
      
      if params[:academic][:evaluation_institutions][:infrastructure].blank? or !params[:academic][:evaluation_institutions][:infrastructure].to_i.between?(0,10)
         flash.now[:alert] = t('research.forms.academics_professionals.infrastructure')
         return false
      end
      
      if params[:academic][:evaluation_institutions][:academic_exchange].blank? or !params[:academic][:evaluation_institutions][:academic_exchange].to_i.between?(0,10)
          flash.now[:alert] = t('research.forms.academics_professionals.academic_exchange')
          return false
      end

      if params[:academic][:evaluation_institutions][:advantage].blank?
         flash.now[:alert] = "Informe os pontos positivos."
          return false
      end

      if params[:academic][:evaluation_institutions][:disadvantage].blank?
         flash.now[:alert] = "Informe os pontos negativos."
         return false
      end
      
      if params[:academic][:evaluation_institutions][:recommendation].blank? or !params[:academic][:evaluation_institutions][:recommendation].to_i.between?(0,10)
         flash.now[:alert] = "O quanto você recomendaria a sua faculdade a um amigo?"
         return false
      end

      return true

    end
end
