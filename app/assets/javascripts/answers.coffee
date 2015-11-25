$ ->
  $('.edit-answer-link').click (e)->
    e.preventDefault();
    $('#edit_answer_' + $(this).data('answerId')).show();

  $('.add-answer-comment-link').click (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $('#answer-container-' + answer_id + ' #new_comment').show();

  $('.answer-container .vote-up, .answer-container .vote-down').bind 'ajax:success', (e, data) ->
    id = '#answer-container-' + $(this).data('answerId');
    $(id + ' .vote-value').text(data.vote_value)
    $(id + ' .vote-up').toggleClass('active', data.vote_status is 1)
    $(id + ' .vote-down').toggleClass('active', data.vote_status is -1)

  question_id = $('.question-container').data('questionId')
  PrivatePub.subscribe "/questions/" + question_id + "/answers/comments/new", (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data.comment)
    $('#answer-container-' + comment.commentable_id + ' .comments').append('<p>' + comment.body + '</p>')
    $('.new_comment').hide()
    $('textarea[name="comment[body]"]').val('')

