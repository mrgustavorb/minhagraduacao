$(document).ready(function() {

  var graduations = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/search/suggest.json?text=%QUERY'
  });
   
  graduations.initialize();
   
  $('.input-search-graduation').typeahead(null, {
    name: 'grad-search',
    displayKey: 'value',
    highlight: true,
    minLength: 3,
    source: graduations.ttAdapter(),
  }).on('typeahead:selected', function (evt, selected) {
     location.href = '/graduacao/'+selected.url;
  }).on('typeahead:autocompleted', function (evt, selected) {
     location.href = '/graduacao/'+selected.url;
  });

});