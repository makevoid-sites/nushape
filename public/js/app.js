(function() {
  var bind_lightbox, lightbox, sections;

  sections = ["peluches", "sketchbook"];

  _.defer(function() {
    return bind_lightbox();
  });

  bind_lightbox = function() {
    var sections_classes;

    sections_classes = _(sections).map(function(sec) {
      return "." + sec + " img";
    });
    return $("" + (sections_classes.join(", "))).on("click", function() {
      var url;

      url = $(this).data("src_big");
      lightbox();
      return lightbox.show(url);
    });
  };

  lightbox = function() {
    var time, _i, _len, _ref;

    $(".lightbox").remove();
    $("body").prepend("<div class='lightbox'></div>");
    _ref = [0, 200, 500, 1000, 2000];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      time = _ref[_i];
      setTimeout(function() {
        return lightbox.resize();
      }, time);
    }
    return $(window).on("resize", function() {
      return lightbox.resize();
    });
  };

  window.lightbox = lightbox;

  lightbox.show = function(url) {
    $(".lightbox").on("click", function() {
      return lightbox.close();
    });
    $(".lightbox").append("<img src='" + url + "' />");
    return $(".lightbox img").imagesLoaded(function() {
      var img, marginLeft, padding, width;

      $(".lightbox").css({
        display: "block"
      });
      width = lightbox.image_width();
      img = $(".lightbox img");
      img.css({
        width: width
      });
      img.css({
        top: $(document).scrollTop()
      });
      marginLeft = img.width() / 2;
      padding = 15;
      return $(".lightbox").css({
        left: -marginLeft - padding
      });
    });
  };

  lightbox.resize = function() {
    var height, wheight;

    height = $("body").height();
    wheight = $(window).height();
    height = Math.max(height, wheight);
    return $(".lightbox").height(height);
  };

  lightbox.close = function() {
    return $(".lightbox").hide();
  };

  lightbox.image_width = function() {
    var height, page_height, ratio, width;

    page_height = $(window).height() - parseInt($(".lightbox img").css("marginTop")) * 2;
    width = $(".lightbox img").width();
    height = $(".lightbox img").height();
    ratio = width / height;
    height = Math.min(page_height, height);
    return height * ratio;
  };

}).call(this);
