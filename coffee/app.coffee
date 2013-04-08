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
  $(".lightbox").on "click", (evt) ->
    tag = $(evt.target).prop("tagName")
    unless tag == "A"
      lightbox.close()

  this.show_arrows()
  $(".lightbox img").remove()
  $(".lightbox").append("<img src='#{url}' />")


  $(".lightbox img").imagesLoaded ->
    $(".lightbox").css({ display: "block" })
    width = lightbox.image_width()
    img = $(".lightbox img")
    img.css({ width: width })
    top = $(document).scrollTop() + $(window).height() / 2 - img.outerHeight() / 2
    top = top - 50 # FIXME: hack
    img.css({ top: top })
    padding = 20 # from css
    margin_left = $(window).width() / 2 - img.width() / 2 - padding
    $(".lightbox img").css( left: margin_left-padding )

    links_top = img.outerHeight() / 2 + 20 # FIXME: hack

    $(".lightbox a").css( top: top+links_top  )
    
    out = $(".lightbox a.next").outerWidth() + 30
    $(".lightbox a").css( left: margin_left-out )
    $(".lightbox a.next").css( left: margin_left+img.outerWidth()-out/2+27 )


lightbox.show_arrows = ->
  prev_arrow = "<a class='prev' href='javascript:void(0)'><</a>"
  next_arrow = "<a class='next' href='javascript:void(0)'>></a>"
  $(".lightbox").prepend prev_arrow
  $(".lightbox").prepend next_arrow
  $(".lightbox").prepend "<div class='bg'></div>"

  this.bind_arrows()

lightbox.bind_arrows = ->
  this.load_images()
  $(".lightbox a").off "click"
  $(".lightbox .prev").on "click", (evt) ->
    lightbox.prev()
    evt.preventDefault()
  $(".lightbox .next").on "click", (evt) ->
    lightbox.next()
    evt.preventDefault()

lightbox.load_images = ->

lightbox.index = 0

lightbox.images = ->
  $("#container > .content img")

lightbox.current_img = ->
  $ this.images()[this.index]

lightbox.next = ->
  this.index += 1
  this.index = 0 if this.index >= this.images().length
  
  # this.close()

  # $(".lightbox img").attr "src", this.current_img().attr("src")
  this.show this.current_img().attr("src")
  # img = $(".lightbox img")
  # img.css({ width: img.outerWidth() })


lightbox.prev = ->
  console.log "Asdas2"

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
