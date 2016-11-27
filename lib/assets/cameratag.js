//
// CameraTagRecorder
// 

CameraTagRecorder = function(camera_el) {
  // main data objects
  var self = this;
  var $ = CameraTag.jQuery; // we keep a localized version in case your not already using jQuery
  var camera_uuid = $(camera_el).attr("data-uuid") || $(camera_el).attr("id");
  var camera = {};
  var video = {};
  var plan = {};
  var dom_id = $(camera_el).attr("id") || $(camera_el).attr("data-uuid");
  var txt_message;
  var input_name;
  var css_url;
  var record_timer;
  var record_timer_count = 0;
  var record_timer_prompt = 0;
  var ul_policy;
  var ul_signature;
  var cachebuster = parseInt( Math.random() * 100000000 );
  var existing_uuid = $(camera_el).attr("data-video-uuid");
  var processed_timer;
  var published_timer;

  // mobile vars
  var mobile_browser;
  var mobile_upload_supported;
  var mobile_enabled;

  var params = {};
  params["appserver"] = $(camera_el).attr("data-appserver");
  params["videoserver"] = $(camera_el).attr("data-videoserver");


  // overwritable params
  var fps;
  var className;
  var videoServer; // gets set by server in auth callback
  var appServer = params["appserver"] || "cameratag.com";
  var height;
  var width;
  var hResolution;
  var vResolution;
  var maxLength;
  var skipPreview;
  var videoBitRate;
  var skipAutoDetect;
  var preRollLength;
  var recordOnConnect;
  var publishOnUpload;
  var uploadOnSelect;
  var flipRecordPreview;

  // DOM references
  var container;
  var swf;
  var start_screen;
  var playback_screen;
  var recording_screen;
  var camera_detection_screen;
  var countdown_screen;
  var countdown_status;
  var upload_screen;
  var upload_status;
  var accept_screen;
  var wait_screen;
  var wait_message;
  var completed_screen;
  var error_screen;
  var error_message;
  var sms_screen;
  var sms_input;
  var parent_form;
  var thumb_bg;
  var check_phone_screen;
  var alternative_prompt;


  // Control functions
  self.play = function(){};
  self.record = function(){};
  self.stopRecording = function(){};
  self.stopPlayback = function(){};
  self.fire = function(){};
  self.observe = function(){};
  self.stopObserving = function(){};
  self.showFlashSettings = function(){};
  var connect; // for internal use only accessable- not publicly accessable


  // state management 
  var state;
  var connected = false;
  var readyToRecord = false;
  var countdown_counter = 0;
  var uploading = false;
  var error_messages = [];
  var readyToPublish = false;


  // locales default
  // var unsupported_device_error_text   = "Your mobile device does not support video uploading";
  // var flash_player_version_error_text = "Please make sure you have Flash Player 11 or higher installed";
  // var upload_text                     = "you may also upload a file";
  // var or_text                         = "or";
  // var bufferingUp_text                = "uploading your video";
  // var bufferingDown_text              = "buffering video playback";

  // locales portuguese by ninjachoice
  var unsupported_device_error_text   = "O seu dispositivo móvel não suporta upload de vídeo";
  var flash_player_version_error_text = "Por favor, certifique-se de ter o Flash Player 11 ou superior instalado";
  var upload_text                     = "Deseja fazer um upload de arquivo?";
  var or_text                         = "ou";
  var bufferingUp_text                = "Processando...";
  var bufferingDown_text              = "Processando...";

  // keep a reference to this instance in the Class prototype
  CameraTag.cameras[dom_id] = self;

  var setup = function(dont_init) {
    // make sure swfobject is available
    if (!swfObjectReady()) {
      setTimeout(setup, 30);
      return;
    };

    authorize(init)
  };

  var authorize = function(callback) {
    $.ajax({
      url: "//"+appServer+"/videos.json",
      type:"get",
      dataType: "jsonp",
      data: {
        referer: window.location.toString(),
        camera_id: camera_uuid,
        video_uuid: existing_uuid
      },
      success: function(response) {
        if (response["camera"] != undefined) {
          camera = response.camera;
          video = response.video;
          plan = response.plan;
          videoServer = params["videoserver"] || response.videoServer;
          ul_policy = response.amazon_ul_policy;
          ul_signature = response.amazon_ul_signature;
          mobile_date = response.mobile_date;
          mobile_auth = response.mobile_auth;

          // setup video formats
          video.formats = {};
          if (camera.formats) {
            $(camera.formats).each(function(index, format){
              video.formats[format.name] = {};
            })
          }

          // callback
          callback(); 
        }
        else {
          error_messages.push(response.error);
          sendStat("authorization_error_200", {message: response.error});
          callback();
        }
      },
      error: function(jqXHR, textStatus, errorThrown) {
        error_messages.push("error initializing recorder");
        var error_code = jqXHR.status;
        sendStat("authorization_error_"+error_code);  
      }
    });
  }

  var init = function() {
    // setup prarms with preference to passed in as data attributes on the camera tag
    input_name = $(camera_el).attr("name") || camera.name;
    inline_styles = $(camera_el).attr("style")
    className = $(camera_el).attr("class") || camera.className || "";
    fps = camera.formats && camera.formats[0].fps || 24;
    if (camera.formats) {
      width = camera.formats[0].height < 360 ? camera.formats[0].width : camera.formats[0].width / 2;
      height = camera.formats[0].height < 360 ? camera.formats[0].height : camera.formats[0].height / 2;
      hResolution = camera.formats[0].width;
      vResolution = camera.formats[0].height;
    }
    else {
      width = 300;
      height = 200;
      hResolution = 300;
      vResolution = 200;
    }
    maxLength = $(camera_el).attr("data-maxlength") || camera.maxLength || 30;
    css_url = camera.cssURL || "//"+appServer+"/"+CameraTag.version+"/cameratag.css";
    skipPreview = $(camera_el).attr("data-autopreview") == "false" || camera.autoPreview == false || false;
    videoBitRate = $(camera_el).attr("data-videobitrate") || 65536;
    mobile_browser = isMobile();
    mobile_upload_supported = mobileUploadSupported();
    mobile_enabled = mobile_browser && mobile_upload_supported && camera.allowMobileUploads;
    txt_message = $(camera_el).attr("data-txt-message") || camera.txtMessage || "To record this video using your mobile phone please visit <<url>> in your mobile browser";
    publishOnUpload = $(camera_el).attr("data-publish-on-upload") != "false";
    uploadOnSelect = $(camera_el).attr("data-upload-on-select") != "false";
    recordOnConnect = $(camera_el).attr("data-record-on-connect") != "false";
    skipAutoDetect = $(camera_el).attr("data-skip-auto-detect") == "true";
    if ($(camera_el).attr("data-pre-roll-length")) {
      preRollLength = parseInt($(camera_el).attr("data-pre-roll-length"))
    }
    else {
      preRollLength = 5;
    }
    
    flipRecordPreview = $(camera_el).attr("data-flip-record-preview") == "true";

    // setup parent form observation
    parent_form = $(camera_el).parents("form");
      
    // inject our css 
    url = 'style.css';
    if (document.createStyleSheet) {
      // for IE
      document.createStyleSheet(css_url);
    }
    else {
      // for non IE
      var css_link = $('<link href="'+css_url+'" media="all" rel="stylesheet" type="text/css" />');
      $("head").append(css_link);    
    }
    
    
    // replace the camera tag with the container div
    container = $('<div id="'+dom_id+'" class="camera_tag"></div>');
    container.css({width: width+"px", height: height+"px"})
    container.attr("style", inline_styles);
    container.addClass(className);
    $(camera_el).replaceWith(container);


    if (!mobile_browser) {
      // create swf placeholder in container then embed the camera swf
      container.append("<div id='"+dom_id+"_swf_placeholder'></div>")
      embedSWF();  
      // communication to and from swf
      setupExternalInterface();
    }

    // setup event observers
    setupEventObservers();

    // non-campatible mobile device
    if (mobile_browser && !mobile_enabled) {
      error_messages.push(unsupported_device_error_text);
      sendStat("unsupported_device_error");
    }

    // build the control elements
    buildInterfaceElements();
    
    // create the inputs that will get posted
    create_hidden_inputs();

    // initialize if we're mobile
    if (mobile_browser) {
      self.fire("initialized");  
    }
  };

  var embedSWF = function() {
    var flashvars = {
        videoServer: videoServer,
        videoUUID: video.uuid,
        cameraUUID: camera.uuid,
        domID: dom_id,
        maxLength: maxLength,
        hResolution: hResolution,
        vResolution: vResolution,
        fps: fps,
        videoBitRate: videoBitRate,
        skipAutoDetect: skipAutoDetect,
        flipRecordPreview: flipRecordPreview
    };

    var params = {
        allowfullscreen: 'true',
        allowscriptaccess: 'always',
        wmode: "transparent"
    };

    var attributes = {
        id: dom_id+"_swf",
        name: dom_id+"_swf"
    };

    swfobject.embedSWF("//"+appServer+"/"+CameraTag.version+"/camera.swf?"+cachebuster, dom_id+"_swf_placeholder", "100%", "100%", '11.1.0', 'https://'+appServer+'/'+CameraTag.version+'/expressInstall.swf', flashvars, params, attributes, checkSWF);

    if (swfobject.getFlashPlayerVersion().major < 11) {
      error_messages.push(flash_player_version_error_text);
    }
  };

  var checkSWF = function(e){
    swf = $("#"+dom_id+"_swf")[0];
    if (swf == undefined && e.success == true) {
      var flash_ver = swfobject.getFlashPlayerVersion().major + "." + swfobject.getFlashPlayerVersion().minor;
      sendStat("no_flash_error", {flash_version: flash_ver, source: "post embed check"});
      error_messages.push(flash_player_version_error_text);
    }
  }

  self.getState = function() {
    return state;
  };

  self.embed_callback = function(e) {
    swf = $("#"+dom_id+"_swf")[0];

    if (swf == undefined) {
      sendStat("no_flash_error", {flash_version: flash_ver, source: "swfobject callback"});
      error_messages.push(flash_player_version_error_text);
    }
  }

  var buildInterfaceElements = function() {
    // start screen
    start_screen = $("#"+dom_id+"-start-screen").addClass("cameratag_screen");
    if (start_screen.length == 0) {
      start_screen = $('<div id="'+dom_id+'-start-screen" class="cameratag_screen cameratag_start cameratag_record"></div>');
      var record_btn = $('<a class="cameratag_record_button"><span class="cameratag_record_circle">&#9679;</span> click to record</a>');
      start_screen.append(record_btn);
      if (!mobile_enabled) {
        var settings_btn = $('<img class="cameratag_settings_btn" src="//cameratag.com/assets/gear.png">');
        start_screen.append(settings_btn);  
      }
    }
    // add to DOM
    container.append(start_screen);


    // error screen
    error_screen = $("#"+dom_id+"-error-screen").addClass("cameratag_screen");
    if (error_screen.length == 0) {
      error_screen = $('<div class="cameratag_screen cameratag_error"></div>');
      error_message = $('<div class="cameratag_error_message"></div>');
      error_screen.append(error_message);
      var settings_btn = $('<img class="cameratag_settings_btn" src="//cameratag.com/assets/gear.png">');
      error_screen.append(settings_btn);
    }
    // add to DOM
    container.append(error_screen);

    // alternative recording prompt
    alternative_prompt = $("#"+dom_id+"-alternative-prompt");
    if (alternative_prompt.length == 0) {
      alternative_prompt = $('<div class="cameratag_alternatives"></div>'); 

      // dont display alternative if user is on mobile browser
      if (!mobile_browser) {
      
        if ( (camera.allowMobileUploads && plan.sms) || camera.allowUploads) {
          // disabled by ninjachoice
          // alternative_prompt.append("you may also ");
        }

        // sms link
        if (camera.allowMobileUploads && plan.sms) {
          var sms_link = $('<a href="javascript:" class="cameratag_sms_link">record by phone</a>');  
          alternative_prompt.append(sms_link);  
        }
        
        if (camera.allowMobileUploads && camera.allowUploads && plan.sms) {
          alternative_prompt.append(" "+or_text+" ");  
        }

        // upload link
        if (camera.allowUploads && !mobile_browser) {
          var upload_link_id = dom_id+"_upload_link";
          var upload_link = $('<a href="javascript:" id="'+upload_link_id+'" class="cameratag_upload_link">'+upload_text+'</a>');  
          alternative_prompt.append(upload_link);
          self.uploader = new CameraTagUploader(upload_link_id);
        }
      }
    }
    // add to DOM
    container.append(alternative_prompt);


    // camera detection
    camera_detection_screen = $("#"+dom_id+"-camera-detection-screen").addClass("cameratag_screen");
    if (camera_detection_screen.length == 0) {
      // legacy support for old typo
      camera_detection_screen = $("#"+dom_id+"camera-detection-screen").addClass("cameratag_screen");
    }
    if (camera_detection_screen.length == 0) {
      camera_detection_screen = $('<div class="cameratag_screen cameratag_detect"></div>');
      var camera_detection_prompt = $('<div class="cameratag_prompt">wave to the camera</div>');
      camera_detection_screen.append(camera_detection_prompt);
    }
    // add to DOM
    container.append(camera_detection_screen);


    // countdown
    countdown_screen = $("#"+dom_id+"-countdown-screen").addClass("cameratag_screen");
    countdown_status = countdown_screen.find(".cameratag_countdown_status");
    if (countdown_screen.length == 0) {
      countdown_screen = $('<div class="cameratag_screen cameratag_count"></div>');
      var countdown_prompt = $('<div class="cameratag_prompt">recording in </div>');
      countdown_status = $('<div class="cameratag_countdown_status"></div>');
      countdown_screen.append(countdown_status);
      countdown_screen.append(countdown_prompt);
    }
    // add to DOM
    container.append(countdown_screen);



    // upload
    upload_screen = $("#"+dom_id+"-upload-screen").addClass("cameratag_screen");
    upload_status = upload_screen.find(".cameratag_upload_status");
    if (upload_screen.length == 0) {
      upload_screen = $('<div class="cameratag_screen cameratag_upload"></div>');
      var upload_prompt = $('<div class="cameratag_prompt">uploading...</div>');
      upload_status = $('<div class="cameratag_upload_status"></div>');
      upload_screen.append(upload_status);
      upload_screen.append(upload_prompt);
    }
    // add to DOM
    container.append(upload_screen);


    // record controls
    recording_screen = $("#"+dom_id+"-recording-screen").addClass("cameratag_screen");
    record_timer_prompt = recording_screen.find(".cameratag_record_timer_prompt");
    if (recording_screen.length == 0) {
      recording_screen = $('<div class="cameratag_screen cameratag_recording cameratag_stop_recording"></div>');
      var stop_prompt = $('<div class="cameratag_prompt">click to stop recording </div>');
      record_timer_prompt = $('<span class="cameratag_record_timer_prompt">('+maxLength+')</span>');
      var recording_indicator = $('<img src="//'+appServer+'/assets/recording.gif"/>');
      stop_prompt.append(record_timer_prompt);
      recording_screen.append(stop_prompt);
      recording_screen.append(recording_indicator);
    }
    // add to DOM
    container.append(recording_screen);
  
  
    // play controls
    playback_screen = $("#"+dom_id+"-playback-screen").addClass("cameratag_screen");
    if (playback_screen.length == 0) {
      playback_screen = $('<div class="cameratag_screen cameratag_playback cameratag_stop_playback"></div>');
      var skip_prompt = $('<div class="cameratag_prompt">click to skip review</div>');
      playback_screen.append(skip_prompt);  
    }
    // add to DOM
    container.append(playback_screen);
    

    // accept controls
    accept_screen = $("#"+dom_id+"-accept-screen").addClass("cameratag_screen");
    if (accept_screen.length == 0) {
      accept_screen = $('<div class="cameratag_screen cameratag_accept"></div>');
      var accept_btn = $('<a class="cameratag_accept_btn cameratag_publish"><span class="button_label">&#10003; Accept</span></a>');
      var rerecord_btn = $('<a class="cameratag_rerecord_btn cameratag_record"><span class="button_label">&#9851; Re-record</span></a>');
      var play_btn = $('<a class="cameratag_play_btn cameratag_play"><span class="button_label">&#8629; Review Recording</span></a>');
      accept_screen.append(accept_btn);
      accept_screen.append(rerecord_btn);
      accept_screen.append(play_btn);
    }
    // add to DOM
    container.append(accept_screen);
    

    // wait screen
    wait_screen = $("#"+dom_id+"-wait-screen").addClass("cameratag_screen");
    wait_message = wait_screen.find(".cameratag_wait_message");
    if (wait_screen.length == 0) {
      wait_screen = $('<div class="cameratag_screen cameratag_wait"></div>');
      var spinner = $('<div class="cameratag_spinner"><img src="//'+appServer+'/assets/loading.gif"/><br/><span class="cameratag_wait_message">please wait while we push pixels</span></div>');
      wait_screen.append(spinner);
      wait_message = wait_screen.find(".cameratag_wait_message");
    }
    // add to DOM
    container.append(wait_screen);


    // completed screen
    completed_screen = $("#"+dom_id+"-completed-screen").addClass("cameratag_screen");
    if (completed_screen.length == 0) {
      completed_screen = $('<div class="cameratag_screen cameratag_completed"></div>');
      thumb_bg = $('<div class="cameratag_thumb_bg"></div>');
      var check_mrk = $('<div class="cameratag_checkmark"><span class="check">&#10004;</span> published</div>');
      completed_screen.append(thumb_bg);
      completed_screen.append(check_mrk);

    }
    // add to DOM
    container.append(completed_screen);


    // sms screen
    sms_screen = $("#"+dom_id+"-sms-screen").addClass("cameratag_screen");
    sms_input = sms_screen.find(".cameratag_sms_input");
    if (sms_screen.length == 0) {
      sms_screen = $('<div class="cameratag_screen cameratag_sms"></div>');
      var sms_input_prompt = $('<div class="cameratag_sms_prompt">Enter your <b>mobile phone number</b> below and we will text you a link for mobile recording<br/></div>');
      sms_input = $('<input class="cameratag_sms_input" type="text"/>');
      var sms_submit = $('<br/><a href="javascript:" class="cameratag_send_sms">Send Mobile Link</a>&nbsp;&nbsp;<a class="cameratag_goto_start">cancel</a>');

      sms_input_prompt.append(sms_input);
      sms_input_prompt.append(sms_submit);
      sms_screen.append(sms_input_prompt);
    }
    // add to DOM
    container.append(sms_screen);


    // check phone screen
    check_phone_screen = $("#"+dom_id+"-check-phone-screen").addClass("cameratag_screen");
    if (check_phone_screen.length == 0) {
      check_phone_screen = $('<div class="cameratag_screen cameratag_check_phone"><div class="cameratag_check_phone_prompt">Check your phone for mobile recording instructions</div><div class="cameratag_check_phone_url">or vsist http://'+appServer+'/m/'+video.short_code+' your mobile browser</div></div>');
    }
    // add to DOM
    container.append(check_phone_screen);


    // mobile DOM elements
    if (mobile_enabled) {
      // make whole thing uploader on mobile
      self.uploader = new CameraTagUploader(dom_id+"-start-screen");
    }



    //
    // SETUP ACTION CLASS OBSERVERS
    //
    if (!mobile_browser) {
      container.find(".cameratag_record").click(function(){self.record()});
      container.find(".cameratag_stop_recording").click(function(){self.stopRecording()});
      container.find(".cameratag_stop_playback").click(function(){self.stopPlayback()});
      container.find(".cameratag_play").click(function(){self.play()});
      container.find(".cameratag_publish").click(function(){self.publish()});
      container.find(".cameratag_goto_start").click(function(){
        self.loadInterface(start_screen, true);
      });  
      container.find(".cameratag_send_sms").click(function(){
        self.send_sms(sms_input.val());
      });
      container.find(".cameratag_sms_link").click(function(){
        self.loadInterface(sms_screen);
        return false;
      });
      container.find(".cameratag_settings_btn").click(function(e){
        e.stopPropagation();
        self.showFlashSettings();
      });  
    }
    
  };

  var isMobile = function() {
    if( navigator.userAgent.match(/Android/i)
      || navigator.userAgent.match(/webOS/i)
      || navigator.userAgent.match(/iPhone/i)
      || navigator.userAgent.match(/iPad/i)
      || navigator.userAgent.match(/iPod/i)
      || navigator.userAgent.match(/BlackBerry/i)
      || navigator.userAgent.match(/Windows Phone/i)
    ) {
      return true;
    }
    else {
      return false;
    }
  }

  var mobileUploadSupported = function () {
     // Handle devices which falsely report support
     if (navigator.userAgent.match(/(Android (1.0|1.1|1.5|1.6|2.0|2.1))|(Windows Phone (OS 7|8.0))|(XBLWP)|(ZuneWP)|(w(eb)?OSBrowser)|(webOS)|(Kindle\/(1.0|2.0|2.5|3.0))/)) {
       return false;
     }
     // Create test element
     var el = document.createElement("input");
     el.type = "file";
     return !el.disabled;
  }

  var countdown = function(length, callback) {
    if (countdown_counter >= length) {
      countdown_counter = 0;
      countdown_screen.hide();
      callback();
      self.fire("countdownFinished");
    }
    else {
      countdown_status.html(length - countdown_counter);
      countdown_counter += 1;
      setTimeout(function(){
        countdown(length, callback);
      }, 1000);
    }
  };

  self.loadInterface = function(state_container, alternatives, message) {

    container.find(".cameratag_screen").hide();
    if (alternatives) {
      container.find(".cameratag_alternatives").show();
    }
    else {
     container.find(".cameratag_alternatives").hide(); 
    }

    if (state_container != "none") {
      state_container.css('display','block');
    }
  };

  var recordTimerTick = function() {
    record_timer_count += 1;
    var time_left = maxLength - record_timer_count;

    // minute:seconds
    var divisor_for_minutes = time_left % (60 * 60);
    var minutes = Math.floor(divisor_for_minutes / 60);
    var divisor_for_seconds = divisor_for_minutes % 60;
    var seconds = Math.ceil(divisor_for_seconds);

    record_timer_prompt.html( "(" +minutes + ":" + seconds + ")" );
    if (time_left <= 0) {
      self.stopRecording();
    }
  }

  var throw_error = function(message) {
    error_message.html(message);
    self.loadInterface(error_screen, true);
  };

  var sendStat = function(name, stat) {
    stat = stat || {};
    stat.name = name;
    stat.camera_uuid = camera_uuid;
    stat.video_uuid = video.uuid;
    stat.url = window.location.toString();
    stat.host = window.location.hostname;
    stat.agent = navigator.userAgent;
    stat.state = state;
    stat.client_version = CameraTag.version;

    $.ajax({
      url: "//"+appServer+"/stats",
      data:{stat: stat},
      type:"get",
      dataType: "jsonp"
    });
  }

  var wait = function(message) {
    message = message || "please wait";
    wait_message.html(message);
    self.loadInterface(wait_screen);
  }

  var populate_hidden_inputs = function() {
    $("#"+input_name+"_video_uuid").val(video.uuid);
    $(camera.formats).each(function(index, format){
      // videos
      var mp4_url = "//"+appServer+"/videos/"+video.uuid+"/"+format.name+"/mp4";
      $("#"+input_name+"_"+format.name+"_video").val(mp4_url);
      video.formats[format.name]["video_url"] = mp4_url;

      $("#"+input_name+"_"+format.name+"_mp4").val(mp4_url);
      video.formats[format.name]["mp4_url"] = mp4_url;

      var webm_url = "//"+appServer+"/videos/"+video.uuid+"/"+format.name+"/webm";
      $("#"+input_name+"_"+format.name+"_webm").val(webm_url);
      video.formats[format.name]["webm_url"] = webm_url;

      // thumbnails
      var thumb_url = "//"+appServer+"/videos/"+video.uuid+"/"+format.name+"/thumb";
      $("#"+input_name+"_"+format.name+"_thumb").val(thumb_url);
      video.formats[format.name]["thumb_url"] = thumb_url;

      var small_thumb_url = "//"+appServer+"/videos/"+video.uuid+"/"+format.name+"/small_thumb";
      $("#"+input_name+"_"+format.name+"_small_thumb").val(small_thumb_url);
      video.formats[format.name]["small_thumb_url"] = small_thumb_url;
    });

  };

  var create_hidden_inputs = function() {
    container.append("<input id='"+input_name+"_video_uuid' type='hidden' name='"+input_name+"[video_uuid]' value=''>");
    $(camera.formats).each(function(index, format){
      container.append("<input id='"+input_name+"_"+format.name+"_video' type='hidden' name='"+input_name+"["+format.name+"][video]' value=''>");
      container.append("<input id='"+input_name+"_"+format.name+"_mp4' type='hidden' name='"+input_name+"["+format.name+"][mp4]' value=''>");
      container.append("<input id='"+input_name+"_"+format.name+"_webm' type='hidden' name='"+input_name+"["+format.name+"][webm]' value=''>");
      container.append("<input id='"+input_name+"_"+format.name+"_thumb' type='hidden' name='"+input_name+"["+format.name+"][thumb]' value=''>");
      container.append("<input id='"+input_name+"_"+format.name+"_small_thumb' type='hidden' name='"+input_name+"["+format.name+"][small_thumb]' value=''>");
    });
  };

  self.addVideoData = function(js_object) {
    if (typeof(js_object) != "object") {
      return
    }

    var json_string = JSON.stringify(js_object);
    
    $.ajax({
      url: "//"+appServer+"/videos/"+video.uuid+"/form_data.json",
      data:{form_data: json_string},
      type:"get",
      dataType: "jsonp",
      success: function(response) {
        return true
      },
      error: function() {
        throw_error("Unable to submit form data.");
        sendStat("video_data_error");
        return false;
      }
    })
  }

  self.reset = function() {
    authorize(function() {
      if (!mobile_enabled) {
        swf.setUUID(video.uuid);
        swf.showNothing();
      }
      readyToPublish = false;
      clearTimeout(processed_timer);
      self.loadInterface(start_screen, true);  
    })
  }

  self.setLength = function(new_length) {
    maxLength = new_length;
    swf.setLength(new_length);
  }

  var get_form_data = function() {
    var o = {};
    var a = serialze_ct_elelments();
    $.each(a, function(index, form_el) {  
      if (o[form_el.name] !== undefined) {
          if (!o[form_el.name].push) {
              o[form_el.name] = [o[form_el.name]];
          }
          o[form_el.name].push(form_el.value || '');
      } else {
          o[form_el.name] = form_el.value || '';
      }
    });
    return o;
  }

  var serialze_ct_elelments = function() {
    if (parent_form.length == 0) {
      return "[]";
    }

    return $(parent_form[0].elements).filter(function () {
        return $(this).hasClass("cameratag_data") && this.name && !this.disabled && (this.checked || /select|textarea/i.test(this.nodeName) || /text|hidden|password/i.test(this.type));
    }).map(function (i, elem) {
        var val = jQuery(this).val();
        return val == null ? null : val.constructor == Array ? jQuery.map(val, function (val, i) {
            return {
                name: elem.name,
                value: val
            };
        }) : {
            name: elem.name,
            value: val
        };
    }).get();
  }

  //
  // publicly accessable methods
  // 

  self.send_sms = function(number) {
    if (number == "") {
      alert("please eneter your phone number!")
      return;
    }
    wait("sending your message");
    $.ajax({
      url: "//"+appServer+"/videos/"+video.uuid+"/sms",
      data:{number: number, message: txt_message},
      type:"get",
      dataType: "jsonp",
      success: function(response) {
        if (response.success) {
          self.loadInterface(check_phone_screen);
          self.fire("smsSent");
        }
        else {
          self.loadInterface(sms_screen);
          alert("that does not appear to be a valid phone number");
        } 
      },
      error: function() {
        throw_error("Unable to send SMS.");
        sendStat("sms_error", {number: number, message: txt_message});
        return false;
      }
    })
  }

  self.publish = function() {
    if (!readyToPublish) {
      sendStat("premature_publish");
      throw("Camera not ready to publish. Please wait for the 'readyToPublish' event.");
      return;
    }

    self.fire("publishing");
    wait("publishing");
    
    if (uploading) {
      if (mobile_browser) {
        data = {publish_type: "mobile"};  
      }
      else {
        data = {publish_type: "upload"};
      }
      
    }
    else {
      data = {publish_type: "webcam"};
    }
    
    $.ajax({
      url: "//"+appServer+"/videos/"+video.uuid+"/publish.json",
      data:data,
      type:"get",
      dataType: "jsonp",
      success: function(response) {
        if (response["uuid"]) {
          state = "published";
          pollForProcessed();
          populate_hidden_inputs();
          self.loadInterface(completed_screen);
          if (connected) {
            self.disconnect();
          }
          sendStat("publish_success");
          self.fire("published", video);
        }
        else {
          self.fire("publishFailed", response);
        }
      },
      error: function() {
        self.fire("publishFailed", {success: false, message: "unkown error"});
      }
    })
  };

  self.getVideo = function() {
    return video;
  };

  self.restart_upload = function() {
    self.uploader.restart_upload();
  }

  self.start_upload = function() {
    self.uploader.start_upload();
  }

  self.stop_upload = function() {
    self.uploader.stop_upload();
  }

  self.observe = function(event_name,callback, priority) {
    priority = priority || false;
    CameraTag.observe(dom_id, event_name, callback, priority);
  };

  self.fire = function(event_name,data) {
    CameraTag.fire(dom_id, event_name, data);
  };

  self.stopObserving = function(event_name,callback) {
    CameraTag.stopObserving(dom_id, event_name, callback);
  };

  self.destroy = function() {
    state = "disconnecting";
    if (swf && connected) {
      swf.disconnect();
    }
    delete CameraTag.cameras[dom_id];
    container.remove();
  }


  var pollForProcessed = function() {
    if (camera.poll_for_processed) {
      $.ajax({
        url: "//"+appServer+"/videos/"+video.uuid+".json",
        type:"get",
        dataType: "jsonp",
        data: {
          referer: window.location.toString()
        },
        success: function(response) {
          if (response.formats[0].state == "COMPLETED") {
            self.fire("processed");
          }
          else {
            processed_timer = setTimeout(pollForProcessed, 2000);
          }
        },
        error: function() {
          sendStat("processed_poll_error");
        }
      })
    }
  }

  var pollForPublished = function() {
    $.ajax({
      url: "//"+appServer+"/videos/"+video.uuid+".json",
      type:"get",
      dataType: "jsonp",
      data: {
        referer: window.location.toString()
      },
      success: function(response) {
        if (response.state == "published") {
          self.loadInterface(completed_screen);
          self.fire("published");
        }
        else {
          setTimeout(function(){pollForPublished()}, 4000);
        }
      },
      error: function() {
        sendStat("published_poll_error");
      }
    })
  }

  // these methods require the swf to be in existance and are created after it's available

  var setupExternalInterface = function() {
    // communication to swf
    self.play = function() {
      if (connected) {
        swf.startPlayback();
      }
    };

    self.showFlashSettings = function() {
      self.loadInterface("none");
      swf.showFlashSettings();
    }

    self.record = function() { // actually calls countdown which will call record_without_countdown in callback      
      if (connected) {
        self.fire("countdownStarted");
        swf.showRecorder();
        countdown(preRollLength, self.record_without_countdown);
      }
      else {
        self.loadInterface("none");
        self.connect();
      }
    };

    self.showRecorder = function() {
      swf.showRecorder();
    }

    self.showPlayer = function() {
      swf.showPlayer(); 
    }

    self.record_without_countdown = function() {
      if (!readyToRecord) {
        sendStat("premature_record");
        throw("Camera not ready to record. Please observe 'readyToRecord' event before recording");
        return;  
      }
      state = "recording";
      swf.showRecorder();
      swf.startRecording()  
    };

    self.stopPlayback = function() {
      if (connected) {
        swf.stopPlayback();  
      }
    };

    self.stopRecording = function() {
      if (connected) {
        swf.stopRecording();  
      }
    };

    self.connect = function() {
      swf.connect();
    };

    self.disconnect = function() {
      if (connected) {
        state = "disconnecting";
        swf.disconnect();  
      }
    };
  }

  var setupEventObservers = function() {
    // communication from swf

    self.observe("initialized", function() {
      state = "initialized";
      if (error_messages.length > 0) {
        throw_error(error_messages.join("\n"));
        return;
      }
      else {
        self.loadInterface(start_screen, true);
      }
    }, true);

    self.observe("securityDialogOpen", function() {
      self.loadInterface("none");
    }, true);

    self.observe("securityDialogClosed", function() {
      self.loadInterface(camera_detection_screen);
    }, true);

    self.observe("settingsDialogClosed", function() {
      self.loadInterface(start_screen, true);
    }, true);

    self.observe("detectingCamera", function() {
      self.loadInterface(camera_detection_screen);
    }, true);

    self.observe("noCamera", function() {
      throw_error("No Camera Detected");
      sendStat("no_camera_error");
    }, true);

    self.observe("noMic", function() {
      throw_error("No Microphone Detected");
      sendStat("no_mic_error");
    }, true);

    self.observe("readyToRecord", function() {
      readyToRecord = true;
      if (recordOnConnect) {
        self.record(); //starts countdown    
      }
      else {
        self.loadInterface("none");
      }
    }, true);

    self.observe("cameraDenied", function() {
      throw_error("Camera Access Denied");
    }, true);

    self.observe("serverConnected", function() {
      connected = true;
    }, true);

    self.observe("serverDisconnected", function() {
      connected = false;
      readyToRecord = false;
      if (state != "disconnecting" && state != "published" && state != "readyToPublish"){
        self.stopRecording();
        swf.showNothing();
        self.loadInterface(start_screen);
        sendStat("pre_record_disconnect_error");
      }
    }, true);

    self.observe("playbackFailed", function() {
      throw_error("Playback failed");
      sendStat("playback_error");
    }, true);

    self.observe("serverError", function() {
      throw_error("Unable To Connect");
      sendStat("no_server_error");
    }, true);

    self.observe("waitingForCameraActivity", function() {
    }, true);
    

    self.observe("countdownStarted", function() {
      self.loadInterface(countdown_screen);
    }, true);

    self.observe("countdownFinished", function() {
    }, true);

    self.observe("recordingStarted", function() {
      record_timer_count = 0;
      record_timer = setInterval(function(){ recordTimerTick() }, 1000);
      self.loadInterface(recording_screen);
    }, true);

    self.observe("recordingStopped", function() {
      clearInterval(record_timer);
      if (skipPreview) {
        swf.showPlayer();
        self.loadInterface(accept_screen);
      }
      else {
        self.play();
      }
    }, true);

    self.observe("bufferingUp", function() {
      wait(bufferingUp_text);
    }, true);

    self.observe("bufferingDown", function() {
      wait(bufferingDown_text);
    }, true);    

    self.observe("recordingTimeOut", function() {
    }, true);

    self.observe("playbackStarted", function() {
      self.loadInterface(playback_screen);
    }, true);

    self.observe("playbackStopped", function() {
      self.loadInterface(accept_screen);
    }, true);

    self.observe("publishing", function() {
      state = "publishing";
    }, true);

    self.observe("uploadStarted", function() {
      uploading = true;
    }, true);

    self.observe("uploadAborted", function() {
      uploading = false;
    }, true);

    self.observe("readyToPublish", function() {
      readyToPublish = true;
      state = "readyToPublish";
    }, true);

    self.observe("smsSent", function() {
      pollForPublished();
    }, true);

    self.observe("published", function() {
      state = "published";
    }, true);

    self.observe("publishFailed", function(data) {
      throw_error("Unable to publish your recording.");
      sendStat("publish_error", data);
    }, true);

    self.observe("processed", function() {
      state = "processed";
      $(".cameratag_thumb_bg").css({backgroundImage: "url(//"+appServer+"/videos/"+video.uuid+"/"+camera.formats[0].name+"/thumb)"});
    }, true);

    self.observe("uploadFileSelected", function(file) {
    }, true);

    self.observe("uploadProgress", function(file) {
      upload_status.html(file.percent + "%");
    }, true);
  }

  var swfObjectReady = function() {
    // swfobject is ready
    if ( typeof(swfobject) == "object" ) {
      CameraTag.swfobject = swfobject;
      return true;
    } 
    // embed the script if we havent already
    else if (!CameraTag.swfObjectInjected) {
      var swfobject_script = document.createElement('script');
      swfobject_script.src = '//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js';
      document.body.insertBefore( swfobject_script, document.body.firstChild );
      CameraTag.swfObjectInjected = true;
    }
    else {
      return false;  
    }
  };

  setup();




  //
  // CameraTagUploader
  //

  var CameraTagUploader = function(browse_element_id) {
    var plUploadInjected = false;
    var pluploader;

    var setup = function(dont_init) {
      // make sure swfobject is available
      if (!plUploadReady()) {
        setTimeout(setup, 30);
        return;
      };

      init();
    };

    var plUploadReady = function() {
      // swfobject is ready
      if ( typeof(plupload) == "object" ) {
        CameraTag.plupload = plupload;
        return true;

      } 
      // embed the script if we havent already
      else if (!plUploadInjected) {
        var plupload_script = document.createElement('script');
        plupload_script.src = '//'+appServer+'/'+CameraTag.version+'/plupload/js/plupload.full.min.js';
        document.body.insertBefore( plupload_script, document.body.firstChild );
        plUploadInjected = true;
        return false;
      }
      else {
        return false;  
      }
    };

    self.restart_upload = function() {
      pluploader.stop();
      pluploader.start();
    };

    self.start_upload = function() {
      pluploader.start();
    };

    self.stop_upload = function() {
      pluploader.stop();
    };

    var init = function() {
      pluploader = new CameraTag.plupload.Uploader({
        // General settings
        runtimes : 'html5,flash,html4',
        url : 'http://s3.amazonaws.com/assets.cameratag.com',
        browse_button : browse_element_id,
        browse_button_hover : "selected",
        multi_selection     : false,
        
        // Specify what files to browse for
        filters : [
          {title : "v", extensions : "webm,3gp,avi,flv,mov,mpg,wmv,mp4"}
        ],

        // s3 shinanigans
        multipart_params: {
          'key': '', // this gets replaced on a file by file level during upload
          'acl': 'public-read',
          'success_action_status': '201',
          'AWSAccessKeyId': 'AKIAJCHWZMZ35EB62V2A',    
          'policy': ul_policy,
          'signature': ul_signature,
          'filename': "this is for flash runtime compatability"
        },
        file_data_name: 'file',

        // Flash settings
        flash_swf_url : '//cameratag.com/'+CameraTag.version+'/plupload/js/Moxie.swf'
      });

      pluploader.total_upload_size = function() {
        // calculate size
        var upload_bytes = 0;
        $(pluploader.files).each(function(index, file){
          upload_bytes += file.size;
        });
        return upload_bytes;
      };

      pluploader.validate_and_upload = function() {
        // start uploading or throw error
        if (pluploader.total_upload_size() >= 2147483648) {
          alert("You may only upload files up to 2GB in size.")
          sendStat("file_too_big_error");
        }
        else {
          state = "uploading";
          uploading = true; // andorid doesn't seem to get this set through the uploadStarted event?
          self.fire("uploadStarted");

          setTimeout(function(){ pluploader.start(); }, 10);

          upload_screen.show();
          start_screen.hide();

          var isAndroid = navigator.userAgent.toLowerCase().indexOf("android") > -1; //&& ua.indexOf("mobile");
          if (isAndroid) {
            upload_status.html("...");
          }
          else {
            upload_status.html("0%");
          }
        }
      }

      // set key and upload
      pluploader.bind('FilesAdded', function(up, files) {
        // set the uuid for each file upload
        $(files).each(function(index, file){
          file.s3_key = "recordings/" + video.uuid + ".flv";
          self.fire("uploadFileSelected", file);
        });
        pluploader.validate_and_upload();
      });

      // set file key before uploading
      pluploader.bind('UploadFile', function(up, file) { 
        pluploader.settings.multipart_params.key = file.s3_key;
      });

      // binds remove file callback
      pluploader.bind('FilesRemoved', function(up, files) {
        // maybe we'll use this?
      });

      // binds progress to progress bar
      pluploader.bind('UploadProgress', function(up, file) {
        self.fire("uploadProgress", file);
      });

      // binds individual file uploaded
      pluploader.bind('FileUploaded', function(up, file, info) {
        readyToPublish = true;
        self.fire("readyToPublish");
        sendStat("upload_success", {message: info.response, status: info.status});

        if (publishOnUpload) {
          self.publish(); // publish without s3  
        }
        else {
          self.loadInterface(completed_screen);
        }  
      });

      // binds all files uploaded
      pluploader.bind('UploadComplete', function(up, file) {
        // dont need to do anything here 
      });

      // shows error object in the browser console (for now)
      pluploader.bind('Error', function(up, error) {
        // unfortunately PLUpload gives some extremely vague 
        // Flash error messages so you have to use WireShark
        // for debugging them (read the README)
        // console.log('Expand the error object below to see the error. Use WireShark to debug.');
        sendStat("upload_error", error);
        self.fire("uploadAborted", error);
        self.loadInterface(start_screen, true);
      });

      pluploader.init();
      u = pluploader;
    }



    setup();
  }



















}









