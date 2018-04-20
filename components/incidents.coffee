if Meteor.isClient
    Template.incident_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    Template.incident_view.helpers
    
    Template.incident_type_label.helpers
        incident_type_label: ->
            switch @incident_type
                when 'missed_service' then 'Missed Service'
                when 'poor_service' then 'Poor Service'
                when 'employee_issue' then 'Employee Issue'
                when 'other' then 'Other'
        
        type_label_class: ->
            switch @incident_type
                when 'missed_service' then 'teal basic'
                when 'poor_service' then 'blue basic'
                when 'employee_issue' then 'violet basic'
                when 'other' then 'grey'
            
        
    FlowRouter.route '/incidents', action: ->
        BlazeLayout.render 'layout', main: 'incidents'
    
    
    @selected_incident_tags = new ReactiveArray []
    
    Template.incidents.onCreated ->
        @autorun -> Meteor.subscribe('docs',[],'incident')
    Template.incidents.helpers
        incidents: ->  Docs.find { type:'incident'}
    
    
    
    Template.incident_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.incident_edit.helpers
        incident: -> Doc.findOne FlowRouter.getParam('doc_id')
        
    Template.incident_edit.events
        'click #delete': ->
            template = Template.currentData()
            swal {
                title: 'Delete Incident?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, =>
                doc = Docs.findOne FlowRouter.getParam('doc_id')
                # console.log doc
                Docs.remove doc._id, ->
                    FlowRouter.go "/incidents"



if Meteor.isClient
    Template.my_incidents.onCreated -> @autorun -> Meteor.subscribe('my_incidents')
    
    Template.my_incidents.helpers
        my_incidents: -> 
            Incidents.find {},
                sort: publish_date: -1
                
if Meteor.isServer
    Meteor.publish 'my_incidents', ->
        Incidents.find author_id: @userId

