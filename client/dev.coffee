FlowRouter.route '/dev', action: ->
    BlazeLayout.render 'layout', 
        main: 'dev'
        
FlowRouter.route '/p/:page_slug', action: ->
    BlazeLayout.render 'layout', 
        main: 'page'
        
Template.dev.onCreated ->
    @autorun => Meteor.subscribe 'events_by_type', 'sms'
    @autorun => Meteor.subscribe 'type', 'page'

Template.dev.helpers
    events: -> Docs.find type:'event'
    pages: -> Docs.find type:'page'

Template.page_view.onCreated ->
    # location.reload() 
    @autorun => Meteor.subscribe 'blocks', FlowRouter.getParam('doc_id')

    
Template.page.onCreated ->
    @autorun => Meteor.subscribe 'page_by_slug', FlowRouter.getParam('page_slug')
    @autorun => Meteor.subscribe 'blocks_by_page_slug', FlowRouter.getParam('page_slug')

    
    
Template.page_view.helpers
    page_doc: -> 
        FlowRouter.watchPathChange();
        currentContext = FlowRouter.current();
        # console.log currentContext
        Docs.findOne currentContext.params.doc_id
    
    
Template.page.helpers
    page_doc: -> 
        FlowRouter.watchPathChange();
        currentContext = FlowRouter.current();
        console.log currentContext
        Docs.findOne
            type:'page'
            slug: FlowRouter.getParam('page_slug')
    
    
Template.dev.events
    'click #send_email': (e,t)->
        recipient = $('#recipient_email').val()
        message = $('#email_body').val()
        Meteor.call 'sendEmail', recipient, 'repjackson@gmail.com', 'test dev portal message', message, (err,res)->
            if err then console.log err
            else
                console.res
    
    'click #send_sms': (e,t)->
        recipient = $('#recipient_number').val()
        message = $('#sms_message').val()
        
        Meteor.call 'send_sms', recipient, message, (err,res)->
            if err then console.log err
            else
                console.res
    
    
Template.page_view.events
    # 'click #add_row': ->
    #     current_page = Docs.findOne FlowRouter.getParam('doc_id')
    #     next_row_number = current_page.rows.length+1
    #     Docs.update FlowRouter.getParam('doc_id'),
    #         $addToSet:
    #             rows: { 
    #                 number:next_row_number
    #             }
    # 'click .add_column': ->
    #     console.log @
    #     current_page = Docs.findOne FlowRouter.getParam('doc_id')
    #     Meteor.call 'add_column', FlowRouter.getParam('doc_id'), @, 'row_class', row_class_value
        
        
            
    # 'click .remove_row': ->
    #     Docs.update FlowRouter.getParam('doc_id'),
    #         $pull: rows: @
        
    # 'blur .row_class': (e,t)->
    #     row_class_value = e.currentTarget.value
    #     console.log row_class_value
    #     Meteor.call 'update_row_key', FlowRouter.getParam('doc_id'), @, 'row_class', row_class_value
