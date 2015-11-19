$ ->
  $('.edit-question-link').click (e)->
    e.preventDefault();
    $('#edit_question_' + $(this).data('questionId')).show();

  $('.question-container .vote-up, .question-container .vote-down').bind 'ajax:success', (e, data) ->
    $('.question-container .vote-value').text(data.vote_value)
    $('.question-container .vote-up').toggleClass('active', data.vote_status is 1)
    $('.question-container .vote-down').toggleClass('active', data.vote_status is -1)