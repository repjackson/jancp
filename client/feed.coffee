

Template.global_feed.onCreated ->
    @autorun => Meteor.subscribe 'type', 'event', 20

Template.global_feed.helpers
    feed_events: ->
        context = Template.currentData()
        # Docs.find {type:'event', doc_type:context.doc_type}, sort:timestamp:-1
        Docs.find {type:'event'}, sort:timestamp:-1


Template.global_feed.events
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




Template.event.onCreated ->
    @autorun =>  Meteor.subscribe 'user_profile', @data.author_id
    @autorun =>  Meteor.subscribe 'doc', @data.parent_id



Template.event.events
    'click .remove_event': ->
        Docs.remove @_id

Template.event.helpers
    is_escalation: -> @event_type is 'escalate'