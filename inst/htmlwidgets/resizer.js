HTMLWidgets.widget({

  name: 'resizer',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

        if (x.controls) {
          // Disable select if no urls or update choices
          if (x.urls === null) {
            $('#list_urls').attr('disabled', true);
          } else {
            var $el = $("#list_urls");
            $el.empty(); // remove old options
            $.each(x.urls, function(key,value) {
              $el.append($("<option></option>")
                 .attr("value", value).text(key));
            });
          }

          // select url
          $('#list_urls').on('change', function() {
            $('#sescreen_url' ).val(this.value);
            $('#screen_url_search').click();
          });

          // Initialize sliders
           $('#iframe_width').ionRangeSlider({
             onChange: function(data) {
               //$('#' + el.id).width(data.from + 10);
               $('.container').width(data.from + 0);
               $('.container').css('maxWidth', (data.from + 0) + "px");
             }
           });
           $('#iframe_height').ionRangeSlider({
             onChange: function(data) {
               //$('#' + el.id).width(data.from + 10);
               $('.container').height(data.from + 0);
               $('.container').css('maxHeight', (data.from + 0) + "px");
             }
           });

           // Update slider with action-links
           var sliderwidth = $("#iframe_width").data("ionRangeSlider");
           var sliderheight = $("#iframe_height").data("ionRangeSlider");
           $('#width800_height600').on('click', function() {
             sliderwidth.update({from: 800});
             $('.container').width(800);
             $('.container').css('maxWidth', 800 + "px");
             sliderheight.update({from: 600});
             $('.container').height(600);
             $('.container').css('maxHeight', 600 + "px");
           });
           $('#width1024_height768').on('click', function() {
             sliderwidth.update({from: 1024});
             $('.container').width(1024);
             $('.container').css('maxWidth', 1024 + "px");
             sliderheight.update({from: 768});
             $('.container').height(768);
             $('.container').css('maxHeight', 768 + "px");
           });

          // Update iframe src according to text input
          $('#screen_url_search').on('click', function(event) { // on click
            $('#' + el.id).attr('src', $('#sescreen_url').val());
          });
          $('#screen_url_reset').on('click', function(event) {
            $('#sescreen_url' ).val('');
            $('#' + el.id).attr('src', 'http://127.0.0.1');
          });
        }



        // select shiny app url if exist
        if (x.url_app !== null) {
          $('#' + el.id).attr('src', x.url_app);
          $('.container').width(x.width);
          $('.container').css('maxWidth', x.width + "px");
          $('.container').height(x.height);
          $('.container').css('maxHeight', x.height + "px");
        }

        // iframe resizer init
        $('#' + el.id).iFrameResize({minHeight: 600, scrolling: true, checkOrigin: false});
      },

      resize: function(width, height) {

      }

    };
  }
});
