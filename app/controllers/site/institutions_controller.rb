class Site::InstitutionsController < Site::ApplicationController

  before_filter :authenticate_user!, only:   [:get_institutions]
  before_filter :set_institution_view, only: [:show]
  before_action :set_graduation_group, only: [:where_to_study, :ufs]
  
  # http://minhagraduacao.com/institutions/:uf_id
  def get_institutions
    res = Institution.where(uf_id: params[:uf_id]).order(:sigla).map { |i| [i.id, (i.sigla? ? "#{i.sigla} - #{i.name}" : i.name) ] }
    render json: res
  end

  def where_to_study
    @institutions = Institution.find_by_sql(["select * from where_to_study(?, ?)", params[:graduation_id], params[:method_teaching_id]])
    
    respond_to do |format|
      format.js { render "where_study" }
    end                        
  end

  def ufs
    @ufs = Institution.search_ufs @graduation_group.id
    respond_to do |format|
      format.json { render :json => @ufs}
    end                        
  end

  def where_to_study_in_a_state
    @graduation_group = GraduationGroup.find_by(id: params[:graduation_id])
    @institutions     = Institution.find_by_sql(["select * from where_to_study_in_a_state(?, ?)", params[:graduation_id], params[:uf_id]])
    respond_to do |format|
      format.js { render "where_study" }
    end                        
  end

  def where_to_study_in_a_city
    @graduation_group = GraduationGroup.find_by(id: params[:graduation_id])
    @institutions     = Institution.find_by_sql(["select * from where_to_study_in_a_city(?, ?)", params[:graduation_id], params[:city_id]])
    respond_to do |format|
      format.js { render "where_study" }
    end                        
  end

  def show
    @institution = Institution.find_by(url_friendly: params[:url_friendly_institution], id: params[:institution_id])

    if @institution.customer.nil?   
      @graduation_group  = GraduationGroup.find_by(url_friendly: params[:url_friendly_graduation])
      render 'show_no_customer'
    else
      @graduation         = @institution.graduations.joins(:graduation_group).select('graduations.id, graduation_groups.name, graduation_groups.id as group_id').find_by(graduation_groups: {url_friendly: params[:url_friendly_graduation]})
      @graduation_profile = @graduation.profile.make
    end
  end


  private

    def set_graduation_group
      @graduation_group = GraduationGroup.find_by(id: params[:graduation_id])
    end

    def set_institution_view
      @institution = Institution.find_by(url_friendly: params[:url_friendly_institution])
      @institution.views += 1
      @institution.save!
    end

end