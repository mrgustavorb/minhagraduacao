class CustomerMailer < ActionMailer::Base
  default from: '"Minha Graduação" <no-reply@minhgraduacao.com>'

  def confirmation_instructions(user, token, opts={})
    @token = token
    @user  = user

    if user.role.manager?
      mail(to: user.email, subject: "Seja bem vinda(o)", :template_path => 'mailers', :template_name => 'site/mailer/confirmation_instructions')
    end
  end

  def reset_password_instructions(user, token, opts={})
    @token = token
    @user  = user
    mail(to: user.email, subject: "Instruções para resetar senha", :template_path => 'mailers')
  end
end