Template.boolean_edit.events
    'click .toggle_field': ->
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id
        bool_value = target_doc["#{@key}"]

        if bool_value and bool_value is true
            Docs.update target_doc._id,
                $set: "#{@key}": false
        else
            Docs.update target_doc._id,
                $set: "#{@key}": true

Template.string_edit.events
    'blur .text_field_val': (e,t)->
        # console.log Template.parentData()
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{@key}": val

Template.array_edit.events
    'keyup .add_array_element': (e,t)->
        if e.which is 13
            facet = Docs.findOne type:'facet'
            target_doc = Docs.findOne _id:facet.detail_id

            val = e.currentTarget.value
            Docs.update target_doc._id,
                $addToSet:
                    "#{@key}": val
            t.$('.add_array_element').val('')

    'click .pull_element': (e,t)->
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id
        field_doc = Template.currentData()

        Docs.update target_doc._id,
            $pull:
                "#{field_doc.key}": @valueOf()





Template.field_edit.helpers
    can_edit: -> @editable

    edit_template: -> "#{@field_type}_edit"

Template.boolean_edit.helpers
    bool_switch_class: ->
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id
        bool_value = target_doc["#{@key}"]
        if bool_value and bool_value is true
            'primary'
        else
            ''

Template.string_edit.helpers
    value: ->
        facet = Docs.findOne type:'facet'
        editing_doc = Docs.findOne _id:facet.detail_id
        # console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]


Template.array_edit.helpers
    value: ->
        facet = Docs.findOne type:'facet'
        target_doc = Docs.findOne _id:facet.detail_id
        target_doc["#{@key}"]
