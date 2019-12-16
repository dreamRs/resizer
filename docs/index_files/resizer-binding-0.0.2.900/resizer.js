HTMLWidgets.widget({
  name: "resizer",

  type: "output",

  factory: function(el, width, height) {
    var iframeSrc;

    return {
      renderValue: function(x) {
        // iframe resizer init
        var iframe = $("#" + el.id).iFrameResize({
          minHeight: 600,
          minWidth: 0,
          scrolling: true,
          widthCalculationMethod: "min",
          checkOrigin: false,
          autoResize: false
        });

        if (x.controls) {
          // Disable select if no urls or update choices
          if (x.urls === null) {
            $("#list_urls").attr("disabled", true);
          } else {
            iframeSrc = x.urls[Object.keys(x.urls)[0]];
            $('#' + el.id).attr('src', iframeSrc);
            var $el = $("#list_urls");
            $el.empty(); 
            $.each(x.urls, function(key, value) {
              $el.append(
                $("<option></option>")
                  .attr("value", value)
                  .text(key)
              );
            });
          }

          // select url
          $("#list_urls").on("change", function() {
            $("#screen_url_text").val(this.value);
            $("#screen_url_search").click();
          });

          // Initialize sliders
          $("#iframe_width").ionRangeSlider({
            skin: "round",
            onChange: function(data) {
              $(".container").width(data.from + 0);
              $(".container").css("maxWidth", data.from + 0 + "px");
              iframe.resize();
            },
            onFinish: function (data) {
              var autoR = document.getElementById("autorefresh").checked;
             // fired on pointer release
             if (autoR) {
               $("#refresh").click();
             }
            }
          });
          $("#iframe_height").ionRangeSlider({
            skin: "round",
            onChange: function(data) {
              $(".container").height(data.from + 0);
              $(".container").css("maxHeight", data.from + 0 + "px");
              iframe.resize();
            },
            onFinish: function (data) {
              var autoR = document.getElementById("autorefresh").checked;
             // fired on pointer release
             if (autoR) {
               $("#refresh").click();
             }
            }
          });

          // Update slider with action-links
          var sliderwidth = $("#iframe_width").data("ionRangeSlider");
          var sliderheight = $("#iframe_height").data("ionRangeSlider");
          $("#width800_height600").on("click", function() {
            sliderwidth.update({ from: 800 });
            $(".container").width(800);
            $(".container").css("maxWidth", 800 + "px");
            sliderheight.update({ from: 600 });
            $(".container").height(600);
            $(".container").css("maxHeight", 600 + "px");
          });
          $("#width1024_height768").on("click", function() {
            sliderwidth.update({ from: 1024 });
            $(".container").width(1024);
            $(".container").css("maxWidth", 1024 + "px");
            sliderheight.update({ from: 768 });
            $(".container").height(768);
            $(".container").css("maxHeight", 768 + "px");
          });

          // Update iframe src according to text input
          $("#screen_url_search").on("click", function(event) {
            iframeSrc = $("#screen_url_text").val();
            $("#" + el.id).attr("src", iframeSrc);
          });
          $("#screen_url_reset").on("click", function(event) {
            $("#screen_url_text").val("");
            $("#" + el.id).attr("src", "http://127.0.0.1");
          });
        }

        // select shiny app url if exist
        if (x.url_app !== null) {
          iframeSrc = x.url_app;
          setTimeout(function() {
            $("#" + el.id).attr("src", iframeSrc);
          }, 300);
          $(".container").width(x.width);
          $(".container").css("maxWidth", x.width + "px");
          $(".container").height(x.height);
          $(".container").css("maxHeight", x.height + "px");
        }

        $("#refresh").on("click", function() {
          $("#" + el.id).attr("src", iframeSrc);
        });
      },

      resize: function(width, height) {}
    };
  }
});

