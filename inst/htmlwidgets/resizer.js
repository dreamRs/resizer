/*jshint
  jquery:true
*/
/*global HTMLWidgets */
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
            $("#" + el.id).attr("src", iframeSrc);
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
            onFinish: function(data) {
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
            onFinish: function(data) {
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
          $(".shortcut-resolution").on("click", function(e) {
            var width = $(this).data("width");
            var height = $(this).data("height");
            sliderwidth.update({ from: width });
            $(".container").width(width);
            $(".container").css("maxWidth", width + "px");
            sliderheight.update({ from: height });
            $(".container").height(height);
            $(".container").css("maxHeight", height + "px");
            var autoR = document.getElementById("autorefresh").checked;
            if (autoR) {
              $("#refresh").click();
            }
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
          }, 400);
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

