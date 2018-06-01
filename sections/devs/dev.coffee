
FlowRouter.route '/dev', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        sub_nav: 'dev_nav'
        main: 'dev'
 
 
 
if Meteor.isClient
    Template.user_table.onCreated ->
        @autorun ->  Meteor.subscribe 'users'
    
    
    Template.user_table.helpers
        users: -> Meteor.users.find {}
    
    Template.dev.events
    
    Template.dev_nav.onRendered ->
        # Meteor.setTimeout ->
        #     $('.item').popup()
        # , 400
        