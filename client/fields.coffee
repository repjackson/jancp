Template.boolean_edit.events
    'click .toggle_block': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        bool_value = target_doc["#{@key}"]
        # console.log t.data
        # console.log @

        if bool_value and bool_value is true
            Docs.update target_doc._id,
                $set: "#{t.data.key}": false
        else
            Docs.update target_doc._id,
                $set: "#{t.data.key}": true

Template.string_edit.events
    'blur .string_val': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id

        val = t.$('.string_val').val()
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

    'click .slugify': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        val = t.$('.string_val').val()
        Meteor.call 'slugify', target_doc.title, (err,res)->
            if err then console.log err
            else
                Docs.update target_doc._id,
                    $set:
                        slug: res


Template.number_edit.events
    'blur .number_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id

        val = parseInt e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val



Template.date_edit.events
    'blur .date_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val



Template.textarea_edit.events
    'blur .textarea_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set: "#{t.data.key}": val


Template.array_edit.helpers
    items: ->
        parent = Template.parentData(5)
        parent["#{@key}"]



Template.array_edit.events
    'click .edit': (e,t)-> t.editing.set !t.editing.get()

    'keyup .add_array_element': (e,t)->
        if e.which is 13
            delta = Docs.findOne type:'delta'
            target_doc = Template.parentData(5)
            val = e.currentTarget.value.toLowerCase()
            Docs.update target_doc._id,
                $addToSet:
                    "#{@key}": val
            t.$('.add_array_element').val('')

    'click .pull_element': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        target = Template.parentData(5)

        array_block = Template.parentData(4)

        Docs.update target._id,
            $pull:
                "#{array_block.key}": @valueOf()





Template.block_edit.helpers
    can_edit: -> @editable

    edit_template: ->
        if @primitive
            "#{@primitive}_edit"
        else
            "string_edit"

Template.boolean_edit.helpers
    bool_switch_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        bool_value = target_doc?["#{@key}"]
        if bool_value and bool_value is true then 'active blue' else ''

Template.string_edit.helpers
    is_slug: ->
        @key is 'slug'


    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.doc_id
        # console.log 'target doc', editing_doc
        value = editing_doc?["#{@key}"]



Template.date_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.doc_id
        # console.log 'target doc', editing_doc
        value = editing_doc?["#{@key}"]

Template.block_view.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.doc_id
        # console.log 'target doc', editing_doc
        value = editing_doc?["#{@key}"]



Template.number_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.doc_id
        # console.log 'target doc', editing_doc
        value = editing_doc?["#{@key}"]

Template.textarea_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.doc_id
        # console.log 'target doc', editing_doc
        value = editing_doc?["#{@key}"]









Template.multiref_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.referenced_schema
Template.ref_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.referenced_schema

Template.multiref_edit.helpers
    choices: ->
        Docs.find {type:@referenced_schema},
            {sort:
                title:1
                rank:1
            }

    value: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        target_doc["#{@slug}"]

    element_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        block_slug = Template.parentData().slug
        current_value = @slug

        if parent and target_doc and current_value
            if target_doc["#{block_slug}"]
                if current_value in target_doc["#{block_slug}"] then 'active blue' else ''


Template.multiref_edit.events
    'click .toggle_element': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        block_slug = Template.currentData().slug
        selected_value = @slug

        if target_doc and selected_value
            if target_doc["#{block_slug}"]
                if selected_value in target_doc["#{block_slug}"]
                    Docs.update target_doc._id,
                        $pull:"#{block_slug}": selected_value
                else
                    Docs.update target_doc._id,
                        $addToSet:"#{block_slug}": selected_value
            else
                Docs.update target_doc._id,
                    $addToSet:"#{block_slug}": selected_value




Template.ref_edit.events
    'click .choose_element': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        slug = Template.currentData().slug

        Docs.update target_doc._id,
            $set:"#{slug}": @slug

Template.ref_edit.helpers
    choices: ->
        Docs.find
            type:@referenced_schema

    element_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.doc_id
        parent = Template.parentData()

        if target_doc?["#{parent.slug}"] is @slug then 'active blue' else ''






Template.header.onCreated ->
    @editing = new ReactiveVar false
Template.textarea.onCreated ->
    @editing = new ReactiveVar false

Template.header.events
    'click .edit': (e,t)-> t.editing.set !t.editing.get()

    'blur .string_val': (e,t)->
        text_value = e.currentTarget.value
        # console.log @filter_id
        Docs.update @_id,
            { $set: title: text_value }

Template.textarea.events
    'click .edit': (e,t)-> t.editing.set !t.editing.get()

    'blur .text_val': (e,t)->
        text_value = e.currentTarget.value

        Docs.update @_id,
            { $set: text: text_value }



Template.edit_block_number.helpers
    block_value: ->
        field = Template.parentData()
        field["#{@key}"]


Template.edit_block_number.events
    'change .number_val': (e,t)->
        number_value = parseInt e.currentTarget.value
        # console.log @filter_id
        Docs.update @filter_id,
            { $set: "#{@key}": number_value }

Template.edit_block_text.helpers
    block_value: ->
        field = Template.parentData()
        field["#{@key}"]


Template.edit_block_text.events
    'change .text_val': (e,t)->
        text_value = e.currentTarget.value
        # console.log @filter_id
        Docs.update @filter_id,
            { $set: "#{@key}": text_value }






