/**
* hoverIntent r6 // 2011.02.26 // jQuery 1.5.1+
* <http://cherne.net/brian/resources/jquery.hoverIntent.html>
* 
* @param  f  onMouseOver function || An object with configuration options
* @param  g  onMouseOut function  || Nothing (use configuration options object)
* @author    Brian Cherne brian(at)cherne(dot)net
*/
(function($){$.fn.hoverIntent=function(f,g){var cfg={sensitivity:7,interval:100,timeout:0};cfg=$.extend(cfg,g?{over:f,out:g}:f);var cX,cY,pX,pY;var track=function(ev){cX=ev.pageX;cY=ev.pageY};var compare=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);if((Math.abs(pX-cX)+Math.abs(pY-cY))<cfg.sensitivity){$(ob).unbind("mousemove",track);ob.hoverIntent_s=1;return cfg.over.apply(ob,[ev])}else{pX=cX;pY=cY;ob.hoverIntent_t=setTimeout(function(){compare(ev,ob)},cfg.interval)}};var delay=function(ev,ob){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t);ob.hoverIntent_s=0;return cfg.out.apply(ob,[ev])};var handleHover=function(e){var ev=jQuery.extend({},e);var ob=this;if(ob.hoverIntent_t){ob.hoverIntent_t=clearTimeout(ob.hoverIntent_t)}if(e.type=="mouseenter"){pX=ev.pageX;pY=ev.pageY;$(ob).bind("mousemove",track);if(ob.hoverIntent_s!=1){ob.hoverIntent_t=setTimeout(function(){compare(ev,ob)},cfg.interval)}}else{$(ob).unbind("mousemove",track);if(ob.hoverIntent_s==1){ob.hoverIntent_t=setTimeout(function(){delay(ev,ob)},cfg.timeout)}}};return this.bind('mouseenter',handleHover).bind('mouseleave',handleHover)}})(jQuery);



function megaMenuContactForm() {
  
  
  $('#mgmenu_form #submit').click(function(){

    $('.error').hide(0);
    var name = $('input#name').val();
    if (name == "" || name == " " || name == "Name") {
        $('input#name').focus().before('<div class="error">Hey, what is you name!?</div>');
        return false;
    }
    
    var email_test = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
    var email = $('input#email').val();
    if (email == "" || email == " ") {
       $('input#email').focus().before('<div class="error">Psst. You missed one.</div>');
       return false;
    } else if (!email_test.test(email)) {
       $('input#email').select().before('<div class="error">I think your email is wrong...</div>');
       return false;
    }
    
    var message = $('#message').val();
    if (message == "" || message == " " || message == "Message") {
        $('#message').focus().before('<div class="error">Oops! You forgot to type a message!</div>');
        return false;
    }
    
    var data_string = $('#mgmenu_form').serialize();

    $.ajax({
        type: "POST",
        url: "email.php",
        data: data_string,
        success: function() {
          $('#mgmenu_form').find('.error').hide(0);
        $('#mgmenu_form').before('<div class="success"></div>');
        $('.success').html('Your email has been sent successfully !');
        }//end success function


    }) //end ajax call

    return false;


  }) //end click function

  
}