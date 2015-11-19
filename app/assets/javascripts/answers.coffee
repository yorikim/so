$ ->
  $('.edit-answer-link').click (e)->
    e.preventDefault();
    $('#edit_answer_' + $(this).data('answerId')).show();

  $('.answer-container .vote-up, .answer-container .vote-down').bind 'ajax:success', (e, data) ->
    id = '#answer-container-' + $(this).data('answerId');
    $(id + ' .vote-value').text(data.vote_value)
    $(id + ' .vote-up').toggleClass('active', data.vote_status is 1)
    $(id + ' .vote-down').toggleClass('active', data.vote_status is -1)