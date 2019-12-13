HTMLWidgets.widget({

  name: 'shinyscreenno',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // select shiny app url if exist
        if (x.url_app !== null) {
          $('#' + el.id).attr('src', x.url_app);
          $('.container').width(x.width);
          $('.container').css('maxWidth', x.width + "px");
          $('.container').height(x.height);
          $('.container').css('maxHeight', x.height + "px");
        }

        // iframe resizer init
        $('#' + el.id).iFrameResize({minHeight: 600, scrolling: true});
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
