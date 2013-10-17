# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

dispatcher = new WebSocketRails 'localhost:3000/websocket'

channel = dispatcher.subscribe 'quizzes'
channel.bind 'new', (quiz) ->
  $('body').prepend $('<h3>', {text: quiz.title})

$ ->

  $('.timer').data('time-remaining', 30).text('30')

  setInterval ->
    time_remaining = $('.timer').data('time-remaining')

    time_remaining -= 1
    $('.timer').data('time-remaining', time_remaining)
    $('.timer').text(time_remaining)
  , 1000

  $('.question:first').addClass('active')

  $('.multiplayer button').click ->
    aid = $(this).data('id')
    qid = $(this).data('question-id')

    $.post  '/multiplayer_attempts/check_answer', 
            {id: aid, question_id: qid},
            (response) ->
              alert(response['correct'])
              $('.question.active').removeClass('active').next().addClass('active')