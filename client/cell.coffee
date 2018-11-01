Template.cell_boolean.events
    'click #turn_on': ->
        cell_object = Template.parentData(3)
        Docs.update @_id,
            { $set: "#{cell_object.key}": true }

    'click #turn_off': ->
        cell_object = Template.parentData(3)
        Docs.update @_id,
            { $set: "#{cell_object.key}": false }

Template.cell_boolean.helpers
    is_true: ->
        cell_object = Template.parentData(3)
        @["#{cell_object.key}"]





Template.cell_text_edit.onCreated ->
    @editing_mode = new ReactiveVar false

Template.cell_text_edit.helpers
    editing_cell: -> Template.instance().editing_mode.get()


Template.cell_text_edit.events
    'click .edit_field': (e,t)-> t.editing_mode.set true
    'click .save_field': (e,t)-> t.editing_mode.set false

    'change .cell_val': (e,t)->
        cell_object = Template.parentData(3)

        text_value = e.currentTarget.value
        Docs.update @_id,
            { $set: "#{cell_object.key}": text_value }



Template.cell_date.events
    'blur #date_field': (e,t)->
        date_value = e.currentTarget.value
        cell_object = Template.parentData(3)

        Docs.update @_id,
            { $set: "#{cell_object.key}": date_value }



Template.cell_number.events
    'change #number_field': (e,t)->
        number_value = parseInt e.currentTarget.value
        cell_object = Template.parentData(3)
        Docs.update @_id,
            { $set: "#{cell_object.key}": number_value }