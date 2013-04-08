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
    $(".lightbox").on("click", function(evt) {
      var tag;

      tag = $(evt.target).prop("tagName");
      if (tag !== "A") {
        return lightbox.close();
      }
    });
    this.show_arrows();
    $(".lightbox img").css({
      opacity: 0
    });
    $(".lightbox img").remove();
    $(".lightbox").append("<img src='" + url + "' />");
    return $(".lightbox img").imagesLoaded(function() {
      var img, links_top, margin_left, out, padding, top, width;

      $(".lightbox").css({
        display: "block"
      });
      $(".lightbox img").css({
        opacity: 1
      });
      width = lightbox.image_width();
      img = $(".lightbox img");
      img.css({
        width: width
      });
      top = $(document).scrollTop() + $(window).height() / 2 - img.outerHeight() / 2;
      top = top - 50;
      img.css({
        top: top
      });
      padding = 20;
      margin_left = $(window).width() / 2 - img.width() / 2 - padding;
      $(".lightbox img").css({
        left: margin_left - padding
      });
      links_top = img.outerHeight() / 2 + 20;
      $(".lightbox a").css({
        top: top + links_top
      });
      out = $(".lightbox a.next").outerWidth() + 30;
      $(".lightbox a").css({
        left: margin_left - out
      });
      return $(".lightbox a.next").css({
        left: margin_left + img.outerWidth() - out / 2 + 27
      });
    });
  };

  lightbox.show_arrows = function() {
    var next_arrow, prev_arrow;

    prev_arrow = "<a class='prev' href='javascript:void(0)'><</a>";
    next_arrow = "<a class='next' href='javascript:void(0)'>></a>";
    $(".lightbox").prepend(prev_arrow);
    $(".lightbox").prepend(next_arrow);
    $(".lightbox").prepend("<div class='bg'></div>");
    return this.bind_arrows();
  };

  lightbox.bind_arrows = function() {
    var self;

    this.load_images();
    $(".lightbox a").off("click");
    $(".lightbox .prev").on("click", function(evt) {
      lightbox.prev();
      return evt.preventDefault();
    });
    $(".lightbox .next").on("click", function(evt) {
      lightbox.next();
      return evt.preventDefault();
    });
    self = this;
    $(window).off("keydown");
    return $(window).on("keydown", function(evt) {
      if (evt.keyCode === 37) {
        self.prev();
      }
      if (evt.keyCode === 39) {
        return self.next();
      }
    });
  };

  lightbox.load_images = function() {};

  lightbox.index = 0;

  lightbox.images = function() {
    return $("#container > .content img");
  };

  lightbox.current_img = function() {
    return $(this.images()[this.index]);
  };

  lightbox.next = function() {
    this.index += 1;
    if (this.index >= this.images().length) {
      this.index = 0;
    }
    return this.show(this.current_img().data("src_big"));
  };

  lightbox.prev = function() {
    this.index -= 1;
    if (this.index <= 0) {
      this.index = this.images().length - 1;
    }
    return this.show(this.current_img().data("src_big"));
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
