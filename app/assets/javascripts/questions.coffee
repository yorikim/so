$ ->
  $('.edit-question-link').click (e)->
    e.preventDefault();
    $('#edit_question_' + $(this).data('questionId')).show();

  $('.add-question-comment-link').click (e) ->
    e.preventDefault();
    $('.question-container #new_comment').show();

  $('.question-container .vote-up, .question-container .vote-down').bind 'ajax:success', (e, data) ->
    $('.question-container .vote-value').text(data.vote_value)
    $('.question-container .vote-up').toggleClass('active', data.vote_status is 1)
    $('.question-container .vote-down').toggleClass('active', data.vote_status is -1)

  PrivatePub.subscribe "/questions/new", (data, channel) ->
    console.log(data.question)

    question = $.parseJSON(data.question);
    wrapper = Mustache.render('\
        <div class="question-summary row">
          <div class="col-lg-1">
            <strong>{{vote_value}}</strong>
          </div>
          <div class="col-lg-11">
            <a href="/questions/{{id}}">{{title}}</a>
          </div>
        </div>', question);

    $('.questions').append(wrapper);
    $('input[name="comment[body]"]').val('')

  question_id = $('.question-container').data('questionId')
  PrivatePub.subscribe "/questions/" + question_id + "/comments/new", (data, channel) ->
    console.log(data)
    comment = $.parseJSON(data.comment);
    $('#question-comments').append('<p>' + comment.body + '</p>')
    $('.new_comment').hide()
    $('input[name="comment[body]"]').val('')

