$(document).ready(function() {

    'use strict';

    var tpj = jQuery;
    tpj.noConflict();
    tpj(document).ready(function() {
        if (tpj.fn.cssOriginal != undefined)
            tpj.fn.css = tpj.fn.cssOriginal;

        tpj('.fullscreenbanner').show();

        //revolution slider
        tpj('.fullscreenbanner').revolution({
            delay: 10000,
            startwidth: 1170,
            startheight: 600,
            onHoverStop: "on", // Stop Banner Timet at Hover on Slide on/off

            thumbWidth: 100, // Thumb With and Height and Amount (only if navigation Tyope set to thumb !)
            thumbHeight: 50,
            thumbAmount: 3,
            hideThumbs: 0,
            navigationType: "none", // bullet, thumb, none
            navigationArrows: "solo", // nexttobullets, solo (old name verticalcentered), none

            navigationStyle: "round", // round,square,navbar,round-old,square-old,navbar-old, or any from the list in the docu (choose between 50+ different item), custom


            navigationHAlign: "right", // Vertical Align top,center,bottom
            navigationVAlign: "bottom", // Horizontal Align left,center,right
            navigationHOffset: 30,
            navigationVOffset: 30,
            soloArrowLeftHalign: "right",
            soloArrowLeftValign: "center",
            soloArrowLeftHOffset: 60,
            soloArrowLeftVOffset: 0,
            soloArrowRightHalign: "right",
            soloArrowRightValign: "center",
            soloArrowRightHOffset: 20,
            soloArrowRightVOffset: 0,
            touchenabled: "on", // Enable Swipe Function : on/off


            stopAtSlide: -1, // Stop Timer if Slide "x" has been Reached. If stopAfterLoops set to 0, then it stops already in the first Loop at slide X which defined. -1 means do not stop at any slide. stopAfterLoops has no sinn in this case.
            stopAfterLoops: -1, // Stop Timer if All slides has been played "x" times. IT will stop at THe slide which is defined via stopAtSlide:x, if set to -1 slide never stop automatic

            hideCaptionAtLimit: 0, // It Defines if a caption should be shown under a Screen Resolution ( Basod on The Width of Browser)
            hideAllCaptionAtLilmit: 0, // Hide all The Captions if Width of Browser is less then this value
            hideSliderAtLimit: 0, // Hide the whole slider, and stop also functions if Width of Browser is less than this value


            fullWidth: "on", // Same time only Enable FullScreen of FullWidth !!
            fullScreen: "on", // Same time only Enable FullScreen of FullWidth !!
            fullScreenOffsetContainer: "#topheader-to-offset", // The Height of Fullheight will be increased with this Container height !

            shadow: 0, //0 = no Shadow, 1,2,3 = 3 Different Art of Shadows -  (No Shadow in Fullwidth Version !)

            lazyLoad: "on"
        });

        tpj('.banner').revolution({
            delay: 9000,
            startwidth: 1170,
            startheight: 440,
            onHoverStop: "on", // Stop Banner Timet at Hover on Slide on/off

            thumbWidth: 170, // Thumb With and Height and Amount (only if navigation Tyope set to thumb !)
            thumbHeight: 100,
            thumbAmount: 3,
            hideThumbs: 0,
            navigationType: "thumb", // bullet, thumb, none
            navigationArrows: "solo", // nexttobullets, solo (old name verticalcentered), none

            navigationStyle: "round", // round,square,navbar,round-old,square-old,navbar-old, or any from the list in the docu (choose between 50+ different item), custom


            navigationHAlign: "left", // Vertical Align top,center,bottom
            navigationVAlign: "top", // Horizontal Align left,center,right
            navigationHOffset: 500,
            navigationVOffset: -185,
            soloArrowLeftHalign: "right",
            soloArrowLeftValign: "top",
            soloArrowLeftHOffset: 40,
            soloArrowLeftVOffset: -205,
            soloArrowRightHalign: "right",
            soloArrowRightValign: "top",
            soloArrowRightHOffset: 0,
            soloArrowRightVOffset: -205,
            touchenabled: "on", // Enable Swipe Function : on/off


            stopAtSlide: -1, // Stop Timer if Slide "x" has been Reached. If stopAfterLoops set to 0, then it stops already in the first Loop at slide X which defined. -1 means do not stop at any slide. stopAfterLoops has no sinn in this case.
            stopAfterLoops: -1, // Stop Timer if All slides has been played "x" times. IT will stop at THe slide which is defined via stopAtSlide:x, if set to -1 slide never stop automatic

            hideCaptionAtLimit: 0, // It Defines if a caption should be shown under a Screen Resolution ( Basod on The Width of Browser)
            hideAllCaptionAtLilmit: 0, // Hide all The Captions if Width of Browser is less then this value
            hideSliderAtLimit: 0, // Hide the whole slider, and stop also functions if Width of Browser is less than this value


            fullWidth: "on", // Same time only Enable FullScreen of FullWidth !!
            fullScreen: "on", // Same time only Enable FullScreen of FullWidth !!
            fullScreenOffsetContainer: "", // The Height of Fullheight will be increased with this Container height !

            shadow: 0, //0 = no Shadow, 1,2,3 = 3 Different Art of Shadows -  (No Shadow in Fullwidth Version !)

            lazyLoad: "on"
        });


        //social buttons
        tpj('.twitter').sharrre({
            share: {
                twitter: true
            },
            enableHover: false,
            enableTracking: true,
            buttons: {twitter: {via: '_JulienH'}},
            click: function(api, options) {
                api.simulateClick();
                api.openPopup('twitter');
            }
        });

        tpj('.facebook').sharrre({
            share: {
                facebook: true
            },
            enableHover: false,
            enableTracking: true,
            click: function(api, options) {
                api.simulateClick();
                api.openPopup('facebook');
            }
        });

        tpj('.googleplus').sharrre({
            share: {
                googlePlus: true
            },
            enableHover: false,
            enableTracking: true,
            click: function(api, options) {
                api.simulateClick();
                api.openPopup('googlePlus');
            }
        });

        tpj("[id*='Btn']").stop(true).on('click',function(e){e.preventDefault();tpj(this).scrolld();});

        tpj('.btn-slide').on('click', function () {
            tpj(".btn-slide").find('img').removeClass("active");
            tpj(this).find('img').addClass('active')
            tpj(this).find('img').addClass('active')
            
            tpj("[id*='area']").css('display', 'none')
            tpj("#area-"+tpj(this).attr('id')).css('display', 'block')
        });


        tpj('.nav a').on('click', function(){ 
            if(tpj('.navbar-toggle').css('display') !='none'){
                tpj(".navbar-toggle").trigger( "click" );
            }
        });
        
    });

});

