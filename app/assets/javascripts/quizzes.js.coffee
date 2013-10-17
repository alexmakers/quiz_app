# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

startQuiz = ->
  $('.start-quiz').hide()

  setInterval ->
    time_remaining = $('.timer').data('time-remaining')

    if time_remaining > 0
      time_remaining -= 1
      $('.timer').data('time-remaining', time_remaining)
      $('.timer').text(time_remaining)
    else
      correct = $.grep window.results, (elem) ->
        elem

      $('.result').text(correct.length / window.results.length * 100 + '% got it right!')
      window.results = []

      $('.question.active').removeClass('active').next().addClass('active')
      $('.timer').data('time-remaining', 15).text('15')

  , 1000

dispatcher = new WebSocketRails 'localhost:3000/websocket'

channel = dispatcher.subscribe 'quizzes'
channel.bind 'new', (quiz) ->
  $('body').prepend $('<h3>', {text: quiz.title})

channel.bind 'start', (quiz) ->
  startQuiz()
  $('.question:first').addClass('active')

answer_channel = dispatcher.subscribe 'answers'
answer_channel.bind 'new', (r) ->
  window.results.push(r.correct)

$ ->
  window.results = []

  $('.timer').data('time-remaining', 15).text('15')

  $('.start-quiz').click ->
    channel.trigger('start')

  $('.multiplayer button').click ->
    aid = $(this).data('id')
    qid = $(this).data('question-id')
    $('.question.active button').attr('disabled', true)

    $.post  '/multiplayer_attempts/check_answer', 
            {id: aid, question_id: qid},
            (response) ->
              if response.correct
                $('.my-answer').text('You got it right')
              else
                $('.my-answer').text('You got it wrong')