$ ->
  $('.edit-question-link').click (e)->
    e.preventDefault();
    $('#edit_question_' + $(this).data('questionId')).show();