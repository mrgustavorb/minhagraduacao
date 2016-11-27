class StrategyReport < ActiveRecord::Base

  # Quantidade de cadastros
  def self.users
    User.count
  end

  # Quantidade de alunos 
  def self.students
    User.students.count
  end

  # Quantidade de graduandos
  def self.undergraduates
    User.academics.count
  end

  # Quantidade de graduados
  def self.graduates
    User.professionals.count
  end

  # Quantidade de avaliações
  def self.total_evaluations
    EvaluationGraduation.count
  end

  # Quantidade de avaliações de alunos
  def self.students_evaluations
    EvaluationSchool.count
  end

  # Quantidade de avaliações de graduandos
  def self.undergraduates_evaluations
    EvaluationGraduation.academics_evaluations.count
  end

  # Quantidade de avaliações de graduados
  def self.graduates_evaluations
    EvaluationGraduation.professionals_evaluations.count
  end

  # Quantidade de visualizações dos cursos 
  def self.courses_views
    GraduationGroup.sum(:views).to_i
  end

  # Quantidade de visualizações das IES 
  def self.ies_views
    Institution.sum(:views).to_i
  end

  # Quantidade de logins na última semana
  def self.last_week_logins
    User.from_last_week.count
  end

  # Quantidade de logins de alunos na última semana
  def self.last_week_students_logins
    User.students_from_last_week.count
  end

  # Quantidade de logins de graduandos na última semana
  def self.last_week_academics_logins
    User.academics_from_last_week.count
  end

  # Quantidade de logins de graduados na última semana
  def self.last_week_professionals_logins
    User.professionals_from_last_week.count
  end

end