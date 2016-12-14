function renderList(template, names) {
  var rendered = names.map(function(name) {
    return Mustache.render(template, {
      name: name,
      origins: name.origin.map(function(origin) {
        origin.origin
      })
    });
  }).join('');
  $('#names-list').html(rendered);
}

var lastRequest;

function serializeForm() {
  return $('#search-form').serialize().replace('+', ' ');
}

function reloadContent(template, queryString) {
  var gender = url('?gender');
  if(lastRequest) {
    lastRequest.abort();
  }
  lastRequest = $.get({
    url: '/names/' + gender + '?' + queryString,
    success: renderList.bind(undefined, template)
  });
}

var reloadContentThrottled =
  _.debounce(reloadContent, 200);

function refreshList(template) {
  var queryString = serializeForm();
  reloadContent(template, queryString);
}

function refreshButtons() {
  $('#search-form [name=occurrence] button')
  .each(function(i, button) {
    var input = $('#search-form [name=occurrence] input'),
    state = button.value === input.val();
    $(button).toggleClass('btn-primary', state);
  });
  $('#search-form [name=length] button')
  .each(function(i, button) {
    var input = $('#search-form [name=length] input'),
    state = button.value === input.val();
    $(button).toggleClass('btn-primary', state);
  });
}

function onChange(template) {
  var gender = url('?gender');
  var queryString = serializeForm();
  location.search = '?gender=' + gender + '&' + queryString;
  refreshButtons();
  refreshList(template);
}

if(/\?/.test(location.search)) {
  location.search
    .substring(1)
    .split('&')
    .map(function(param) {
      return param.split('=');
    })
    .map(function(param) {
      param[0].replace(' ', '+');
      param[1] = decodeURI(param[1]);
      return param;
    })
    .filter(function(param) {
      return param[1];
    })
    .forEach(function(param) {
      console.log(param[0], param[1]);
      $('input[name=' + param[0] + ']').val(param[1]);
    });
}




function register() {

  console.log('register');

  var template = $('#name-entry').html();

  Mustache.parse(template);

  // Bind Origin input to autocomplete
  $('#search-form [name=origin1], #search-form [name=origin2]')
  .autocomplete({
    source: function(request, callback) {
      $.get({
        url: '/origins?' + $.param({ origin: request.term }),
        success: callback
      });
    },
    minLength: 2,
    select: onChange.bind(undefined, template)
  });

  // Bind Buttons
  $('#search-form [name=occurrence] button')
    .click(function(event) {
      $('#search-form [name=occurrence] input').val(event.target.value);
      onChange(template);
    });
  $('#search-form [name=length] button')
    .click(function(event) {
      $('#search-form [name=length] input').val(event.target.value);
      onChange(template);
    });



  refreshButtons();
  refreshList(template);

}


function openNameModal() {
  var template = $('#nameModalTemplate')
  console.log('openNameModal')
}


(function() {

  this.App || (this.App = {});

  App.names = App.names || {
    register: register,
    openNameModal: openNameModal
  }

}).call(this);
