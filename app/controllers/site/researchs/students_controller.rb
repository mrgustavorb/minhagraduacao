class Site::Researchs::StudentsController < Site::ApplicationController
  
  before_filter :authenticate_user!
  before_filter :user_answered_research?

  def research
  end

  def save
    unless validation_params_student
      render action: 'research'
      return false
    end

    # Profile 
    current_user.user_profile.school_id = params[:student][:profile][:school_id].to_i
    current_user.user_profile.grade     = params[:student][:profile][:grade]
    current_user.user_profile.gender    = params[:student][:profile][:gender]

    # Evaluation Schools 
    evaluation_school = EvaluationSchool.new
    evaluation_school.school_id           = current_user.user_profile.school_id
    evaluation_school.user_id             = current_user.id
    evaluation_school.security            = params[:student][:evaluation_schools][:security]
    evaluation_school.teachers            = params[:student][:evaluation_schools][:teachers]
    evaluation_school.coordinator         = params[:student][:evaluation_schools][:coordinator]
    evaluation_school.laboratory          = params[:student][:evaluation_schools][:laboratory]
    evaluation_school.physical_structure  = params[:student][:evaluation_schools][:physical_structure]
    evaluation_school.classmates          = params[:student][:evaluation_schools][:classmates]
    evaluation_school.methodology         = params[:student][:evaluation_schools][:methodology]
    evaluation_school.extra_activities    = params[:student][:evaluation_schools][:extra_activities]
    evaluation_school.sports_activities   = params[:student][:evaluation_schools][:sports_activities]
    evaluation_school.recommendation      = params[:student][:evaluation_schools][:recommendation]
    evaluation_school.save!

    # Favorite Graduation  
    params[:student][:favorite_graduation][:graduation_id].split(/,/).each do |graduation_id|
      favorite_graduation                     = FavoriteGraduation.new
      favorite_graduation.user_id             = current_user.id
      favorite_graduation.graduation_group_id = graduation_id
      favorite_graduation.save!
    end
    
    # Favorite Instituion
    params[:student][:favorite_institutions][:institution_id].split(/,/).each do |institution_id|
      favorite_institutions = FavoriteInstitution.new
      favorite_institutions.user_id        = current_user.id
      favorite_institutions.institution_id = institution_id
      favorite_institutions.save!
    end

    # Evaluation Institutions 
    evaluation_institutions = EvaluationInstitution.new
    evaluation_institutions.user_id                      = current_user.id
    evaluation_institutions.accreditation                = params[:student][:evaluation_institutions][:accreditation]
    evaluation_institutions.infrastructure               = params[:student][:evaluation_institutions][:infrastructure]
    evaluation_institutions.professor                    = params[:student][:evaluation_institutions][:professor]
    evaluation_institutions.coordinator                  = params[:student][:evaluation_institutions][:coordinator]
    evaluation_institutions.money                        = params[:student][:evaluation_institutions][:money]
    evaluation_institutions.level_students               = params[:student][:evaluation_institutions][:level_students]
    evaluation_institutions.extra_activities             = params[:student][:evaluation_institutions][:extra_activities]
    evaluation_institutions.sports_activities            = params[:student][:evaluation_institutions][:sports_activities]
    evaluation_institutions.academic_exchange            = params[:student][:evaluation_institutions][:academic_exchange]
    evaluation_institutions.save!

    current_user.answered = true
    current_user.save!

    respond_to do |format|
        format.html { redirect_to graduations_path, notice: 'Muito obrigado!' }
    end  
  end

  private

    def validation_params_student

      # Profile 
      if params[:student][:profile][:school_id].blank?
        flash.now[:alert] = "Nenhuma escola foi selecionada."
        return false
      end

      if params[:student][:profile][:grade].blank?
        flash.now[:alert] = "Informe a sua série."
        return false
      end

      if params[:student][:profile][:gender].blank?
        flash.now[:alert] = "Informe o seu genero."
        return false
      end

      # Evaluation Schools 
      if params[:student][:evaluation_schools][:security].blank? or !params[:student][:evaluation_schools][:security].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.security')
        return false
      end

      if params[:student][:evaluation_schools][:teachers].blank? or !params[:student][:evaluation_schools][:teachers].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.teachers')
        return false
      end

      if params[:student][:evaluation_schools][:coordinator].blank? or !params[:student][:evaluation_schools][:coordinator].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.coordinators')
        return false
      end

      if params[:student][:evaluation_schools][:laboratory].blank? or !params[:student][:evaluation_schools][:laboratory].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.laboratory')
        return false
      end

      if params[:student][:evaluation_schools][:physical_structure].blank? or !params[:student][:evaluation_schools][:physical_structure].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.physical_structure')
        return false
      end

      if params[:student][:evaluation_schools][:classmates].blank? or !params[:student][:evaluation_schools][:classmates].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.classmates')
        return false
      end

      if params[:student][:evaluation_schools][:methodology].blank? or !params[:student][:evaluation_schools][:methodology].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.methodology')
        return false
      end

      if params[:student][:evaluation_schools][:extra_activities].blank? or !params[:student][:evaluation_schools][:extra_activities].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.extra_activities')
        return false
      end

      if params[:student][:evaluation_schools][:sports_activities].blank? or !params[:student][:evaluation_schools][:sports_activities].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.sports_activities')
        return false
      end
      
      if params[:student][:evaluation_schools][:recommendation].blank? or !params[:student][:evaluation_schools][:recommendation].to_i.between?(0,10)
        flash.now[:alert] = "O quanto você recomendaria a sua escola a um amigo?"
        return false
      end

      # Favorite Graduation and Instituion
      if params[:student][:favorite_graduation][:graduation_id].blank? or params[:student][:favorite_graduation][:graduation_id].split(/,/).count == 0
        flash.now[:alert] = "Digite o nome de até três cursos que você tem interesse."
        return false
      end
      if params[:student][:favorite_institutions][:institution_id].blank? or params[:student][:favorite_institutions][:institution_id].split(/,/).count == 0
        flash.now[:alert] = "Digite o nome de até três faculdades que você tem interesse em estudar."
        return false
      end

      # Evaluation Institutions
      if params[:student][:evaluation_institutions][:accreditation].blank? or !params[:student][:evaluation_institutions][:accreditation].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.accreditation')
        return false
      end
      if params[:student][:evaluation_institutions][:infrastructure].blank? or !params[:student][:evaluation_institutions][:infrastructure].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.infrastructure')
        return false
      end
      if params[:student][:evaluation_institutions][:professor].blank? or !params[:student][:evaluation_institutions][:professor].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.professor')
        return false
      end
      if params[:student][:evaluation_institutions][:coordinator].blank? or !params[:student][:evaluation_institutions][:coordinator].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.coordinator')
        return false
      end
      if params[:student][:evaluation_institutions][:money].blank? or !params[:student][:evaluation_institutions][:money].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.money')
        return false
      end
      if params[:student][:evaluation_institutions][:level_students].blank? or !params[:student][:evaluation_institutions][:level_students].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.level_students')
        return false
      end
      if params[:student][:evaluation_institutions][:extra_activities].blank? or !params[:student][:evaluation_institutions][:extra_activities].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.extra_activities')
        return false
      end
       if params[:student][:evaluation_institutions][:sports_activities].blank? or !params[:student][:evaluation_institutions][:sports_activities].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.sports_activities')
        return false
      end
      if params[:student][:evaluation_institutions][:academic_exchange].blank? or !params[:student][:evaluation_institutions][:academic_exchange].to_i.between?(0,10)
        flash.now[:alert] = t('research.forms.students.academic_exchange')
        return false
      end

      return true
    end

end