//
// CameraTagPlayer
//
CameraTagPlayer = function(video_el) {
  var $ = CameraTag.jQuery; // we keep a localized version in case your not already using jQuery
  video_el = $(video_el);
  var uuid = video_el.attr("data-uuid");
  var appServer = video_el.attr("data-appserver") || "cameratag.com";
  var videojsInjected = false;
  var self = this;
  var video = {};
  var dom_id = video_el.attr("id") || uuid;

  var setup = function(){
    // make sure videojs is ready
    if (!videojsReady()) {
      setTimeout(function(){
        new CameraTagPlayer(video_el);
      }, 30);
      return;
    };

    // hit server and get formats, permission
    $.ajax({
      url: "//"+appServer+"/videos/"+uuid+".json",
      type:"get",
      dataType: "jsonp",
      data: {
        referer: window.location.toString()
      },
      success: function(response) {
        video = response;
        build_video_tag();
        init_videojs();
      },
      error: function() {
      }
    });
  }

  var find_format_by_name = function(name) {
    var result = $.grep(video.formats, function(e){ return e.name == name; });
    return result[0];
  }

  var build_video_tag = function() {
    var new_video_tag = $('<video></video>')

    var format = find_format_by_name( video_el.attr("data-format") ) || video.formats[0];

    // set id
    new_video_tag.attr("id", dom_id);

    // add height and width
    if (video_el.attr("height")) {
      var height = video_el.attr("height")
    }
    else {
      var height = format.height / 2;
    }
    new_video_tag.attr("height", height);

    if (video_el.attr("width")) {
      var width = video_el.attr("width")
    }
    else {
      var width = format.width / 2;
    }
    new_video_tag.attr("width", width);
    

    // add poster attribute
    new_video_tag.attr("poster", "//"+appServer+"/videos/"+uuid+"/"+format.name+"/thumb")

    // add video js classes
    new_video_tag.addClass("video-js");
    new_video_tag.addClass("vjs-default-skin");

    // add sources to video element
    var h264_source = $('<source src="//'+appServer+'/videos/'+uuid+'/'+format.name+'/mp4" type="video/mp4" />');
    new_video_tag.append(h264_source);

    var webm_source = $('<source src="//'+appServer+'/videos/'+uuid+'/'+format.name+'/webm" type="video/webm" />');
    new_video_tag.append(webm_source);

    video_el.replaceWith(new_video_tag);
  }

  var init_videojs = function() {
    // kill from videojs cache if necessary
    for( vid in _V_.players ){
      if(vid.toString() == dom_id){
       delete _V_.players[vid]
      }
    }
    var player = videojs(dom_id, { controls: true, techOrder:["flash","html5"] }, function(){
      // Player (this) is initialized and ready.
    });
    CameraTag.players[dom_id] = player;
  }

  var videojsReady = function() {
    // videojs is ready
    if ( typeof(videojs) == "function" ) {
      CameraTag.videojs = videojs;
      return true;
    }
    // embed the script if we havent already
    else if (!CameraTag.videojsInjected) {
      var videojs_script = document.createElement('script');
      videojs_script.src = "//"+appServer+"/"+CameraTag.version+"/videojs.js";

      var videojs_css = document.createElement('link');
      videojs_css.href = "//"+appServer+"/"+CameraTag.version+"/videojs.css";
      videojs_css.rel = "stylesheet";
      videojs_css.type = "text/css";

      document.body.insertBefore( videojs_script, document.body.firstChild );
      document.body.insertBefore( videojs_css, document.body.firstChild );
      CameraTag.videojsInjected = true;

      return false
    }
    else {
      return false;  
    }
  };

  setup();
}













