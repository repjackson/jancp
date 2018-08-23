FlowRouter.route '/feed', 
    action: ->
        BlazeLayout.render 'layout', 
            main: 'global_feed'

Template.global_feed.onCreated ->
Template.global_feed.helpers
    # feed_events: -> Docs.find {type:'event'}, sort:timestamp:-1
    # settings: ->
    #     collection: 'events'
    #     rowsPerPage: 10
    #     showFilter: true
    #     showRowCount: true
    #     # showColumnToggles: true
    #     fields: [
    #         { key: 'author_id', label: 'Author', tmpl:Template.author_info }
    #         { key: 'text', label: 'Text' }
    #         { key: 'action', label: 'Action' }
    #         # { key: 'parent_id', label: 'Parent Link', tmpl:Template.parent_link }
    #         { key: 'timestamp', label: 'Logged', tmpl:Template.when_template }
    #         { key: 'timestamp_tags', label: 'Time Tags' }
    #         { key: '', label: 'Mark Read', tmpl:Template.mark_read_link }
    #         { key: '', label: 'View', tmpl:Template.view_button }
    #     ]


# Template.feed_event.onCreated ->
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
# Template.feed_event.events
#     'click .remove_event': -> 
#         if confirm 'Delete Event?'
#             Docs.remove @_id

            
Template.users_feed.onCreated ->
    @autorun => Meteor.subscribe 'users_feed', FlowRouter.getParam('username')

Template.users_feed.helpers
    user_feed_events: -> 
        Docs.find {type:'event'}, sort:timestamp:-1
Template.users_feed_event.events
    'click .remove_event': -> 
        if confirm 'Delete User Event?'
            Docs.remove @_id

            
Template.feed.onCreated ->
    @autorun => Meteor.subscribe 'events', @data.doc_type

Template.feed.helpers
    event_docs: -> 
        context = Template.currentData()
        Docs.find {type:'event', doc_type:context.doc_type}, sort:timestamp:-1
Template.feed.events
    'click .remove_event': -> 
        if confirm 'Delete Event?'
            Docs.remove @_id


Template.office_feed.onCreated ->
    @autorun => Meteor.subscribe 'office_events', FlowRouter.getParam('doc_id')

Template.office_feed.helpers
    event_docs: -> 
        context = Template.currentData()
        Docs.find {type:'event', doc_type:context.doc_type}, sort:timestamp:-1
Template.office_feed.events
    'click .remove_event': -> 
        if confirm 'Delete Event?'
            Docs.remove @_id

            
Template.small_doc_history.onCreated ->
    @autorun =>  Meteor.subscribe 'child_docs', @data._id, 1
Template.small_doc_history.helpers
    doc_history_events: ->
        cursor = 
            Docs.find {
                parent_id: Template.currentData()._id
                type:'event'
            }, 
                sort:timestamp:-1
                limit: 1
        
        
            
Template.full_doc_history.onCreated ->
    @autorun =>  Meteor.subscribe 'child_docs', @data._id


Template.doc_history_event.onCreated ->
    @autorun =>  Meteor.subscribe 'user_profile', @data.author_id
Template.full_doc_history.helpers
    doc_history_events: ->
        Docs.find {
            parent_id: Template.currentData()._id
            type:'event'
        }, sort:timestamp:-1
        
        
Template.doc_history_event.helpers
    event_icon_name: ->
        # console.log @event_type
        icon = ""
        if @event_type
            result = switch @event_type
                when 'escalate' then icon.concat 'positive-dynamic'
                when 'close' then icon.concat 'close-sign'
                when 'setting_default_escalation_time' then icon.concat 'sort-by-modified-date'
                when 'emailed_owner' then icon.concat 'user-shield'
                when 'emailed_secondary_contact' then icon.concat 'sent'
                when 'emailed_franchisee_contact' then icon.concat 'housekeeper-male'
                when 'submit' then icon.concat 'internal'
                when 'unsubmit' then icon.concat 'undo'
                when 'assignment' then icon.concat 'add-user-male'
                when 'unassignment' then icon.concat 'remove-user-female'
                when 'not-escalate' then icon.concat 'do-not-disturb'
                when 'level_change' then icon.concat 'positive-dynamic'
                else 'commit-git'
        else if @event_key 
            result = ' add-user-male'
            
    show_author: ->
        result = switch @event_type
            when 'escalate' then false
            when 'close' then true
            when 'setting_default_escalation_time' then false
            when 'emailed_owner' then false
            when 'emailed_secondary_contact' then false
            when 'emailed_franchisee_contact' then false
            when 'assignment' then false
            when 'unnassigment' then false
            when 'submit' then true
            when 'unsubmit' then true
            when 'not-escalate' then false
            when 'level_change' then true
            else false
            
        
# Template.full_doc_history.events
#     'click #clear_events':
#         doc_id = FlowRouter.getParam('doc_id')
#         if confirm 'Clear all events? Irriversible.'
#             Meteor.call 'clear_incident_events', doc_id
