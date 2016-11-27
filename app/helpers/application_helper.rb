module ApplicationHelper

  def default_meta_tags
    {
      :site        => 'Minha Graduação',
      :url         => 'http://minhagraduacao.com' + url_for(params),
      :description => 'Ajudamos você a escolher sua profissão! Oferecemos videos, textos, depoimentos, sobre todas as graduações que existem no Brasil e quais instituições você poderá ingressar.',
      :keywords    => 'escolha,minha,graduação,graduações,faculdade,faculdades,universidade,universidades,vestibular,enem,sisutec,sisu,onde estudar,mercado de trabalho,cursos graduação,estudante,faculdades,carreira,teste vocacional,profissão,profissões,ead,prouni,instituição,ensino superior',
      :og => {
        title:  :title,
        description: :description,
        :type => 'website',
        :url => 'http://minhagraduacao.com' + url_for(params),
        :image => 'http://minhagraduacao.com/minhagraduacao_og_image.png',
      }
    }
  end

  def video_player video
    storage = video.get_storage(@is_mobile)
    <<-ERB
      <div class="wrapper">
        <video id="video-player" class="video-js vjs-default-skin" controls preload="auto" width="auto" height="auto" poster="#{storage[:thumb]}" data-setup='{ "controls": true, "autoplay": true, "preload": "auto" }'>
        <source src="#{storage[:mp4]}" type='video/mp4' />
        </video>
      </div>
    ERB
        .html_safe
  end

  def gravatar_for email, options = {}
      options = {:alt => 'avatar', :class => 'avatar', :size => 150}.merge! options
      id = Digest::MD5::hexdigest email.strip.downcase
      url = 'http://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s
      options.delete :size
      image_tag url, options
  end

  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = $1
    else
      # Regex from # http://stackoverflow.com/questions/3452546/javascript-regex-how-to-get-youtube-video-id-from-url/4811367#4811367
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end

    <<-ERB 
      <iframe width="100%" height="450" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>
    ERB
        .html_safe
  end  

  def verify_http_protocol_in_url(url)
    !(url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]) ? "http://#{url}" : url
  end

  def color_opnions(index) #change color opnions on home index
    if index == 0
      "green"
    elsif index == 1
      "lblue"
    else
      "purple"
    end        
  end

end