//
// CameraTag
//

CameraTag = {};
CameraTag.version = 1.9;

CameraTag.cameras = {};
CameraTag.players = {};

CameraTag.callbacks = {};

CameraTag.jQuery = null;
CameraTag.jQueryPreInstalled = window.jQuery && jQuery.fn && /^[1-9]/.test(jQuery.fn.jquery) || false;
CameraTag.jQueryInjected = false;
CameraTag.swfObjectInjected = false;

CameraTag.setup = function() {
  // make sure prototype is available
  if (!CameraTag.jQueryReady()) {
    setTimeout(CameraTag.setup, 30);
    return;
  };

  // create instances for each camera tag in the page
  CameraTag.instantiateCameras();

  // create instances for each video tag in the page
  CameraTag.instantiatePlayers();
}

CameraTag.jQueryReady = function() {
  // jQuery is already instaled by end user
  if ( CameraTag.jQueryPreInstalled ) {
    CameraTag.jQuery = jQuery;
    return true;
  }
  // Our version is installed
  else if (CameraTag.jQuery) {
    return true;
  } 
  // Our injected version of jQuery is ready- now let's scope it
  else if (window.jQuery && jQuery.fn && /^[1-9]/.test(jQuery.fn.jquery) ) {
    CameraTag.jQuery = jQuery.noConflict(true);
    return true;
  }
  // Cant find a jQuery because it didnt already exist and we haven't injected it yet
  else if (!CameraTag.jQuery && !CameraTag.jQueryInjected) {
    var jquery_script = document.createElement('script');
    jquery_script.src = '//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js';
    document.body.insertBefore( jquery_script, document.body.firstChild );
    CameraTag.jQueryInjected = true;
    return false;
  }
  else {
    return false;  
  }
}

