FlowRouter.route '/databank', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'admin_nav'
        main: 'databank'


Template.databank.onCreated ->
    # @autorun => Meteor.subscribe 'type', 'item'
    @autorun => Meteor.subscribe 'count', 'item'
    @autorun => Meteor.subscribe 'incomplete_item_count'
    @autorun => Meteor.subscribe 'oasis', 
        selected_tags.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_timestamp_tags.array()
        type=Session.get('selected_doc_type')
        author_id=null
        
        
Template.databank.onRendered ->
    # $('.indicating.progress').progress();
    

Template.databank.helpers
    databank_docs: ->  Docs.find { type:Session.get('selected_doc_type')}
    databank_view: -> 
        array = selected_doc_types.array()
        return "databank_#{array[0]}"
    single_view: -> 
        array = selected_doc_types.array()
        return "#{array[0]}_single"

    current_doc_type: -> 
        array = selected_doc_types.array()
        return array[0]
