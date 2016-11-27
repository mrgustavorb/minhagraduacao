class Site::Users::PasswordsController < Devise::PasswordsController
	layout 'site/login'
end