CameraTag.instantiateCameras = function() {
  CameraTag.jQuery("camera").each(function(index, camera_el){
    new CameraTagRecorder(camera_el);
  });
};

CameraTag.instantiatePlayers = function() {
  CameraTag.jQuery("video").each( function(index, video_el) {
    if (CameraTag.jQuery(video_el).attr("data-uuid")) {
      new CameraTagPlayer( CameraTag.jQuery(video_el) );
    }
  });
};

// EVENT OBSERVATION
CameraTag.observe = function(camera_dom_id,event_name,callback,priority) {
  priority = priority || false;
  if ( !CameraTag.callbacks[camera_dom_id] )
    CameraTag.callbacks[camera_dom_id] = {};
  if ( !CameraTag.callbacks[camera_dom_id][event_name] )
    CameraTag.callbacks[camera_dom_id][event_name] = [];

  if (priority) {
    CameraTag.callbacks[camera_dom_id][event_name].splice(0,0,callback);
  }
  else {
    CameraTag.callbacks[camera_dom_id][event_name].push(callback);  
  }
  
};

CameraTag.fire = function(camera_dom_id,event_name,data) {
  if ( !CameraTag.callbacks[camera_dom_id] )
    CameraTag.callbacks[camera_dom_id] = {};
  if ( !CameraTag.callbacks[camera_dom_id][event_name] )
    CameraTag.callbacks[camera_dom_id][event_name] = [];
  
  setTimeout(function(){
    CameraTag.fire_handlers(camera_dom_id,event_name,data);
  }, 1);
};

CameraTag.fire_handlers = function(camera_dom_id,event_name,data) {
  for( i = 0; i < CameraTag.callbacks[camera_dom_id][event_name].length; i++ ) {
    try {
      CameraTag.callbacks[camera_dom_id][event_name][i](data);
    }
    catch(err) {}
  }
}

CameraTag.stopObserving = function(camera_dom_id,event_name,callback) {
  if ( !CameraTag.callbacks[camera_dom_id] )
    CameraTag.callbacks[camera_dom_id] = {};
  if ( !CameraTag.callbacks[camera_dom_id][event_name] )
    CameraTag.callbacks[camera_dom_id][event_name] = [];
  
  var newCallbacks = [];
  for( i = 0; i < CameraTag.callbacks[camera_dom_id][event_name].length; i++ ) {
    if( CameraTag.callbacks[camera_dom_id][event_name][i] != callback )
      newCallbacks.push(callback)
  }
  
  CameraTag.callbacks[camera_dom_id][event_name] = newCallbacks;
};

CameraTag.prototype = CameraTag;








//
// TIP THE FIRST DOMINO
//



function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
};

addLoadEvent(CameraTag.setup);