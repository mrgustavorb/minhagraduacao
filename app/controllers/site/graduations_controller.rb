class Site::GraduationsController < Site::ApplicationController

  before_filter :authenticate_user!,   only: [:get_graduations]
  before_action :set_graduation_group, only: [:institutions, :about, :evaluations]
  before_action :set_evaluations,      only: [:about, :evaluations]
  before_filter :set_graduation_view,  only: [:about, :evaluations]

  # http://minhagraduacao.com/graduations/:institution_id
  def get_graduations
    institution = Institution.find(params[:institution_id])
    res = institution.graduations.order('name ASC').to_a.uniq.map { |graduation| [graduation.id, graduation.name] }
    render json: res
  end

  # http://minhagraduacao.com/graduacoes
  def list
    @graduations = GraduationGroup.order('name ASC')
  end

  def about
    render 'show'
  end

  # http://minhagraduacao.com/graduacao/:url_friendly/avaliacoes
  def evaluations  
    render 'show'
  end

  def institutions
    @institutions     = Institution.includes(:institution_profiles).find_by_sql(["select * from where_to_study(?, ?)", @graduation_group.id, 1])
    @ufs              = Institution.search_ufs @graduation_group.id
    @method_teachings = MethodTeaching.to_graduation @graduation_group.id
    
    render 'show'
  end

  private

    def set_evaluations
      EvaluationGraduation.select("COUNT(1) as total, 
                                   SUM(CASE WHEN user_profiles.scholarity = 3 THEN 1 ELSE 0 END) as total_professional,
                                   SUM(graduation_difficulty) as graduation_difficulty, 
                                   SUM(social_recognition) as social_recognition, 
                                   SUM(job_most_areas) as job_most_areas, 
                                   SUM(tendering) as tendering, 
                                   SUM(renumbered_training) as renumbered_training, 
                                   SUM(first_job) as first_job, 
                                   SUM(graduation_professional) as graduation_professional, 
                                   SUM(recommendation) as recommendation, 
                                   SUM(starting_salary) as starting_salary, 
                                   SUM(professional_salary) as professional_salary")
                          .joins("INNER JOIN user_profiles user_profiles ON user_profiles.user_id = evaluation_graduations.user_id")
                          .where(graduation_group_id: @graduation_group.id).each do |evaluations|
      @evaluations_avarege = { :total => evaluations.total, 
                               :total_professional => evaluations.total_professional, 
                               :graduation_difficulty => evaluations.graduation_difficulty, 
                               :social_recognition => evaluations.social_recognition, 
                               :job_most_areas => evaluations.job_most_areas, 
                               :tendering => evaluations.tendering, 
                               :renumbered_training => evaluations.renumbered_training, 
                               :first_job => evaluations.first_job, 
                               :graduation_professional => evaluations.graduation_professional, 
                               :recommendation => evaluations.recommendation,
                               :starting_salary => evaluations.starting_salary,
                               :professional_salary => evaluations.professional_salary }
      end

      @evaluations = EvaluationGraduation.where(graduation_group_id: @graduation_group.id).order('created_at DESC')
    end

    def set_graduation_group
      begin
        @graduation_group = GraduationGroup.find_by(url_friendly: params[:url_friendly])
        if @graduation_group.nil?
          raise "error"
        end    
      rescue => ex
        redirect_to root_path
      end 
    end

    def set_graduation_view
      @graduation_group.update(views: @graduation_group.views + 1)
      # @graduation_group.views += 1
      # @graduation_group.save!
    end
    
end