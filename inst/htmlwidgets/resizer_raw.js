HTMLWidgets.widget({

  name: 'resizer_raw',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

        // select shiny app url if exist
        if (x.url_app !== null) {
          setTimeout(function() {
            $('#' + el.id).attr('src', x.url_app);
          }, 400);
          $('.container').width(x.width);
          $('.container').css('maxWidth', x.width + "px");
          $('.container').height(x.height);
          $('.container').css('maxHeight', x.height + "px");
        }

        // iframe resizer init
        $('#' + el.id).iFrameResize({minHeight: 600, scrolling: true});
      },

      resize: function(width, height) {

      }

    };
  }
});
