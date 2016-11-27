# == Schema Information
#
# Table name: graduation_profiles
#
#  id                        :integer          not null, primary key
#  graduation_institution_id :integer
#  description               :text
#  coordination              :text
#  period                    :string(100)
#  hours                     :text
#  monthly_payment           :string(100)
#  video_link                :string(255)
#

class GraduationProfile < ActiveRecord::Base

  # Relationships
  # -------------
  belongs_to :connection, :class_name => "GraduationsInstitution", :foreign_key => "graduation_institution_id"
  has_one :graduation, through: :connection
  has_one :graduation_group, through: :graduation
  has_one :institution, through: :connection
  has_one :academic_degree, through: :connection
  has_one :method_teaching, through: :connection

  has_many :semesters
  has_many :disciplines, through: :semesters

  def make

    profile = GraduationProfile.select(" graduation_profiles.id 
                                        ,graduation_profiles.period 
                                        ,graduation_profiles.hours 
                                        ,graduation_profiles.monthly_payment 
                                        ,graduation_profiles.coordination
                                        ,graduation_profiles.description
                                        ,graduation_profiles.video_link 
                                        ,graduations.id as graduation_id
                                        ,graduations.name
                                        ,graduation_groups.url_friendly
                                        ,institutions.id as institution_id
                                        ,academic_degrees.name as academic_degree_name
                                        ,method_teachings.name as method_teaching_name")
                               .joins(:connection)
                               .joins(:graduation)
                               .joins(:graduation_group)
                               .joins(:institution)
                               .joins(:academic_degree)
                               .joins(:method_teaching)
                               .find(self.id)  

   return nil if profile.nil?

    hash_profile = {}
    unless profile.nil? 
      array_disciplines = []
      profile.semesters.each do |s| 
          array_disciplines << Discipline.select("disciplines.*").where(semester_id: s.id)
      end

      array_disciplines_length = []
      array_disciplines.each do |array| 
        array_disciplines_length << array.length 
      end

      hash_profile = {
        :period           => profile.period,
        :hours            => profile.hours,
        :monthly_payment  => profile.monthly_payment,
        :coordination     => profile.coordination,
        :description      => profile.description,
        :video_link       => profile.video_link,
        :total_semesters  => array_disciplines.length,
        :large_semester   => array_disciplines_length.max,
        :disciplines      => array_disciplines
      }
    end                       

    hash = {
      :institution => {
        :id => profile.institution_id
      },
      :graduation => {
        :id => profile.graduation_id,
        :name => profile.name,
        :url_friendly => profile.url_friendly,
        :academic_degree => profile.academic_degree_name,
        :method_teaching => profile.method_teaching_name,
        :profile => hash_profile
      }
    }

    hash
  end  

end
