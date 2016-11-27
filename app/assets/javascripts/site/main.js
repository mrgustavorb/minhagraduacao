var bindFacebookEvents, fb_events_bound, fb_root, loadFacebookSDK, initializeFacebookSDK, restoreFacebookRoot, saveFacebookRoot;

fb_root = null;
fb_events_bound = false;

self.isMobile = function() {
  var regex;
  regex = /Android|webOS|iPhone|iPad|iPod|BlackBerry|Windows Phone/i;
  return regex.test(navigator.userAgent);
};

loadFacebookSDK = function() {
  window.fbAsyncInit = initializeFacebookSDK;
  return $.getScript("//connect.facebook.net/pt_BR/all.js#xfbml=1");
};

initializeFacebookSDK = function() {
  return FB.init({
    appId: '1445449555740807',
    channelUrl: '//minhagraduacao.com/channel.html',
    status: true,
    cookie: true,
    xfbml: true
  });
};

bindFacebookEvents = function() {
  $(document).on('page:fetch', saveFacebookRoot).on('page:change', restoreFacebookRoot).on('page:load', function() {
    return typeof FB !== "undefined" && FB !== null ? FB.XFBML.parse() : void 0;
  });
  return fb_events_bound = true;
};

saveFacebookRoot = function() {
  return fb_root = $('#fb-root').detach();
};

restoreFacebookRoot = function() {
  if ($('#fb-root').length > 0) {
    return $('#fb-root').replaceWith(fb_root);
  } else {
    return $('body').append(fb_root);
  }
};

$(document).ready(function() {
  
  loadFacebookSDK();

  if (!fb_events_bound) {
    bindFacebookEvents();
  }

});