class UserMailer < ActionMailer::Base
  default from: "minhagraduacao@minhagraduacao.com"

  def confirmation_instructions(user, token, opts={})
    @token = token
    @user  = user
    mail(to: user.email, subject: "Seja bem vinda(o) ", template_path: 'site/users/mailer', template_name: 'confirmation_instructions')
  end

  def reset_password_instructions(user, token, opts={})
    @token = token
    @user  = user
    mail(to: user.email, subject: "Instruções para resetar senha", template_path: 'site/users/mailer', template_name: 'reset_password_instructions')
  end

  def unlock_instructions(user, token, opts={})
    @token = token
    @user  = user
    mail(to: user.mail, subject: "Instruções para desbloqueio de conta", template_path: 'site/users/mailer', template_name: 'unlock_instructions')
  end

  def like_email(user, video)
    @user = user
    token = video.graduation.graduation_group.url_friendly
    @url  = "http://minhagraduacao.com/#{token}?v=#{video.id}"
    # mail(to: @user.email, subject: "QUALQUER COISA")
  end

  def record_email(user, video)
    @user = user
    token = video.graduation.graduation_group.url_friendly
    @url  = "http://minhagraduacao.com/#{token}?v=#{video.id}"
    mail(to: @user.email, subject: "Minha Graduação - Agradecemos sua colaboração",
    bcc: ['example@gmail.com'])
  end

  def universitary_record_email(user, video)
    @user = user
    token = video.graduation.graduation_group.url_friendly
    @url  = "http://minhagraduacao.com/#{token}?v=#{video.id}"
    mail(to: @user.email, subject: "Minha Graduação - Agradecemos sua colaboração",
    bcc: ['example@gmail.com'])
  end

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: 'example@gmail.com', subject: 'Minha Graduação - Formulário de Contato')
  end

  def sign_up_facebook(user)
    @user = user
    mail(to: @user.email, subject: 'Minha Graduação - Obrigado por se cadastrar')
  end
end
