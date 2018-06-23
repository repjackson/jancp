Meteor.startup ->
    Meteor.Mailgun.config
        username: 'portalmailer@sandbox97641e5041e64bfd943374748157462b.mailgun.org'
        password: 'portalmailer'
    return
# In your server code: define a method that the client can call
Meteor.methods 
    sendEmail: (mailFields) ->
        console.log 'about to send email...'
        # check([mailFields.to, mailFields.from, mailFields.subject, mailFields.text, mailFields.html], [String]);
        # Let other method calls from the same client start running,
        # without waiting for the email sending to complete.
        @unblock()
        if Meteor.isProduction
            Meteor.Mailgun.send
                to: mailFields.to
                from: mailFields.from
                subject: mailFields.subject
                text: mailFields.text
                html: mailFields.html
            console.log 'email sent!'
        else
            console.log 'not prod'
            
        return