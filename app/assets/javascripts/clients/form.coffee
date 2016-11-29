CIF.ClientsNew = CIF.ClientsCreate = CIF.ClientsUpdate = CIF.ClientsEdit = do ->
  _init = ->
    _clientSelectOption()
    _checkClientBirthdateAvailablity()
    _fixedHeaderStageQuestion()
    _toggleAnswer()

  _clientSelectOption = ->
    $("#clients-edit select, #clients-new select, #clients-update select, #clients-create select").select2
      minimumInputLength: 0

    $('select.able-related-info').change ->
      qtSelectedSize = $('select.able-related-info option:selected').length

      if qtSelectedSize > 0
        $('#client_able').val(true)
        $('#fake_client_able').prop('checked', true)
      else
        $('#client_able').val(false)
        $('#fake_client_able').prop('checked', false)

  _fixedHeaderStageQuestion = ->
    $('#stage-question table.client-new').dataTable(
      'sScrollY': '500px'
      'sScrollX': true
      'sScrollXInner': '100%'
      'bPaginate': false
      'bFilter': false
      'bInfo': false
      'bSort': false
      'sScrollY': '500px'
      'bAutoWidth': true
      'sScrollX': '100%'
      'sScrollXInner': '100%')

  _arrangeQuestionAndAnswerBlock = ->
    questionsAndAnswers = $('.question_and_answer')
    for questionAndAnswer in questionsAndAnswers
      qa = $(questionAndAnswer)
      if qa.data('is-stage')
        html = qa.html()
        $('#stage-question').append(html)
        qa.remove()
      else
        html = qa.html()
        $('#non-stage-question').append(html)
        qa.remove()

  _checkClientBirthdateAvailablity = ->
    button = $('#able-screening-test')
    if $('#client_date_of_birth').val() == ''
      button.attr('disabled', 'disabled')
    $('#client_date_of_birth').change ->
      if $('#client_date_of_birth').val() == ''
        button.attr('disabled', 'disabled')
      else
        button.removeAttr('disabled')
        _toggleAnswer()

  _getAge = (dateString) ->
    today = new Date
    birthDate = new Date(dateString)
    age = today.getFullYear() - birthDate.getFullYear()
    m = today.getMonth() - birthDate.getMonth()
    if m < 0 or m == 0 and today.getDate() < birthDate.getDate()
      age--
    age

  _toggleAnswer = ->
    answers = $('.answer')
    for answer in answers
      answerObj = $(answer)
      if answerObj.data('is-stage') == false
        answerObj.find('input').removeAttr('disabled')
        answerObj.show()
      else
        if answerObj.data('to-age') != '' && answerObj.data('from-age') >= $('#client_date_of_birth').val() >= answerObj.data('to-age')
          answerObj.find('input').removeAttr('disabled')
          answerObj.show()
          answerObj.removeClass('disable-qa')
        else
          answerObj.addClass('disable-qa')
          answerObj.find('input').attr('disabled', true)
          answerObj.hide()

  window.onload = ->
    ua = navigator.userAgent
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|Mobile|mobile|CriOS/i.test(ua)
      $('#stage-question .dataTables_scrollBody')
      $('#stage-question.table-responsive')
    else
      $('#stage-question .dataTables_scrollBody').niceScroll
        scrollspeed: 30
        cursorwidth: 10
        cursoropacitymax: 0.4
        autohidemode: false
      $('#stage-question.table-responsive').niceScroll
        scrollspeed: 30
        cursorwidth: 10
        cursoropacitymax: 0.2

  { init: _init }
