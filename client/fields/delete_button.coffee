Template.delete_button.events
    'click #delete': ->
        template = Template.currentData()
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, =>
            # doc = Docs.findOne FlowRouter.getParam('doc_id')
            # Docs.remove doc._id, ->
            #     FlowRouter.go "/docs"
            console.log template