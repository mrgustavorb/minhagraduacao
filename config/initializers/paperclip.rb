Paperclip::Attachment.default_options[:s3_host_name] = 's3-us-west-2.amazonaws.com'

Paperclip.interpolates :institution_id  do |attachment, style|
  attachment.instance.institution_id
end