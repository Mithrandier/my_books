Vue.component 'selected-editions',
  template: '#selected_editions_template'

  data: ->
    updates:
      read: null
      category: {}
      publisher: {}
      series: {}
    errors: {}

  computed: Vuex.mapState
    editionIds: 'selectedEditionIds'
    selectionMode: 'selectionMode'

    publisherNames: ->
      @$store.getters.publisherNames

    seriesTitles: ->
      _.map @$store.state.allSeries, 'title'

  methods:
    toggleSelectionMode: ->
      if @selectionMode
        @$store.commit('stopSelectingEditions')
      else
        @$store.commit('startSelectingEditions')

    updateBatchReadStatus: (status) ->
      @sendUpdates(read: status)

    clearSelection: ->
      @$store.commit('clearSelectedEditions')

    selectFilteredEditions: ->
      @$store.commit('selectFilteredEditions')

    deselectFilteredEditions: ->
      @$store.commit('deselectFilteredEditions')

    clearErrors: ->
      $('[data-selected-editions-updates-error]').hide()

    submitUpdates: ->
      @clearErrors()
      @sendUpdates(@updates)

    sendUpdates: (updates) ->
      $.ajax(
        type: 'PUT'
        url: Routes.editions_batch_path()
        dataType: 'json'
        data: { edition_ids: @editionIds, editions_batch: updates }
        success: (response) =>
          EventsDispatcher.$emit('editionUpdated')
        error: (response) =>
          @errors = response.responseJSON
      )
