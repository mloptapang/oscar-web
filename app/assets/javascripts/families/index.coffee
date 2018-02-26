CIF.FamiliesIndex = do ->
  _init = ->
    _fixedHeaderTableColumns()
    _handleScrollTable()
    _getFamilyPath()
    _initSelect2()
    # ----------------------------------------------------------------------------
    _handleAutoCollapse()
    _toggleCollapseFilter()
    _checkFamilySearchForm()
    _columnsVisibility()
    _setDefaultCheckColumnVisibilityAll()
    _handleColumnVisibilityParams()
    _handleUncheckColumnVisibility()
    _initAdavanceSearchFilter()

  _initAdavanceSearchFilter = ->
    advanceFilter = new CIF.ClientAdvanceSearch()
    advanceFilter.initBuilderFilter('#family-builder-fields')
    advanceFilter.setValueToBuilderSelected()
    advanceFilter.getTranslation()

    advanceFilter.handleShowCustomFormSelect()
    advanceFilter.customFormSelectChange()
    advanceFilter.customFormSelectRemove()
    advanceFilter.handleHideCustomFormSelect()

    # advanceFilter.handleShowProgramStreamFilter()
    # advanceFilter.handleHideProgramStreamSelect()
    # advanceFilter.handleProgramSelectChange()
    # advanceFilter.triggerEnrollmentFields()
    # advanceFilter.triggerTrackingFields()
    # advanceFilter.triggerExitProgramFields()

    advanceFilter.handleSelect2RemoveProgram()
    # advanceFilter.handleUncheckedEnrollment()
    # advanceFilter.handleUncheckedTracking()
    # advanceFilter.handleUncheckedExitProgram()

    # advanceFilter.handleAddQuantitativeFilter()
    # advanceFilter.handleRemoveQuantitativFilter()

    advanceFilter.handleSearch()
    advanceFilter.addRuleCallback()
    advanceFilter.filterSelectChange()
    advanceFilter.filterSelecting()
    # advanceFilter.preventDomainScore()
    # advanceFilter.disableOptionDomainScores()

    advanceFilter.handleSaveQuery()
    advanceFilter.validateSaveQuery()


  _handleUncheckColumnVisibility = ->
    params = window.location.search.substr(1)

    if params.includes('family_advanced_search')
      allCheckboxes = $('#family-search-form').find('#new_family_grid ul input.i-checks')
      $(allCheckboxes).iCheck('uncheck')
    else
      allCheckboxes = $('#family-advance-search-form').find('#new_family_grid ul input.i-checks')
      $(allCheckboxes).iCheck('uncheck')

  _handleColumnVisibilityParams = ->
    $('button#search').on 'click', ->
      allCheckboxes = $('#family-search-form').find('#new_family_grid ul input[type=checkbox]')
      $(allCheckboxes).attr('disabled', true)

    $('input.datagrid-submit').on 'click', ->
      allCheckboxes = $('#family-advance-search-form').find('#new_family_grid ul input[type=checkbox]')
      $(allCheckboxes).attr('disabled', true)

  _setDefaultCheckColumnVisibilityAll = ->
    $('.check-columns-visibility').find('a.dropdown-toggle').on 'click', ->
      parents = $(@).parent().find('.columns-visibility')
      if $(parents).find('.visibility .checked').length == 0
        $(parents).find('.all-visibility #all_').iCheck('check')

  _columnsVisibility = ->
    $('.columns-visibility').click (e) ->
      e.stopPropagation()

    allCheckboxes = $('.all-visibility #all_')

    for checkBox in allCheckboxes
      $(checkBox).on 'ifChecked', ->
        $(@).parents('.columns-visibility').find('.visibility input[type=checkbox]').iCheck('check')
      $(checkBox).on 'ifUnchecked', ->
        $(@).parents('.columns-visibility').find('.visibility input[type=checkbox]').iCheck('uncheck')

  _handleAutoCollapse = ->
    params = window.location.search.substr(1)

    if params.includes('family_advanced_search')
      $("button[data-target='#family-advance-search-form']").trigger('click')
    else
      $("button[data-target='#family-search-form']").trigger('click')

  _toggleCollapseFilter = ->
    $('#family-search-form').on 'show.bs.collapse', ->
      $('#family-advance-search-form').collapse('hide')

    $('#family-advance-search-form').on 'show.bs.collapse', ->
      $('#family-search-form').collapse('hide')

  _checkFamilySearchForm = ->
    $("button.query").on 'click', ->
      form = $(@).attr('class')
      if form.includes('family-advance-search')
        $('#filter_form').hide()
      else
        $('#filter_form').show()
  # ------------------------------------------------------------------------------------------------------
  _initSelect2 = ->
    $('select').select2
      allowClear: true

  _fixedHeaderTableColumns = ->
    $('.families-table').removeClass('table-responsive')
    if !$('table.families tbody tr td').hasClass('noresults')
      $('table.families').dataTable(
        'sScrollX': '100%'
        'bPaginate': false
        'bFilter': false
        'bInfo': false
        'bSort': false
        'sScrollY': 'auto'
        'bAutoWidth': true)
    else
      $('.families-table').addClass('table-responsive')

  _handleScrollTable = ->
    $(window).load ->
      ua = navigator.userAgent
      unless /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini|Mobile|mobile|CriOS/i.test(ua)
        $('.families-table .dataTables_scrollBody').niceScroll
          scrollspeed: 30
          cursorwidth: 10
          cursoropacitymax: 0.4

  _getFamilyPath = ->
    return if $('table.families tbody tr').text().trim() == 'No results found' || $('table.families tbody tr').text().trim() == 'មិនមានលទ្ធផល'
    $('table.families tbody tr').click (e) ->
      return if $(e.target).hasClass('btn') || $(e.target).hasClass('fa') || $(e.target).hasClass('case-history')
      window.location = $(this).data('href')

  { init: _init }
