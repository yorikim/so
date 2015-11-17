$ ->
  $('.edit-answer-link').click (e)->
    e.preventDefault();
    $('#edit_answer_' + $(this).data('answerId')).show();