FlowRouter.route '/user/add', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'add_user'
Template.add_user.onCreated ->
    # @autorun ->  Meteor.subscribe 'users'


Template.add_user.helpers
    # users: -> Meteor.users.find {}
    unassigned_roles: ->
        role_list = [
            'admin'
            'desk'
            'staff'
            'resident'
            'owner'
            'board'
            ]
        _.difference role_list, @roles
        


Template.add_user.events
    'click #add_person': ->
        username = $('#username').val().trim()
        first_name = $('#first_name').val().trim()
        last_name = $('#last_name').val().trim()
        email = $('#email').val().trim()
        Meteor.call 'create_user', username, first_name, last_name, email, (err,new_id)->
            # console.log new_id
            FlowRouter.go "/user/#{username}"
        