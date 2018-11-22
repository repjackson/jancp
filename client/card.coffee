Template.delta_card.onCreated ->
    delta = Docs.findOne type:'delta'
    @autorun => Meteor.subscribe 'schema_fields'
    @autorun => Meteor.subscribe 'doc', delta.detail_id

Template.delta_card.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion();
    , 500
    Meteor.setTimeout ->
        $('.ui.button').popup()
    , 1000



Template.delta_card.events
    'click .remove_doc': ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        if confirm "Delete #{target_doc.title}?"
            Docs.remove target_doc._id
            Docs.update delta._id,
                $set:
                    detail_id:null
                    editing:false
                    viewing_detail:false
        Session.set 'is_calculating', true
        Meteor.call 'fo', (err,res)->
            if err then console.log err
            else
                Session.set 'is_calculating', false


    'click .enable_editing': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:editing:true

    'click .disable_editing': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:editing:false


Template.delta_card.helpers
    detail_doc: ->
        delta = Docs.findOne type:'delta'
        Docs.findOne delta.detail_id

    delta_doc: -> Docs.findOne type:'delta'


    current_type: ->
        delta = Docs.findOne type:'delta'
        type_key = delta.filter_type[0]
        Docs.findOne
            type:'schema'
            slug:type_key


    can_edit: ->
        delta = Docs.findOne type:'delta'
        type_key = delta.filter_type[0]
        schema = Docs.findOne
            type:'schema'
            slug:type_key
        my_role = Meteor.user()?.roles?[0]

        if my_role
            if 'dev' in Meteor.user().roles
                true
            else
                if schema.edit_roles
                    if my_role in schema.edit_roles
                        true
                    else
                        false
                else
                    false


    fields: ->
        delta = Docs.findOne type:'delta'
        detail_doc = Docs.findOne delta.detail_id
        if detail_doc?.type is 'field'
            Docs.find({
                type:'field'
                schema_slugs: $in: ['field']
            }, {sort:{rank:1}}).fetch()
        else if detail_doc?.type is 'part'
            Docs.find({
                type:'field'
                schema_slugs: $in: ['part']
            }, {sort:{rank:1}}).fetch()
        else
            current_type = delta.filter_type[0]
            Docs.find({
                type:'field'
                view_roles: $in: Meteor.user().roles
                schema_slugs: $in: [current_type]
            }, {sort:{rank:1}}).fetch()

    edit_fields: ->
        delta = Docs.findOne type:'delta'
        detail_doc = Docs.findOne delta.detail_id
        if detail_doc?.type is 'field'
            Docs.find({
                type:'field'
                schema_slugs: $in: ['field']
            }, {sort:{rank:1}}).fetch()
        else if detail_doc?.type is 'part'
            Docs.find({
                type:'field'
                schema_slugs: $in: ['part']
            }, {sort:{rank:1}}).fetch()
        else
            current_type = delta.filter_type[0]
            if 'dev' in Meteor.user().roles
                Docs.find({
                    type:'field'
                    schema_slugs: $in: [current_type]
                }, {sort:{rank:1}}).fetch()
            else
                Docs.find({
                    type:'field'
                    # edit_roles: $in: Meteor.user().roles
                    schema_slugs: $in: [current_type]
                }, {sort:{rank:1}}).fetch()


    child_schema_fields: ->
        console.log @



Template.delta_card.helpers
    card_template: ->
        doc = Docs.findOne @valueOf()
        if doc and doc.type
            if doc.type is 'task' then 'task_card' else 'delta_card'

    delta_card_class: ->
        delta = Docs.findOne type:'delta'
        if delta.viewing_detail then 'fluid blue raised' else ''
        # if delta.view_mode is 'grid'
        #     'six wide column'
        # else
        #     'sixteen wide column'

    local_doc: ->
        if @data
            Docs.findOne @data.valueOf()
        else
            Docs.findOne @valueOf()


    field_docs: ->
        delta = Docs.findOne type:'delta'
        local_doc =
            if @data
                Docs.findOne @data.valueOf()
            else
                Docs.findOne @valueOf()
        if local_doc?.type is 'field'
            Docs.find({
                type:'field'
                schema_slugs: $in: ['field']
            }, {sort:{rank:1}}).fetch()
        else
            schema = Docs.findOne
                type:'schema'
                slug:delta.filter_type[0]
            Docs.find({
                type:'field'
                schema_slugs: $in: [schema.slug]
                view_roles: $in: Meteor.user().roles
            }, {sort:{rank:1}}).fetch()

    # actions: ->
    #     delta = Docs.findOne type:'delta'
    #     local_doc =
    #         if @data
    #             Docs.findOne @data.valueOf()
    #         else
    #             Docs.findOne @valueOf()
    #     if local_doc?.type is 'field'
    #         Docs.find({
    #             type:'part'
    #             schema_slugs: $in: ['field']
    #         }, {sort:{rank:1}}).fetch()
    #     else
    #         schema = Docs.findOne
    #             type:'schema'
    #             slug:delta.filter_type[0]
    #         Docs.find({
    #             type:'part'
    #             visible:true
    #             schema_slugs: $in: [schema.slug]
    #         }, {sort:{rank:1}}).fetch()


    value: ->
        delta = Docs.findOne type:'delta'
        schema = Docs.findOne
            type:'schema'
            slug:delta.filter_type[0]
        parent = Template.parentData()
        field_doc = Docs.findOne
            type:'field'
            schema_slugs:$in:[schema.slug]
        parent["#{@key}"]


    doc_header_fields: ->
        delta = Docs.findOne type:'delta'
        local_doc =
            if @data
                Docs.findOne @data.valueOf()
            else
                Docs.findOne @valueOf()
        if local_doc?.type is 'field'
            Docs.find({
                type:'field'
                # axon:$ne:true
                header:true
                schema_slugs: $in: ['field']
            }, {sort:{rank:1}}).fetch()
        else if detail_doc?.type is 'part'
            Docs.find({
                type:'field'
                header:true
                schema_slugs: $in: ['part']
            }, {sort:{rank:1}}).fetch()
        else
            schema = Docs.findOne
                type:'schema'
                slug:delta.filter_type[0]
            linked_fields = Docs.find({
                type:'field'
                schema_slugs: $in: [schema.slug]
                header:true
                # axon:$ne:true
            }, {sort:{rank:1}}).fetch()
