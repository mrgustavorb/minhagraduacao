$(document).ready(function() {

  // Ratings
  $('.example-c').barrating('show', {
      showValues:true,
      showSelectedRating:false
  });

  // Research Students
  if($('.research-students').length > 0) {

    // Search school
    var schools = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/search/schools/suggest.json?text=%QUERY',
      limit: 5000
    });
   
    schools.initialize();
     
    $('.input-search-school').typeahead(null, {
      name: 'school-search',
      displayKey: 'text',
      highlight: true,
      minLength: 3,
      source: schools.ttAdapter()
    }).on('typeahead:selected', function (evt, selected) {
       $('#school_id').val(selected.value);
    }).on('typeahead:autocompleted', function (evt, selected) {
       $('#school_id').val(selected.value);
    });

    // Graduations Tags
    var graduations_tag = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/search/graduations/tag.json?text=%QUERY'
    });

    graduations_tag.initialize();

    tagsinput_graduation = $('.graduations_tags > > input');
    tagsinput_graduation.tagsinput({
      itemValue: 'value',
      itemText: 'text',
      maxTags: 3,
      minLength: 3,
    });

    tagsinput_graduation.tagsinput('input').typeahead(null, {
      name: 'graduations_tag',
      displayKey: 'text',
      source: graduations_tag.ttAdapter()
    }).on('typeahead:selected', $.proxy(function (obj, datum) {
      this.tagsinput('add', datum);
      this.tagsinput('input').typeahead('val', '');
    }, tagsinput_graduation))
    .on('typeahead:autocompleted', $.proxy(function (obj, datum) {
      this.tagsinput('add', datum);
      this.tagsinput('input').typeahead('val', '');
    }, tagsinput_graduation));


    // Institutions Tags
    var institutions_tag = new Bloodhound({
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: '/search/institutions/tag.json?text=%QUERY'
    });

    institutions_tag.initialize();

    tagsinput_institution = $('.institutions_tags > > input');
    tagsinput_institution.tagsinput({
      itemValue: 'value',
      itemText: 'text',
      maxTags: 3,
      minLength: 3,
    });

    tagsinput_institution.tagsinput('input').typeahead(null, {
      name: 'institutions_tag',
      displayKey: 'text',
      source: institutions_tag.ttAdapter()
    }).on('typeahead:selected', $.proxy(function (obj, datum) {
      this.tagsinput('add', datum);
      this.tagsinput('input').typeahead('val', '');
    }, tagsinput_institution))
    .on('typeahead:autocompleted', $.proxy(function (obj, datum) {
      this.tagsinput('add', datum);
      this.tagsinput('input').typeahead('val', '');
    }, tagsinput_institution));
  }

  // Research Academics
  if($('.research-academics').length > 0 || $('.research-professionals').length > 0) {

    $("#state_id").on('change', function () {

      select_state = $(this)
      select_institutions  = $("#institution_id")
      
      select_institutions.html('')

      $.ajax({
        type: 'GET',
        dataType: "json",  
        url: "institutions/"+$(this).val(),
        success: function (rt) {
          if(rt.length > 0) {
            option = $('<option>').text('Selecione uma instituição').attr('value', '')
            select_institutions.append(option)

            $(rt).each(function(i,element){
                select_institutions.append($('<option>').text(element[1]).attr('value', element[0]));
            });

            select_institutions.attr('disabled', false)
          } 
        }
      });

    }); 

    $("#institution_id").on('change', function () {

      select_instituions  = $(this)
      select_graduations  = $("#graduation_id")
      
      select_graduations.html('')

      $.ajax({
        type: 'GET',
        dataType: "json",  
        url: "graduations/"+select_instituions.val(),
        success: function (rt) {
          if(rt.length > 0) {
            option = $('<option>').text('Selecione a sua graduação').attr('value', '')
            select_graduations.append(option)

            $(rt).each(function(i,element){
                select_graduations.append($('<option>').text(element[1]).attr('value', element[0]));
            });

            select_graduations.attr('disabled', false)
          } 
        }
      });

    }); 
      
  }

});