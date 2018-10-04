@selected_customers = new ReactiveArray []


Template.customer_facet.helpers
    customers: ->
        doc_count = Docs.find().count()
        # if selected_tags.array().length
        if 0 < doc_count < 3
            Customers.find {
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit:42
        else
            cursor = Customers.find({}, limit:42)
            # console.log cursor.fetch()
            return cursor

    customer_class: ->
        button_class = []
        # console.log @index
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push 'small'
            when @index <= 15 then button_class.push 'tiny '
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_customers: -> selected_customers.array()



Template.customer_facet.events
    'click .select_customer': -> selected_customers.push @name
    'click .unselect_customer': -> selected_customers.remove @valueOf()
    'click #clear_customers': -> selected_customers.clear()