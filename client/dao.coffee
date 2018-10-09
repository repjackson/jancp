Template.dao.onCreated ->
    @autorun -> Meteor.subscribe 'my_facets', FlowRouter.getParam('page_slug')
    @autorun => Meteor.subscribe 'filters', FlowRouter.getQueryParam('doc_id')
    @autorun => Meteor.subscribe 'type', 'ticket_type'
    @is_editing = new ReactiveVar false
    Session.setDefault 'view_mode', 'cards'


Template.facet_card.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data
Template.facet_segment.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data
Template.dao_table_row.onCreated ->
    @autorun => Meteor.subscribe 'doc', @data
Template.facet_card.helpers
    local_doc: -> Docs.findOne @valueOf()
Template.facet_segment.helpers
    local_doc: -> Docs.findOne @valueOf()
Template.dao_table_row.helpers
    local_doc: -> Docs.findOne @valueOf()



Template.dao.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion();
    , 500
    Meteor.setTimeout ->
        $('.dropdown').dropdown()
    , 700


Template.dao.events
    'click .create_facet': (e,t)->
        page_slug = FlowRouter.getParam('page_slug')
        page = Docs.findOne
            type:'page'
            slug:page_slug

        if page.qp_office_jpid then console.log FlowRouter.getQueryParam('office_jpid')
        new_facet_ob = {
            author_id: Meteor.userId()
            timestamp: Date.now()
            parent_slug: page_slug
        }
        if page.qp_office_jpid
            if Meteor.user().office_jpid
                args = [
                    key:'office_jpid'
                    value:Meteor.user().office_jpid
                    ]
                new_facet_ob['args'] = args
        new_facet_id =
            Facets.insert new_facet_ob
        FlowRouter.go("/d/#{page_slug}?doc_id=#{new_facet_id}")
        Meteor.call 'fum', new_facet_id

    'click #add_filter': (e,t)->
        Docs.insert
            type:'filter'
            parent_slug: FlowRouter.getParam('page_slug')

    'click .remove_arg': (e,t)->
        Docs.update FlowRouter.getQueryParam('doc_id'),
            $pull:args:@

    'click .call':(e,t)->
        Meteor.call 'fum', FlowRouter.getQueryParam('doc_id')

    'click .clear_results': ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        Facets.update facet._id,
            $set: results: []

    'keyup .arg_key, keyup .arg_value': (e,t)->
        e.preventDefault()
        if e.which is 13 #enter
            facet_id = FlowRouter.getQueryParam('doc_id')
            arg_key_val = $('.arg_key').val().trim()
            arg_val_val = $('.arg_value').val().trim()
            arg = {
                key:arg_key_val
                value:arg_val_val
            }
            Meteor.call 'fa', arg, facet_id
            $('.arg_key').val('')
            $('.arg_value').val('')

    'click .start_editing': (e,t)-> t.is_editing.set true
    'click .stop_editing': (e,t)->
        e.preventDefault()
        facet_id = FlowRouter.getQueryParam('doc_id')
        title_val = $('.facet_title').val().trim()
        Facets.update facet_id,
            $set:title:title_val
        t.is_editing.set false


    'keyup .facet_title': (e,t)->
        e.preventDefault()
        if e.which is 13 #enter
            facet_id = FlowRouter.getQueryParam('doc_id')
            title_val = $('.facet_title').val().trim()
            Facets.update facet_id,
                $set:title:title_val
            t.is_editing.set false

    'click .set_view_cards': -> Session.set 'view_mode', 'cards'
    'click .set_view_segments': -> Session.set 'view_mode', 'segments'
    'click .set_view_table': -> Session.set 'view_mode', 'table'


Template.set_page_size.events
    'click .set_page_size': (e,t)->
        facet_id = FlowRouter.getQueryParam('doc_id')
        Facets.update facet_id,
            $set:page_size:@value
        Meteor.call 'fum', facet_id


Template.facet_table.helpers
    facet_doc: ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')

Template.selector.helpers
    selector_value: ->
        switch typeof @value
            when 'string' then @value
            when 'boolean'
                if @value is true then 'Open'
                else if @value is false then 'Closed'
            when 'number' then @value
Template.dao.helpers
    facet_doc: ->
        Facets.findOne FlowRouter.getQueryParam('doc_id')
    my_facets: ->
        Facets.find
            author_id:Meteor.userId()


    current_page_slug: -> FlowRouter.getParam('page_slug')


    ticket_types: ->
        Docs.find
            type:'ticket_type'

    view_segments: -> Session.equals 'view_mode', 'segments'
    view_cards: -> Session.equals 'view_mode', 'cards'
    view_table: -> Session.equals 'view_mode', 'table'

    view_cards_class: -> if Session.equals 'view_mode', 'cards' then 'primary' else ''
    view_segments_class: -> if Session.equals 'view_mode', 'segments' then 'primary' else ''
    view_table_class: -> if Session.equals 'view_mode', 'table' then 'primary' else ''

    results: ->
        # facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        # Docs.find
        #     _id:$in:facet.result_ids
        Results.find()

    filters: ->
        Docs.find
            type:'filter'
            parent_slug: FlowRouter.getParam('page_slug')
            # facet_id: FlowRouter.getQueryParam('doc_id')

    is_editing: -> Template.instance().is_editing.get()



Template.set_facet_key.helpers
    set_facet_key_class: ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        if facet.query["#{@key}"] is @value then 'primary' else ''

Template.set_facet_key.events
    'click .set_facet_key': ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')

        query_key = "query.#{@key}"
        Facets.update facet._id,
            $set:"#{query_key}":@value
        Meteor.call 'fo', FlowRouter.getQueryParam('doc_id')





Template.filter.helpers
    values: ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        facet["#{@key}"][..7]

    set_facet_key_class: ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        if facet.query["#{@key}"] is @value then 'primary' else ''

Template.selector.helpers
    toggle_value_class: ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        filter = Template.parentData()
        filter_list = facet["filter_#{filter.key}"]
        if filter_list and @value in filter_list then 'primary' else ''

Template.filter.events
    # 'click .set_facet_key': ->
    #     facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
    'click .recalc': ->
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        Meteor.call 'fum', facet._id, @key

Template.selector.events
    'click .toggle_value': ->
        # console.log @
        filter = Template.parentData()
        facet = Facets.findOne FlowRouter.getQueryParam('doc_id')
        filter_list = facet["filter_#{filter.key}"]

        if filter_list and @value in filter_list
            Facets.update facet._id,
                $pull: "filter_#{filter.key}": @value
        else
            Facets.update facet._id,
                $addToSet: "filter_#{filter.key}": @value

        Meteor.call 'fum', facet._id, filter.key


Template.edit_filter_field.events
    'change .text_val': (e,t)->
        text_value = e.currentTarget.value
        # console.log @filter_id
        Docs.update @filter_id,
            { $set: "#{@key}": text_value }