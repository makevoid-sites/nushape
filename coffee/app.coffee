# configs

sections = ["peluches", "sketchbook"]


# main

_.defer ->
  bind_lightbox()



# events

bind_lightbox = ->
  sections_classes = _(sections).map (sec) -> ".#{sec} img"
  $("#{sections_classes.join(", ")}").on "click", ->
    url = $(this).data("src_big")
    lightbox()
    lightbox.show url


# lightbox


lightbox = ->
  $(".lightbox").remove()
  $("body").prepend("<div class='lightbox'></div>")

  for time in [0, 200, 500, 1000, 2000]
    setTimeout ->
      lightbox.resize()
    , time

  $(window).on "resize", ->
    lightbox.resize()

window.lightbox = lightbox

lightbox.show = (url) ->
  $(".lightbox").on "click", ->
    lightbox.close()

  $(".lightbox").append("<img src='#{url}' />")

  $(".lightbox img").imagesLoaded ->
    $(".lightbox").css({ display: "block" })
    width = lightbox.image_width()
    img = $(".lightbox img")
    img.css({ width: width })
    img.css({ top: $(document).scrollTop() })
    marginLeft = img.width() / 2
    padding = 15 # from css
    # console.log $(window).width(), img.width(), marginLeft
    $(".lightbox").css( left: -marginLeft-padding )



lightbox.resize = ->
  height = $("body").height()
  wheight = $(window).height()
  height = Math.max height, wheight
  $(".lightbox").height height

lightbox.close = ->
  $(".lightbox").hide()

lightbox.image_width = ->
  page_height = $(window).height() - parseInt($(".lightbox img").css("marginTop"))*2
  width = $(".lightbox img").width()
  height = $(".lightbox img").height()
  ratio = width / height
  height = Math.min page_height, height
  height * ratio
