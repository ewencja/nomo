function renderList(template, names) {
  var rendered = names.map(function(name) {
    return Mustache.render(template, {
      name: name,
      origins: name.origin.map(origin => origin.origin)
    });
  }).join('');
  $('#names-list').html(rendered);
}

var lastRequest;

function reloadContent(template, queryString) {
  let gender = url('?gender');
  if(lastRequest) {
    lastRequest.abort();
  }
  lastRequest = $.get({
    url: `/names/${gender}?${queryString}`,
    success: renderList.bind(undefined, template)
  });
}

var reloadContentThrottled =
  _.debounce(reloadContent, 200);

function refreshList(template) {
  let queryString = $('#search-form').serialize();
  reloadContent(template, queryString);
}

function refreshButtons() {
  $('#search-form [name=occurrence] button')
  .each((i, button) => {
    let input = $('#search-form [name=occurrence] input'),
    state = button.value === input.val();
    $(button).toggleClass('btn-primary', state);
  });
  $('#search-form [name=length] button')
  .each((i, button) => {
    let input = $('#search-form [name=length] input'),
    state = button.value === input.val();
    $(button).toggleClass('btn-primary', state);
  });
}

function onChange(template) {
  let queryString = $('#search-form').serialize();
  location.hash = '!?' + queryString;
  refreshButtons();
  refreshList(template);
}

if(/#!\?/.test(location.hash)) {
  location.hash.substring(3).split('&')
  .map(param => param.split('='))
  .filter(param => param[1])
  .forEach(param => {
    $(`input[name=${param[0]}]`).val(param[1]);
  });
}




function register() {

  console.log('register');

  let template = $('#name-entry').html();

  Mustache.parse(template);

  // Bind Origin input to autocomplete
  $('#search-form [name=origin1], #search-form [name=origin2]')
  .autocomplete({
    source: function(request, callback) {
      $.get({
        url: `/origins?` + $.param({ origin: request.term }),
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





(function() {

  this.App || (this.App = {});

  App.names = App.names || {
    register: _.once(register)
  }

}).call(this);
