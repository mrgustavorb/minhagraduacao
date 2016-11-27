class Site::SearchController < Site::ApplicationController

  def search_suggest
    json = []
    text = params[:text].to_s.remover_acentos
    text = text.gsub(/\W/, ' ').gsub(/\s+/, ' ')
    GraduationGroup.search(text).each do |graduation|
      json.push({
        value: graduation.name,
        institutions: graduation.institutions.distinct.count,
        url: graduation.url_friendly
      })
    end

    render json: json
  end

  # def search_suggest
  #   @suggestions = GraduationGroup.fuzzy_search(name: params[:q])
  # end


  def search_school_suggest
    json = []
    text = params[:text].to_s.remover_acentos
    text = text.gsub(/\W/, ' ').gsub(/\s+/, ' ')

    @schools = School.find_by_sql(["select * from school_name(?)", text])
    @schools.each do |school|
      json.push({
        text: "#{school.uf_name} - #{school.city_name} - #{school.school_name}",
        value: school.school_id
      })
    end    

    render json: json
  end

  def search_graduations_tag
    json = []
    text = params[:text].to_s.remover_acentos
    text = text.gsub(/\W/, ' ').gsub(/\s+/, ' ')
    GraduationGroup.search(text).each do |graduation|
      json.push({
        text: graduation.name,
        value: graduation.id
      })
    end

    render json: json
  end

  def search_institutions_tag
    json = []
    text = params[:text].to_s.remover_acentos
    text = text.gsub(/\W/, ' ').gsub(/\s+/, ' ')
    Institution.search(text).each do |institution|
      json.push({
        text: "#{institution.sigla} - #{institution.name}",
        value: institution.id
      })
    end

    render json: json
  end

  def search
    term = params[:q].to_s.remover_acentos
    term = term.gsub(/\W/, ' ').gsub(/\s+/, ' ')
    unless term.present?
      redirect_to root_path
    end
      
    @graduation = GraduationGroup.find_by_url_friendly term.parameterize
    if @graduation.nil?
      @graduations = GraduationGroup.where 'name_noaccent ILIKE ?', "%#{term}%"
      if @graduations.count == 0
        @alternative_results = 1
        @graduations = GraduationGroup.where 'name_noaccent ILIKE ?', "#{term[0]}%"
      end
    else
      redirect_to graduation_about_path(@graduation.url_friendly)
    end
  end
 
end