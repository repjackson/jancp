Template.table.onCreated ->
    Meteor.subscribe 'count', @data.type



Template.sort_column_header.helpers
    sort_descending: ->
        if Session.equals('sort_direction', '1') and Session.equals('sort_key', @key) 
            return true
    sort_ascending: ->
        if Session.equals('sort_direction', '-1') and Session.equals('sort_key', @key)
            return true
        
Template.table.helpers
    sort_descending: ->
        if Session.equals('sort_direction', '1') and Session.equals('sort_key', @key) 
            return true
    sort_ascending: ->
        if Session.equals('sort_direction', '-1') and Session.equals('sort_key', @key)
            return true
    fields: -> Template.currentData().fields
    table_docs: -> 
        Stats.find()
    values: ->
        fields = Template.parentData().fields
        values = []
        for field in fields
            values.push @["#{field.key}"]
        values
Template.table.events
    'click .set_page_number': -> 
        Session.set 'current_page_number', @number
        skip_amount = @number*parseInt(Session.get('page_size'))
        Session.set 'skip', skip_amount
    
    'change #page_size': (e,t)->
        Session.set 'page_size',$('#page_size').val()

    'click .set_10': ()-> Session.set 'page_size',10
    'click .set_20': ()-> Session.set 'page_size',20
    'click .set_50': ()-> Session.set 'page_size',50
    'click .set_100': ()-> Session.set 'page_size',100

    'click .sort_by': (e,t)->
        Session.set 'sort_key', @key
        if Session.equals 'sort_direction', '-1'
            Session.set 'sort_direction', '1'
        else if Session.equals 'sort_direction', '1'
            Session.set 'sort_direction', '-1'


Template.search_key.events
    'keyup .search_key': ->
        
        
Template.query_input.events
    'keyup #query': (e,t)->
        e.preventDefault()
        query = $('#query').val().trim()
        # if e.which is 13 #enter
        # $('#query').val ''
        Session.set 'query', query



Template.sort_column_header.events
    'click .sort_by': (e,t)->
        Session.set 'sort_key', @key
        if Session.equals 'sort_direction', '-1'
            Session.set 'sort_direction', '1'
        else if Session.equals 'sort_direction', '1'
            Session.set 'sort_direction', '-1'
Template.table_footer.helpers
    pagination_item_class: ->
        if Session.equals('current_page_number', @number) then 'active' else ''
        
    count_amount: ->
        count_stat = Stats.findOne()
        if count_stat
            count_stat.amount
            
    page_size_button_class: (string_size)->
        number = parseInt string_size
        if Session.equals('page_size', number) then 'blue' else ''
    
    pages: ->
        stat_doc = Stats.findOne()
        if stat_doc
            count_amount = stat_doc.amount
            current_page_size = parseInt Session.get('page_size')
            number_of_pages = Math.ceil(count_amount/current_page_size)
            pages = []
            page = 0
            if number_of_pages>5
                number_of_pages = 5
            while page<number_of_pages
                pages.push {number:page}
                page++
            return pages